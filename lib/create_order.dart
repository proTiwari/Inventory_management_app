import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xplode_management/utils.dart';

class CreateorderWidget extends StatefulWidget {
  const CreateorderWidget({Key? key}) : super(key: key);

  @override
  _CreateorderWidgetState createState() => _CreateorderWidgetState();
}

class _CreateorderWidgetState extends State<CreateorderWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getAllLocations();
    getAllCustomers();
  }

  List<String> allLocations = ["Select Location"];
  List<String> allCustomers = ["Select Customer"];
  getAllLocations() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var locations = value.data()!['locations'];
      for (var i in locations) {
        setState(() {
          if (allLocations.contains(i['locationName']) == false) {
            allLocations = [...allLocations, i['locationName']];
          }
          ;
        });
      }
    });
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

  List<String> customers = [
    'Select Customer',
    'Customer 1',
    'Customer 2',
    'Customer 3'
  ];
  List<String> locations = [
    'Select Location',
    'Location 1',
    'Location 2',
    'Location 3'
  ];
  List<String> products = [
    'Select Product',
    'Product 1',
    'Product 2',
    'Product 3'
  ];

  int items = 1;

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
                phone: false,
                tablet: false,
                tabletLandscape: false,
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
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 16,
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
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Colors.deepPurple,
                                            size: 24.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 16,
                                        child: DropdownButtonFormField<String>(
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
                                              selectedLocation = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colors.deepPurple,
                                          size: 24.0,
                                        ),
                                      )
                                    ]),
                                  ),
                                  SizedBox(height: 16.0),
                                  Container(
                                    height: 500,
                                    child: ListView.builder(
                                      itemCount: items,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return index == items - 1
                                            ? Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                          color:
                                                              Colors.deepPurple,
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
                                                                  child:
                                                                      DropdownButtonFormField<
                                                                          String>(
                                                                    value:
                                                                        selectedProduct,
                                                                    hint: Text(
                                                                        'Select product'),
                                                                    items: products
                                                                        .map((String
                                                                            product) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            product,
                                                                        child: Text(
                                                                            product),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        selectedProduct =
                                                                            value!;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      DropdownButtonFormField<
                                                                          String>(
                                                                    value:
                                                                        selectedProduct,
                                                                    hint: Text(
                                                                        'Select Brand'),
                                                                    items: products
                                                                        .map((String
                                                                            product) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            product,
                                                                        child: Text(
                                                                            product),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        selectedProduct =
                                                                            value!;
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 16.0),
                                                            TextField(
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
                                                                    width: 2,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    width: 2,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
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
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  quantity =
                                                                      val;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        items++;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: Icon(
                                                        Icons.add_box_sharp,
                                                        color:
                                                            Colors.deepPurple,
                                                        size: 34.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                      color: Colors.deepPurple,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        DropdownButtonFormField<
                                                            String>(
                                                          value:
                                                              selectedProduct,
                                                          hint: Text(
                                                              'Select product'),
                                                          items: products.map(
                                                              (String product) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: product,
                                                              child:
                                                                  Text(product),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              selectedProduct =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(height: 16.0),
                                                        TextField(
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Quantity',
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .getFont(
                                                              'Roboto',
                                                              color:
                                                                  Colors.black,
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
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .deepPurple,
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        16,
                                                                        24,
                                                                        16,
                                                                        24),
                                                          ),
                                                          style: GoogleFonts
                                                              .getFont(
                                                            'Roboto',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          maxLines: 1,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              quantity = val;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                desktop: true,
                tablet: false,
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
                      onPressed: () {},
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
              if (responsiveVisibility(
                context: context,
                phone: true,
                desktop: false,
                tablet: true,
                tabletLandscape: true,
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
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: selectedCustomer,
                                    hint: Text('Select customer'),
                                    items: customers.map((String customer) {
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
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<String>(
                                    value: selectedLocation,
                                    hint: Text('Select location'),
                                    items: locations.map((String location) {
                                      return DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(location),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedLocation = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<String>(
                                    value: selectedProduct,
                                    hint: Text('Select product'),
                                    items: products.map((String product) {
                                      return DropdownMenuItem<String>(
                                        value: product,
                                        child: Text(product),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedProduct = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  TextField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                      labelStyle: GoogleFonts.getFont(
                                        'Roboto',
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.deepPurple,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.deepPurple,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 24, 16, 24),
                                    ),
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      setState(() {
                                        quantity = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (responsiveVisibility(
                context: context,
                phone: true,
                desktop: false,
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
                      onPressed: () {},
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
                )
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
