import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xplode_management/utils.dart';

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

  List<Map> mapdata = [];
  var tempproduct;
  var tempbrand;
  List tempcompletebrandlist = [];
  int tabedcontainerindex = 0;

  List<String> allLocations = ["Select Location"];
  List<String> allCustomers = ["Select Customer"];
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
            print("wew7");
            brandmap[i.locationName!] = {
              i.product!.pname!: [i.product!.category!]
            };
            print("wew8");
          }
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

  String selectedCustomer = 'Select Customer';
  String selectedLocation = 'Select Location';
  String selectedProduct = 'Select Product';
  String selectedBrand = 'Select Brand';
  String templocation = '';
  bool updatebutton = false;

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

  Widget buildProductOvalContainer(Color color, text, index) {
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
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 14,
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: "Select Customer",
                                              hint: Text('Select customer'),
                                              items: allCustomers
                                                  .map((String customer) {
                                                return DropdownMenuItem<String>(
                                                  value: customer,
                                                  child: Text(customer),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedCustomer = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // showDialog box
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Add Customer'),
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child: Text(
                                                              'Add Customer'),
                                                          onPressed:
                                                              _addCustomer,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.add_circle,
                                                color: Colors.deepPurple,
                                                size: 24.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Row(children: [
                                        Expanded(
                                          flex: 14,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: "Select Location",
                                            hint: Text('Select location'),
                                            items: allLocations
                                                .map((String location) {
                                              return DropdownMenuItem<String>(
                                                value: location,
                                                child: Text(location),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedProduct =
                                                    "Select Product";
                                                items = 1;
                                                products = ["Select Product"];
                                                selectedLocation = value!;

                                                brandmap[selectedLocation]!
                                                    .forEach((key, value) {
                                                  for (var k in value) {
                                                    if (k != "Select Brand") {
                                                      products
                                                          .add("${key} (${k})");
                                                    }
                                                  }
                                                });

                                                // tempquantity1 = totaldata[0]
                                                //     .product!
                                                //     .quantity;
                                              });
                                            },
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: () {
                                        //       // showDialog box
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (context) {
                                        //           return AlertDialog(
                                        //             title: Text('Add Location'),
                                        //             content: Column(
                                        //               mainAxisSize:
                                        //                   MainAxisSize.min,
                                        //               children: <Widget>[
                                        //                 TextField(
                                        //                   controller:
                                        //                       _locationController,
                                        //                   decoration:
                                        //                       InputDecoration(
                                        //                     labelText:
                                        //                         'Location Name',
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //             actions: <Widget>[
                                        //               ElevatedButton(
                                        //                 child: Text('Cancel'),
                                        //                 onPressed: () {
                                        //                   Navigator.of(context)
                                        //                       .pop();
                                        //                 },
                                        //               ),
                                        //               ElevatedButton(
                                        //                 child: Text(
                                        //                     'Add Location'),
                                        //                 onPressed: _addLocation,
                                        //               ),
                                        //             ],
                                        //           );
                                        //         },
                                        //       );
                                        //     },
                                        //     child: Icon(
                                        //       Icons.add_circle,
                                        //       color: Colors.deepPurple,
                                        //       size: 24.0,
                                        //     ),
                                        //   ),
                                        // )
                                      ]),
                                    ),
                                    selectedLocation == 'Select Location'
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
                                                                    i));
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
                                                                      child: DropdownButtonFormField<
                                                                          String>(
                                                                        value:
                                                                            products[0],
                                                                        hint: Text(
                                                                            'Select product'),
                                                                        items: products.map((String
                                                                            product) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                product,
                                                                            child:
                                                                                Text(product),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (String?
                                                                                value) async {
                                                                          setState(
                                                                              () {
                                                                            var product =
                                                                                value.toString().split("(")[0].trim();
                                                                            tempproduct =
                                                                                value!;
                                                                            // tempcompletebrandlist =
                                                                            //     brandmap[selectedLocation]![value]!;
                                                                            print("total data: ${totaldata}");
                                                                            for (Location i
                                                                                in totaldata) {
                                                                              if (i.product!.pname == product && i.product!.category == value.toString().split("(")[1].split(")")[0].trim()) {
                                                                                print(i.product!.quantity);
                                                                                tempquantity1 = i.product!.quantity;
                                                                                print(i.product!.category);
                                                                              }
                                                                            }
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                // Container(
                                                                //   height: 100.0,
                                                                //   child: ListView
                                                                //       .builder(
                                                                //     itemCount:
                                                                //         tempcompletebrandlist
                                                                //             .length,
                                                                //     scrollDirection:
                                                                //         Axis.horizontal,
                                                                //     itemBuilder:
                                                                //         (BuildContext
                                                                //                 context,
                                                                //             int i) {
                                                                //       return tempcompletebrandlist[i] ==
                                                                //               "Select Brand"
                                                                //           ? Container()
                                                                //           : GestureDetector(
                                                                //               onTap: () {
                                                                //                 setState(() {
                                                                //                   tempbrand = tempcompletebrandlist[i];
                                                                //                 });
                                                                //               },
                                                                //               child: buildOvalContainer(tempbrand == tempcompletebrandlist[i] ? Color.fromARGB(255, 115, 132, 231) : Color.fromARGB(255, 115, 218, 231), tempcompletebrandlist[i]));
                                                                //     },
                                                                //   ),
                                                                // ),
                                                                SizedBox(
                                                                    height:
                                                                        16.0),
                                                                TextFormField(
                                                                  controller:
                                                                      _quantityController,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
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
                                                                        () {});
                                                                  },
                                                                ),
                                                                tempquantity1 ==
                                                                        null
                                                                    ? Container()
                                                                    : Text(
                                                                        "Total Quantity available: ${tempquantity1}",
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                6,
                                                                                152,
                                                                                101)),
                                                                      )
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
                                selectedLocation == 'Select Location'
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .deepPurple),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      tempbrand = tempproduct
                                                          .toString()
                                                          .split("(")[1]
                                                          .split(')')[0]
                                                          .trim();
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
                                                          tempproduct != null) {
                                                        mapdata.add({
                                                          "product":
                                                              tempproduct,
                                                          "brand": tempbrand,
                                                          "quantity":
                                                              _quantityController
                                                                  .text
                                                        });
                                                      } else {
                                                        Get.showSnackbar(GetBar(
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
                                                        Get.showSnackbar(GetBar(
                                                          message:
                                                              "Product Added Successfully",
                                                          duration: Duration(
                                                              seconds: 2),
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                        ));
                                                      }
                                                      _quantityController.text =
                                                          '0';
                                                      tempquantity1 = null;
                                                    });
                                                  },
                                                  child: Text(
                                                    "Add Product",
                                                    style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18.0),
                                                  ),
                                                )),
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
                        if (selectedCustomer == '' ||
                            selectedCustomer == 'Select Customer') {
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
                                if (i.locationName == selectedLocation) {
                                  print('okwofjweojfwo3');
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
                                      if (int.parse(i.product!.quantity!) >=
                                          int.parse(k['quantity'])) {
                                        print('okwofjweojfwo5');
                                        i.history!.add(History(
                                            datetime: DateTime.now().toString(),
                                            quantity: k['quantity'],
                                            status: "out",
                                            customername: selectedCustomer,
                                            finalquantity: (int.parse(
                                                        i.product!.quantity!) -
                                                    int.parse(k['quantity']))
                                                .toString(),
                                            initialquantity:
                                                i.product!.quantity!,
                                            pname: k['product']
                                                .toString()
                                                .split("(")[0]
                                                .trim(),
                                                brand: k['brand'],
                                            type: "order"));
                                        print('okwofjweojfwo6');

                                        i.product!.quantity =
                                            (int.parse(i.product!.quantity!) -
                                                    int.parse(k['quantity']))
                                                .toString();
                                        print('okwofjweojfwo7');
                                        anyproductfound = true;
                                      } else {
                                        Get.showSnackbar(GetBar(
                                          message:
                                              "The quantity you mentioned is not available in the inventory",
                                          duration: Duration(seconds: 2),
                                          snackPosition: SnackPosition.BOTTOM,
                                        ));
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
                                  print('okwofjweojfwo9');
                                  Get.showSnackbar(GetBar(
                                    message: "Order created successfully!",
                                    duration: Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM,
                                  ));
                                  print('okwofjweojfwo11');
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
