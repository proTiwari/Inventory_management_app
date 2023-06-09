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
    getDetails();
  }

  var quantity;

  getDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => {});
  }

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
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepPurple,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 240.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
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
                  ),
                ),
              if (responsiveVisibility(
                context: context,
                phone: true,
                desktop: false,
                tablet: true,
                tabletLandscape: true,
              ))
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepPurple,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 240.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
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
