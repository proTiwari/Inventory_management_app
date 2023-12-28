import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:xplode_management/router.dart';
import 'package:xplode_management/search.dart';
import 'package:xplode_management/state.dart';
import 'package:xplode_management/utils.dart';

import 'global_variables.dart';
import 'location_screen.dart';
import 'model/locationproductbrand.dart';
import 'model/owner_model.dart';

class CreateorderWidget extends StatefulWidget {
  const CreateorderWidget({Key? key}) : super(key: key);

  @override
  _CreateorderWidgetState createState() => _CreateorderWidgetState();
}

class Brandmodel {
  String productname;
  String brandname;
  Brandmodel(this.productname, this.brandname);
}

class _CreateorderWidgetState extends State<CreateorderWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<TextEditingController> _brandcontrollers = [];
  List<TextEditingController> _productcontrollers = [];
  List<TextEditingController> _quantitycontrollers = [];
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  var tempquantity1;

  @override
  void initState() {
    super.initState();
    getAllLocations();
    getAllCustomers();
    TextEditingController controller = TextEditingController();
    controller.text = "Select Product";
    _productcontrollers.add(controller);
    TextEditingController controller1 = TextEditingController();
    controller1.text = "0";
    _quantitycontrollers.add(controller1);
    TextEditingController controller2 = TextEditingController();
    controller2.text = "Select Brand";
    _brandcontrollers.add(controller2);
  }

  var _errorText;

  var Oid;
  List OidList = [];

  _validateInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a quantity';
    }
    final numericValue = int.tryParse(value);
    if (numericValue == null) {
      return 'Please enter a valid quantity';
    }
    if (numericValue > int.parse(FFAppState().tempquantity) - tempqt) {
      return 'quantity cannot be greater than ${int.parse(FFAppState().tempquantity) - tempqt}';
    }
    return null;
  }

  List<Map> mapdata = [];
  var tempproduct;
  var tempbrand;
  List tempcompletebrandlist = [];
  int tabedcontainerindex = 0;

  List<String> allLocations = [];
  List<String> allCustomers = [];
  List allproductname = [];
  var daata = [];
  var totaldata = [];
  Map<String, Map<String, List<String>>> brandmap = {};
  getAllLocations() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var locations = value.data()!['locations'].map((e) {
        return Location.fromJson(e);
      }).toList();
      totaldata = locations;
      locations.map((e) {
        return print("skdsl: ${e.toJson()}");
      }).toList();
      FFAppState().locations = locations;
      for (Location i in locations) {
        try {
          if (brandmap.containsKey(i.locationName)) {
            print("wew1");
            if (brandmap[i.locationName]!.containsKey(i.product!.pname)) {
              print("wew2");
              if (brandmap[i.locationName]![i.product!.pname]!
                      .contains(i.product!.category) ==
                  false) {
                print("wew3");
                brandmap[i.locationName]![i.product!.pname]!
                    .add(i.product!.category!);
                print("wew4");
              }
            } else {
              print("wew5");
              brandmap[i.locationName]![i.product!.pname!] = [
                i.product!.category!
              ];
              print("wew6");
            }
          } else {
            print("wew73");
            print(brandmap);
            print(brandmap[i.locationName!]);
            print(i.product!.pname!);
            print(i.product!.category!);
            brandmap[i.locationName!] = {
              i.product!.pname!: [i.product!.category!]
            };
            print("wew8");
          }
          FFAppState().brandmap = brandmap;
          // if (allproductname.contains(i.product!.pname) == false) {
          //   allproductname.add(i.product!.pname);
          // }
        } catch (e) {
          print("uyguyguyguy ${e}");
        }
        setState(() {
          if (allLocations.contains(i.locationName) == false) {
            allLocations = [...allLocations, i.locationName!];
          }
          ;
        });
      }

      Map<String, Map<String, List<String>>> finalmap = {};
      List listofkeys = [];
      setState(() {
        for (var j in brandmap.keys) {
          listofkeys.add(j);
          brandmap[j]!.forEach((key, value) {
            brandmap[j]![key] = ['Select Brand'] + value.toSet().toList();
          });
        }
        var list = [];
        for (var v in brandmap.values) {
          v["Select Product"] = ['Select Brand'];
          v = rearrangeMap(v);
          list.add(v);

          print("v is ${v.toString()}");
        }
        for (var i = 0; i < listofkeys.length; i++) {
          finalmap[listofkeys[i]] = list[i];
        }
        brandmap = finalmap;

        print("brandmap ejiwe " + brandmap.toString());
      });
    });
  }

  Map<String, List<String>> rearrangeMap(
      Map<String, List<String>> originalMap) {
    List<MapEntry<String, List<String>>> entries = originalMap.entries.toList();
    MapEntry<String, List<String>> lastEntry = entries.removeLast();
    entries.insert(0, lastEntry);

    return Map.fromEntries(entries);
  }

  getAllCustomers() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var customers = value.data()!['customer'];
      for (var i in customers) {
        setState(() {
          if (allCustomers.contains(i) == false) {
            allCustomers = [...allCustomers, i];
          }
          ;
        });
      }
    });
  }

  var quantity;

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  void Changeboolfunlocation() {
    print("sjdfojsodfjs99999999999999");
    setState(() {
      boolsearchlocation = false;
    });
  }

  void Changeboolfuncustomer() {
    print("sjdfojsodfjs99999999999999");
    setState(() {
      boolsearchcustomer = false;
    });
  }

  void Changeboolfunproduct() {
    print("sjdfojsodfjs99999999999999");
    setState(() {
      boolsearchproduct = false;
    });
  }

  String selectedCustomer = 'Select Customer';
  String selectedLocation = 'Select Location';
  String selectedProduct = 'Select Product';
  String selectedBrand = 'Select Brand';
  String templocation = '';
  bool updatebutton = false;
  bool boolsearchcustomer = false;
  bool boolsearchlocation = false;
  bool boolsearchproduct = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  List<String> products = [
    'Select Product',
  ];

  int items = 1;

  Future<void> _addLocation() async {
    String locationName = _locationController.text;
    print(locationName);
    if (_locationController.text.isEmpty) {
      return;
    }
    bool alreadyExists = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      List<Location> locations = [];
      for (var k in value.data()!['locations']) {
        locations.add(Location.fromJson(k));
      }
      print(locations.length);
      for (Location i in locations) {
        try {
          if (i.locationName == locationName) {
            Get.showSnackbar(GetBar(
              message: 'Location Already Exists',
              duration: Duration(seconds: 2),
            ));
            print("i-locationName${i.locationName}");
            print(locationName);
            alreadyExists = true;
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
    if (alreadyExists == true) {
      print('already exists');
      return;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'locations': FieldValue.arrayUnion([
          {
            "locationName": locationName,
            "product": {},
            "history": [],
          }
        ])
      }).whenComplete(() {
        setState(() {
          allLocations = [...allLocations, locationName];
        });
        Get.showSnackbar(GetBar(
          message: 'Location Added',
          duration: Duration(seconds: 2),
        ));
      });
    }

    // Perform your desired action with the entered data here
    Navigator.of(context).pop(); // Close the dialog box
  }

  Future<void> _addCustomer() async {
    String name = _nameController.text;
    if (_nameController.text.isEmpty) {
      return;
    }
    bool alreadyExists = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      List customer = value.data()!['customer'];

      for (var i in customer) {
        try {
          if (i == name) {
            Get.showSnackbar(GetBar(
              message: 'Customer Already Exists',
              duration: Duration(seconds: 2),
            ));
            alreadyExists = true;
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
    if (alreadyExists == true) {
      print('already exists');
      return;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'customer': FieldValue.arrayUnion([name])
      }).whenComplete(() {
        setState(() {
          allCustomers = [...allCustomers, _nameController.text];
          // a code for removing duplicates from allCustomers list

          allCustomers = allCustomers.toSet().toList();
        });
        Get.showSnackbar(GetBar(
          message: 'Customer Added',
          duration: Duration(seconds: 2),
        ));
      });
    }

    // Perform your desired action with the entered data here
    Navigator.of(context).pop(); // Close the dialog box
  }

  Widget buildProductOvalContainer(Color color, text, index, quantity) {
    return Card(
      color: Colors.deepPurple,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Row(
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                    Text(
                      "Qty: ${quantity}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mapdata.removeAt(index);
                    });
                  },
                  child: Icon(Icons.close, color: Colors.white, size: 20.0))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOvalContainer(Color color, text) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 140.0,
      height: 20.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  int tempqt = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              if (responsiveVisibility(
                context: context,
                phone: true,
                tablet: true,
                tabletLandscape: true,
                desktop: true,
              ))
                Expanded(
                  flex: 13,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SizedBox(
                            height: 570,
                            child: ListView(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 12,
                                            child: boolsearchcustomer
                                                ? Search(allCustomers,
                                                    Changeboolfuncustomer, "c")
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        boolsearchcustomer =
                                                            true;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        enabled: false,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${FFAppState().customer}',
                                                          hintStyle: TextStyle(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  0,
                                                                  0)),
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                            //     DropdownButtonFormField<String>(
                                            //   value: "Select Customer",
                                            //   hint: Text('Select customer'),
                                            //   items: allCustomers
                                            //       .map((String customer) {
                                            //     return DropdownMenuItem<String>(
                                            //       value: customer,
                                            //       child: Text(customer),
                                            //     );
                                            //   }).toList(),
                                            //   onChanged: (String? value) {
                                            //     setState(() {
                                            //       selectedCustomer = value!;
                                            //     });
                                            //   },
                                            // ),
                                            ),
                                        GestureDetector(
                                          onTap: () {
                                            // showDialog box
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Add Customer'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      TextField(
                                                        controller:
                                                            _nameController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Customer Name',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          Text('Add Customer'),
                                                      onPressed: _addCustomer,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Icon(
                                              Icons.add_box,
                                              color: Colors.deepPurple,
                                              size: 50.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    Row(children: [
                                      Expanded(
                                          flex: 14,
                                          child: boolsearchlocation
                                              ? Search(allLocations,
                                                  Changeboolfunlocation, 'l')
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      boolsearchlocation = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              255, 255, 255)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            '${FFAppState().location}',
                                                        hintStyle: TextStyle(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255, 0, 0, 0)),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                    ]),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          dateTimeList =
                                              await showOmniDateTimePicker(
                                            context: context,
                                            type: OmniDateTimePickerType.date,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1600).subtract(
                                                const Duration(days: 3652)),
                                            lastDate: DateTime.now().add(
                                              const Duration(days: 3652),
                                            ),
                                            is24HourMode: true,
                                            isShowSeconds: false,
                                            minutesInterval: 1,
                                            secondsInterval: 1,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16)),
                                            constraints: const BoxConstraints(
                                              maxWidth: 350,
                                              maxHeight: 650,
                                            ),
                                            transitionBuilder:
                                                (context, anim1, anim2, child) {
                                              return FadeTransition(
                                                opacity: anim1.drive(
                                                  Tween(
                                                    begin: 0,
                                                    end: 1,
                                                  ),
                                                ),
                                                child: child,
                                              );
                                            },
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            barrierDismissible: true,
                                          );

                                          setState(() {
                                            dateTimeList;
                                            dateTimeList =
                                                "${dateTimeList.toString().split(" ")[0]} ${DateTime.now().toString().split(" ")[1]}";
                                          });

                                          // code for doing filter
                                          for (var i in FFAppState().product) {
                                            var productname;
                                            var brandname;
                                            productname = i
                                                .toString()
                                                .split("(")[0]
                                                .trim();
                                            brandname = i
                                                .toString()
                                                .split("(")[1]
                                                .split(')')[0]
                                                .trim();

                                            for (Location j in totaldata) {
                                              if (j.product!.pname ==
                                                      productname &&
                                                  j.product!.category ==
                                                      brandname) {
                                                var maxdate =
                                                    "2003-07-06 23:02:11.098";
                                                var quant;
                                                for (History k in j.history!) {
                                                  if (dateTimeList.compareTo(
                                                              k.datetime) >
                                                          0 ||
                                                      dateTimeList.compareTo(
                                                              k.datetime) ==
                                                          0) {
                                                    if (k.datetime!.compareTo(
                                                            maxdate) >
                                                        0) {
                                                      maxdate = k.datetime!;
                                                      quant = k.finalquantity;
                                                    }
                                                  }
                                                }
                                                if (quant == null ||
                                                    quant == '0') {
                                                  FFAppState()
                                                      .product
                                                      .remove(i);
                                                }
                                              }
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.deepPurple),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            )),
                                        child: dateTimeList == null
                                            ? Center(
                                                child: Text("Select Date",
                                                    style: TextStyle(
                                                        color: Colors.white)))
                                            : Center(
                                                child: Text(
                                                  "${dateTimeList.toString().split(" ")[0]}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                      ),
                                    ),
                                    FFAppState().location ==
                                                'Select Location' ||
                                            dateTimeList == null
                                        ? Container()
                                        : Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 60.0,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              mapdata.length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            mapdata.sort((a,
                                                                    b) =>
                                                                a['date']
                                                                    .compareTo(b[
                                                                        'date']));
                                                            return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    print(
                                                                        "mapdata ${mapdata}");
                                                                    print(
                                                                        "mapdata ${mapdata[i]}");
                                                                    updatebutton =
                                                                        true;
                                                                    tabedcontainerindex =
                                                                        i;
                                                                  });
                                                                },
                                                                child: buildProductOvalContainer(
                                                                    Color.fromARGB(
                                                                        255,
                                                                        92,
                                                                        148,
                                                                        231),
                                                                    "${mapdata[i]['product']}",
                                                                    i,
                                                                    "${mapdata[i]['quantity']}"));
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .deepPurple,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: boolsearchproduct
                                                                          ? Search(FFAppState().product, Changeboolfunproduct, 'p')
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  boolsearchproduct = true;
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                  color: Colors.grey.shade300,
                                                                                ),
                                                                                padding: EdgeInsets.all(8.0),
                                                                                child: TextField(
                                                                                  enabled: false,
                                                                                  decoration: InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                    hintText: '${FFAppState().productvalue}',
                                                                                    hintStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        16.0),
                                                                SizedBox(
                                                                  width: 16,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _quantityController,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            192,
                                                                            13,
                                                                            13),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            192,
                                                                            13,
                                                                            13),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorText:
                                                                        _errorText,
                                                                    labelText:
                                                                        'Quantity',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .getFont(
                                                                      'Roboto',
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            16,
                                                                            24,
                                                                            16,
                                                                            24),
                                                                  ),
                                                                  style: GoogleFonts
                                                                      .getFont(
                                                                    'Roboto',
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                  maxLines: 1,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      _errorText =
                                                                          _validateInput(
                                                                              val);
                                                                    });
                                                                  },
                                                                ),
                                                                FFAppState().tempquantity ==
                                                                        'null'
                                                                    ? Container()
                                                                    : Column(
                                                                        children: [
                                                                          Text(
                                                                            "Total Quantity available: ${int.parse(FFAppState().tempquantity) - tempqt}",
                                                                            style:
                                                                                TextStyle(color: Color.fromARGB(255, 6, 152, 101)),
                                                                          ),
                                                                          _errorText == null && _quantityController.text.isNotEmpty && FFAppState().tempquantity.toString() != 'null' && int.parse(_quantityController.text.toString()) < (int.parse(FFAppState().tempquantity.toString()) - tempqt)
                                                                              ? Text(
                                                                                  "After Sale Qty: ${int.parse(FFAppState().tempquantity.toString()) - tempqt - int.parse(_quantityController.text.toString())}",
                                                                                  style: TextStyle(color: Color.fromARGB(255, 238, 99, 0)),
                                                                                )
                                                                              : Container(),
                                                                        ],
                                                                      ),
                                                                SizedBox(
                                                                    height:
                                                                        16.0),
                                                                TextFormField(
                                                                  controller:
                                                                      _desController,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            192,
                                                                            13,
                                                                            13),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    labelText:
                                                                        'Description(Optional)',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .getFont(
                                                                      'Roboto',
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            16,
                                                                            24,
                                                                            16,
                                                                            24),
                                                                  ),
                                                                  style: GoogleFonts
                                                                      .getFont(
                                                                    'Roboto',
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                  maxLines: 1,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 16.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                FFAppState().location == 'Select Location' ||
                                        dateTimeList == null
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.deepPurple),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (int.parse(
                                                          _quantityController
                                                              .text
                                                              .toString()) <=
                                                      int.parse(FFAppState()
                                                              .tempquantity
                                                              .toString()) -
                                                          tempqt) {
                                                    tempproduct = FFAppState()
                                                        .productvalue;
                                                    tempbrand = tempproduct
                                                        .toString()
                                                        .split("(")[1]
                                                        .split(')')[0]
                                                        .trim();
                                                    if (dateTimeList == null) {
                                                      Get.showSnackbar(GetBar(
                                                        message:
                                                            "Please select date!",
                                                        duration: Duration(
                                                            seconds: 2),
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                      ));
                                                    } else {
                                                      if (!isNumeric(
                                                          _quantityController
                                                              .text)) {
                                                        Get.showSnackbar(GetBar(
                                                          message:
                                                              "Please enter a valid quantity",
                                                          duration: Duration(
                                                              seconds: 2),
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                        ));
                                                      } else {
                                                        if (_quantityController
                                                                    .text !=
                                                                "0" &&
                                                            tempproduct != "" &&
                                                            tempproduct !=
                                                                "Select Product" &&
                                                            _quantityController
                                                                    .text !=
                                                                "Select Quantity" &&
                                                            _quantityController
                                                                    .text !=
                                                                "" &&
                                                            tempproduct !=
                                                                null) {
                                                          mapdata.add({
                                                            "tempquantity":
                                                                FFAppState()
                                                                    .tempquantity
                                                                    .toString(),
                                                            "product":
                                                                tempproduct,
                                                            "brand": tempbrand,
                                                            "quantity":
                                                                _quantityController
                                                                    .text,
                                                            "date":
                                                                dateTimeList,
                                                            "description":
                                                                _desController
                                                                    .text,
                                                          });
                                                        } else {
                                                          Get.showSnackbar(
                                                              GetBar(
                                                            message:
                                                                "Please fill all the fields",
                                                            duration: Duration(
                                                                seconds: 2),
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                          ));
                                                        }
                                                        if (_quantityController
                                                                .text !=
                                                            "0") {
                                                          Get.showSnackbar(
                                                              GetBar(
                                                            message:
                                                                "Product Added Successfully",
                                                            duration: Duration(
                                                                seconds: 2),
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                          ));
                                                        }
                                                      }
                                                    }

                                                    _quantityController.text =
                                                        '0';
                                                    tempquantity1 = null;
                                                    FFAppState().tempquantity =
                                                        'null';
                                                    FFAppState().productvalue =
                                                        'Select Product';
                                                    _desController.text = "";
                                                  } else {
                                                    Get.showSnackbar(GetBar(
                                                      message:
                                                          "Quantity should be less than available quantity",
                                                      duration:
                                                          Duration(seconds: 2),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                    ));
                                                  }
                                                });
                                              },
                                              child: Text(
                                                "Add Product",
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (responsiveVisibility(
                context: context,
                phone: true,
                desktop: true,
                tablet: true,
                tabletLandscape: true,
              ))
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                          backgroundColor: Color(0xFF4B39EF)),
                      onPressed: () async {
                        bool anyproductfound = false;
                        if (FFAppState().customer == "Select Customer") {
                          Get.showSnackbar(GetBar(
                            message: "Please select a customer",
                            duration: Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM,
                          ));
                          return;
                        } else {
                          if (mapdata.length == 0) {
                            Get.showSnackbar(GetBar(
                              message: "Please add atleast one product",
                              duration: Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM,
                            ));
                          } else {
                            List<Location> data = [];
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get()
                                .then((value) {
                              print('okwofjweojfwo1');
                              data =
                                  (value.data()!['locations'] as List<dynamic>)
                                      .map((e) => Location.fromJson(e))
                                      .toList();
                              print('okwofjweojfwo2');
                              for (var i in data) {
                                if (i.locationName == FFAppState().location) {
                                  print('okwofjweojfwo3');
                                  mapdata.sort(
                                      (a, b) => a['date'].compareTo(b['date']));
                                  for (var k in mapdata) {
                                    print(i.product!.pname);
                                    print(k['product']
                                        .toString()
                                        .split("(")[0]
                                        .trim());
                                    print(i.product!.category);
                                    print(k['brand']);
                                    if (i.product!.pname ==
                                            k['product']
                                                .toString()
                                                .split("(")[0]
                                                .trim() &&
                                        i.product!.category == k['brand']) {
                                      print('okwofjweojfwo4');
                                      print(k['tempquantity']);
                                      if (int.parse(k['tempquantity']) >=
                                          int.parse(k['quantity'])) {
                                        print('okwofjweojfwo5');
                                        print(k);
                                        Oid = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString() +
                                            Random().nextInt(10000).toString();
                                        OidList.add(Oid);
                                        print('eifjewfwefw');
                                        try {
                                          i.history!.add(History(
                                              id: Oid,
                                              datetime: k['date'].toString(),
                                              description: k['description'],
                                              quantity: k['quantity'],
                                              status: "out",
                                              customername:
                                                  FFAppState().customer,
                                              finalquantity: (int.parse(
                                                          k['tempquantity']) -
                                                      int.parse(k['quantity']))
                                                  .toString(),
                                              initialquantity:
                                                  k['tempquantity'],
                                              pname: k['product']
                                                  .toString()
                                                  .split("(")[0]
                                                  .trim(),
                                              brand: k['brand'],
                                              type: "order"));
                                        } catch (e) {
                                          print("error id oiwfjoweijo: ${e}");
                                          i.history!.add(History(
                                              id: Oid,
                                              datetime: k['date'].toString(),
                                              description: k['description'],
                                              quantity: k['quantity'],
                                              status: "out",
                                              customername:
                                                  FFAppState().customer,
                                              finalquantity: (int.parse(
                                                          k['tempquantity']) -
                                                      int.parse(k['quantity']))
                                                  .toString(),
                                              initialquantity:
                                                  k['tempquantity'],
                                              pname: k['product']
                                                  .toString()
                                                  .split("(")[0]
                                                  .trim(),
                                              brand: k['brand'],
                                              type: "order"));
                                        }

                                        print('okwofjweojfwo6');

                                        i.product!.quantity =
                                            (int.parse(i.product!.quantity!) -
                                                    int.parse(k['quantity']))
                                                .toString();
                                        print('okwofjweojfwo7');
                                        anyproductfound = true;
                                        break;
                                      } else {
                                        Get.showSnackbar(GetBar(
                                          message:
                                              "The quantity you mentioned is not available in the inventory",
                                          duration: Duration(seconds: 2),
                                          snackPosition: SnackPosition.BOTTOM,
                                        ));
                                        break;
                                      }
                                    }
                                  }
                                }
                              }
                              print(
                                  'okwofjweojfwo8 ${data.map((e) => print(e.toJson())).toList()}');
                              data.map((e) => print(e.toJson())).toList();
                            }).whenComplete(() async {
                              if (anyproductfound == true) {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "locations":
                                      data.map((e) => e.toJson()).toList()
                                }).whenComplete(() {
                                  setState(() {
                                    mapdata.clear();
                                  });
                                  // CODE FOR UPDATING ALL FUTHER PRODUCTS
                                  try {
                                    var id = Oid;
                                    print("lid: $id");
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .get()
                                        .then((value) {
                                      OwnerModel data = OwnerModel.fromJson(
                                          value.data() as Map<String, dynamic>);
                                      print('klklk');
                                      var quantity;
                                      var date;

                                      for (Location i in data.locations!) {
                                        print('hhh');
                                        try {
                                          for (History j in i.history!) {
                                            print('klklkmmm');
                                            try {
                                              if (OidList.contains(j.id)) {
                                                quantity = j.quantity;
                                                date = j.datetime;
                                                var diddff;
                                                bool decor = false;
                                                print('klklbnbk');
                                                for (History n in i.history!) {
                                                  print('klklkmdrgermm');
                                                  try {
                                                    if (n.datetime!
                                                            .compareTo(date) >
                                                        0) {
                                                      print('iejiwoejfoiww');

                                                      decor = false;
                                                      print('klklkmdr9990wo');

                                                      try {
                                                        int diff1 = int.parse(
                                                            quantity
                                                                .toString());
                                                        n.initialquantity =
                                                            (int.parse(n.initialquantity!) -
                                                                    diff1)
                                                                .toString();
                                                        n.finalquantity =
                                                            (int.parse(n.finalquantity!) -
                                                                    diff1)
                                                                .toString();
                                                        diddff = diff1;
                                                        print(
                                                            'diffk1: ${diff1}');
                                                        print(n.finalquantity);
                                                      } catch (e) {
                                                        print(
                                                            'oweioij: ${e.toString()}');
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print("errorhjkl'jj: $e");
                                                  }
                                                }
                                                try {
                                                  print("iwoejwo");
                                                  print(
                                                      '${j.quantity} ${j.description} ${j.datetime}');
                                                } catch (e) {
                                                  print("w  e $e");
                                                }
                                              }
                                            } catch (e) {
                                              print("errorhjj: $e");
                                            }
                                          }
                                        } catch (e) {
                                          print("errorhjjk: $e");
                                        }
                                      }

                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "locations": data.locations!
                                            .map((e) => e.toJson())
                                            .toList()
                                      });
                                    });
                                  } catch (e) {
                                    print("sdsddd: ${e}");
                                  }
                                  setState(() {
                                    FFAppState().customer = 'Select Customer';
                                    FFAppState().location = 'Select Location';
                                  });
                                  print('okwofjweojfwo9');
                                  Get.showSnackbar(GetBar(
                                    message: "Order created successfully!",
                                    duration: Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM,
                                  ));
                                  print('okwofjweojfwo11');
                                  Get.offAll(() => LocationlistWidget(),
                                      arguments: "c");
                                });
                              } else {
                                Get.showSnackbar(GetBar(
                                  message: "Order not created!",
                                  duration: Duration(seconds: 2),
                                  snackPosition: SnackPosition.BOTTOM,
                                ));
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        'Create Order',
                        style: GoogleFonts.getFont(
                          'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isNumeric(String value) {
    final numericValue = num.tryParse(value);
    return numericValue != null;
  }
}

class DropdownButtonExample extends StatefulWidget {
  var list = ["yuyu"];
  DropdownButtonExample(this.list, {Key? key}) : super(key: key);

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: DropdownButton<String>(
        value: widget.list[0],
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            // dropdownValue = value!;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
