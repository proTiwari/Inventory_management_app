import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xplode_management/router.dart';

import 'model/owner_model.dart';

class ProductlistWidget extends StatefulWidget {
  const ProductlistWidget({Key? key}) : super(key: key);

  @override
  _ProductlistWidgetState createState() => _ProductlistWidgetState();
}

class _ProductlistWidgetState extends State<ProductlistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var location;
  List<Product> uniqueList = [];
  TextEditingController editTextController = TextEditingController();
  TextEditingController locationsearchcontroller = TextEditingController();
  List<Product> matchQuery = [];
  @override
  void initState() {
    super.initState();

    location = Get.arguments;
    editTextController.text = "";
    // testfun();
    locationsearchcontroller.addListener(() {
      print("printing text ${locationsearchcontroller.text}");
      print("uniqueList ${uniqueList}");
      matchQuery = uniqueList
          .where((item) => item.pname!
              .toLowerCase()
              .contains(locationsearchcontroller.text.toLowerCase()))
          .toList();

      setState(() {
        matchQuery;
      });
      print(matchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF4B39EF),
        appBar: AppBar(
          backgroundColor: Color(0xFF4B39EF),
          automaticallyImplyLeading: false,
          title: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                ],
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAllNamed(AppRoutes.loginscreen);
                },
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 0,
                initialIndex: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: locationsearchcontroller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 12,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F4F8),
                                  ),
                                  child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .snapshots(), // Replace with your actual stream
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasData) {
                                        OwnerModel data = OwnerModel.fromJson(
                                            snapshot.data!.data()
                                                as Map<String, dynamic>);
                                        List<Product> datalist = [];
                                        for (Location i in data.locations!) {
                                          if (i.locationName == location) {
                                            datalist.add(i.product!);
                                          }
                                        }
                                        uniqueList = [];

                                        for (Product i in datalist) {
                                          try {
                                            if (uniqueList.length == 0) {
                                              uniqueList.add(i);
                                            } else {
                                              if (uniqueList
                                                      .where((element) =>
                                                          element.pname ==
                                                          i.pname)
                                                      .toList()
                                                      .length ==
                                                  0) {
                                                uniqueList.add(i);
                                              }
                                            }
                                          } catch (e) {
                                            print("isjdofjiwoe:: ${e}");
                                          }
                                        }
                                        print("wefwefwfw$uniqueList");
                                        print(datalist);
                                        return locationsearchcontroller
                                                .text.isEmpty
                                            ? ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: datalist.length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .productactivity,
                                                          arguments: [
                                                            datalist[index],
                                                            location
                                                          ]);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        datalist[index].pname ==
                                                                null
                                                            ? Container()
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            8,
                                                                            16,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            3,
                                                                        color: Color(
                                                                            0x20000000),
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            8,
                                                                            12,
                                                                            8),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text('${datalist[index].pname} ',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                                          color: Color(0xFF14181B),
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        )),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 18.0),
                                                                                      child: Icon(
                                                                                        Icons.arrow_forward_outlined,
                                                                                        color: Color(0xFF4B39EF),
                                                                                        size: 18,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 20.0),
                                                                                      child: Text("${datalist[index].quantity}", style: TextStyle(color: Color(0xFF4B39EF))),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  editTextController.text = datalist[index].pname!;
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (ctx) => AlertDialog(
                                                                                      title: Text('Edit'),
                                                                                      content: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          TextFormField(
                                                                                            controller: editTextController,
                                                                                            decoration: InputDecoration(
                                                                                              labelText: 'Product Name',
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: <Widget>[
                                                                                        ElevatedButton(
                                                                                          child: Text('Cancel'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          child: Text('Save'),
                                                                                          onPressed: () {
                                                                                            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                              List<dynamic> locations = value.data()!["locations"];

                                                                                              for (var i in locations) {
                                                                                                if (i["product"]['pname'] == datalist[index].pname!) {
                                                                                                  i["product"]['pname'] = "${editTextController.text}";
                                                                                                }
                                                                                              }
                                                                                              FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                                "locations": locations
                                                                                              });
                                                                                            });
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.edit_outlined,
                                                                                  color: Color(0xFF4B39EF),
                                                                                  size: 24,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                editTextController.text = datalist[index].pname!;
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (ctx) => AlertDialog(
                                                                                    title: Text('Delete'),
                                                                                    content: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: <Widget>[
                                                                                        TextFormField(
                                                                                          enabled: false,
                                                                                          controller: editTextController,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Are you sure you want to delete this product?',
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      ElevatedButton(
                                                                                        child: Text('No'),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        child: Text('Yes'),
                                                                                        onPressed: () {
                                                                                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                            List<dynamic> locations = value.data()!["locations"];

                                                                                            for (var i in locations) {
                                                                                              if (i["product"]['pname'] == datalist[index].pname!) {
                                                                                                locations.remove(i);
                                                                                              }
                                                                                            }
                                                                                            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                              "locations": locations
                                                                                            });
                                                                                          });
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Icon(
                                                                                Icons.delete_sharp,
                                                                                color: Color(0xFF4B39EF),
                                                                                size: 24,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: matchQuery.length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .productactivity,
                                                          arguments: [
                                                            datalist[index],
                                                            location
                                                          ]);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        matchQuery[index]
                                                                    .pname ==
                                                                null
                                                            ? Container()
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            8,
                                                                            16,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            3,
                                                                        color: Color(
                                                                            0x20000000),
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            8,
                                                                            12,
                                                                            8),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text('${matchQuery[index].pname} ',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                                          color: Color(0xFF14181B),
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        )),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 18.0),
                                                                                      child: Icon(
                                                                                        Icons.arrow_forward_outlined,
                                                                                        color: Color(0xFF4B39EF),
                                                                                        size: 18,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 20.0),
                                                                                      child: Text("${matchQuery[index].quantity}", style: TextStyle(color: Color(0xFF4B39EF))),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  editTextController.text = matchQuery[index].pname!;
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (ctx) => AlertDialog(
                                                                                      title: Text('Edit'),
                                                                                      content: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          TextFormField(
                                                                                            controller: editTextController,
                                                                                            decoration: InputDecoration(
                                                                                              labelText: 'Product Name',
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: <Widget>[
                                                                                        ElevatedButton(
                                                                                          child: Text('Cancel'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          child: Text('Save'),
                                                                                          onPressed: () {
                                                                                            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                              List<dynamic> locations = value.data()!["locations"];

                                                                                              for (var i in locations) {
                                                                                                if (i["product"]['pname'] == matchQuery[index].pname!) {
                                                                                                  i["product"]['pname'] = "${editTextController.text}";
                                                                                                }
                                                                                              }
                                                                                              FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                                "locations": locations
                                                                                              });
                                                                                            });
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.edit_outlined,
                                                                                  color: Color(0xFF4B39EF),
                                                                                  size: 24,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                editTextController.text = matchQuery[index].pname!;
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (ctx) => AlertDialog(
                                                                                    title: Text('Delete'),
                                                                                    content: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: <Widget>[
                                                                                        TextFormField(
                                                                                          enabled: false,
                                                                                          controller: editTextController,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Are you sure you want to delete this product?',
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      ElevatedButton(
                                                                                        child: Text('No'),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        child: Text('Yes'),
                                                                                        onPressed: () {
                                                                                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                            List<dynamic> locations = value.data()!["locations"];

                                                                                            for (var i in locations) {
                                                                                              if (i["product"]['pname'] == matchQuery[index].pname!) {
                                                                                                locations.remove(i);
                                                                                              }
                                                                                            }
                                                                                            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                              "locations": locations
                                                                                            });
                                                                                          });
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Icon(
                                                                                Icons.delete_sharp,
                                                                                color: Color(0xFF4B39EF),
                                                                                size: 24,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                      } else if (snapshot.hasError) {
                                        // Handle error from the stream
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        // Render a placeholder or loading indicator
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  )),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      child: Text(
                                        'Add Quantity',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4B39EF),
                                        // side: BorderSide(color: Colors.yellow, width: 5),
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal),
                                        shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EditProductInputDialog(
                                                location);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      child: Text(
                                        'View Activity',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4B39EF),
                                        // side: BorderSide(color: Colors.yellow, width: 5),
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal),
                                        shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(AppRoutes.activity,
                                            arguments: location);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddProductInputDialog(location);
                    },
                  );
                },
                backgroundColor: Color(0xFF4B39EF),
                elevation: 8,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddProductInputDialog(location);
                    },
                  );
                },
                backgroundColor: Color(0xFF4B39EF),
                elevation: 8,
                child: Icon(
                  Icons.download_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductInputDialog extends StatefulWidget {
  var location;
  AddProductInputDialog(this.location);

  @override
  _AddProductInputDialogState createState() => _AddProductInputDialogState();
}

class _AddProductInputDialogState extends State<AddProductInputDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    if (_nameController.text.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      List<Location> locations = [];
      for (var k in value.data()!['locations']) {
        locations.add(Location.fromJson(k));
      }
      for (Location i in locations) {
        try {
          if (i.locationName == widget.location) {
            print("location found ${i.locationName}");
            print("product found1 ${i.product}");
            print("product name: ${i.product!.pname}");
            if (i.product!.pname == null) {
              print("product found2 ${i.product}");
              locations.remove(i);
            }
          }
        } catch (e) {
          print("this is the error ${e}");
        }
      }
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "locations": locations.map((locations) => locations.toJson()).toList()
        });
      } catch (e) {
        print("this is the error2 ${e}");
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'locations': FieldValue.arrayUnion([
        {
          "locationName": widget.location,
          "product": {
            "category": _categoryController.text,
            "datetime": DateTime.now().toString(),
            "pname": _nameController.text,
            "quantity": "0"
          },
          "history": [
            {
              "datetime": DateTime.now().toString(),
              "status": "in",
              "type": "add",
              "pname": _nameController.text
            }
          ],
        }
      ])
    }).whenComplete(() {
      Get.showSnackbar(GetBar(
        message: 'Product Added',
        duration: Duration(seconds: 2),
      ));
    });
    // Perform your desired action with the entered data here
    Navigator.of(context).pop(); // Close the dialog box
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Category',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Add Product'),
          onPressed: _addProduct,
        ),
      ],
    );
  }
}

class EditProductInputDialog extends StatefulWidget {
  var location;
  EditProductInputDialog(this.location);

  @override
  _EditProductInputDialogState createState() => _EditProductInputDialogState();
}

class _EditProductInputDialogState extends State<EditProductInputDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  List<String> productlist = ["select product"];
  List<Product> productdatalist = [];
  @override
  void initState() {
    super.initState();
    getdata(widget.location);
  }

  getdata(location) async {
    print("started");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print("started1");
      OwnerModel data =
          OwnerModel.fromJson(value.data() as Map<String, dynamic>);
      print("started2 $data");
      for (Location i in data.locations!) {
        try {
          print("started3");
          if (i.locationName == location) {
            setState(() {
              productlist.add(i.product!.pname!);
              productdatalist.add(i.product!);
            });
          }
        } catch (e) {
          print("error id sjfowjieo: ${e.toString()}");
        }
      }
    });
  }

  void _editProduct() async {
    try {
      print("isofwjeo1");
      String productName = _nameController.text;
      print("isofwjeo2");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        print("isofwjeo3");
        OwnerModel data =
            OwnerModel.fromJson(value.data() as Map<String, dynamic>);
        for (Location i in data.locations!) {
          print("isofwjeo4");
          try {
            if (i.locationName == widget.location) {
              print("isofwjeo5");
              print(productName);
              print(i.product!.pname);
              if (productName == i.product!.pname) {
                print("isofwjeo6");

                var quantity = i.product!.quantity;
                var finalquantity =
                    (int.parse(quantity!) + int.parse(_quantityController.text))
                        .toString();
                i.product!.quantity = finalquantity;
                i.product!.description = _descriptionController.text;
                var status;
                if (int.tryParse(_quantityController.text)! >
                    int.tryParse(quantity.toString())!) {
                  print("isofwjeo7");
                  status = "in";
                } else {
                  print("isofwjeo8");
                  status = "out";
                }

                try {
                  print("isofwjeo9");
                  print((int.parse(quantity!) +
                          int.parse(_quantityController.text))
                      .toString());

                  i.history!.add(History(
                      initialquantity: quantity,
                      finalquantity: finalquantity,
                      status: "in",
                      type: "edit",
                      pname: _nameController.text,
                      datetime: DateTime.now().toString(),
                      quantity: finalquantity,
                      description: _descriptionController.text,
                      lotid: _numberController.text));
                } catch (e) {
                  print("isofwjeo10");
                  i.history = [
                    History(
                        initialquantity: quantity,
                        finalquantity: finalquantity,
                        status: "in",
                        type: "edit",
                        pname: _nameController.text,
                        datetime: DateTime.now().toString(),
                        quantity: finalquantity,
                        description: _descriptionController.text,
                        lotid: _numberController.text)
                  ];
                }
              }
            }
          } catch (e) {
            print("error id iowjoiwgieof: ${e.toString()}");
          }
        }
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data.toJson());
      });
    } catch (e) {
      print("error id wiejowiefi ${e.toString()}");
    }

    Navigator.of(context).pop(); // Close the dialog box
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Quantity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: productlist[0],
                    hint: Text('Select Product'),
                    items: productlist.map((String customer) {
                      return DropdownMenuItem<String>(
                        value: customer,
                        child: Text(customer),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _nameController.text = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddProductInputDialog(widget.location);
                            },
                          );
                        },
                        child: Icon(Icons.add_circle_outline)))
              ],
            ),
          ),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Add Quantity',
            ),
          ),
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Lot Id',
            ),
          ),
          TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Add Quantity'),
          onPressed: _editProduct,
        ),
      ],
    );
  }
}
