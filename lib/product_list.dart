import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:xplode_management/router.dart';

import 'global_variables.dart';
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
  TextEditingController editTextController1 = TextEditingController();
  TextEditingController locationsearchcontroller = TextEditingController();
  List<Product> matchQuery = [];

  @override
  void initState() {
    super.initState();
    print("jnknkjnihuiuhiuh  ${Get.arguments}");
    location = Get.arguments;
    editTextController.text = "";

    // testfun();
    locationsearchcontroller.addListener(() {
      print("printing text ${locationsearchcontroller.text}");
      print("uniqueList $uniqueList");
      matchQuery = uniqueList
          .where((item) => "${item.pname} ${item.category}"
              .toLowerCase()
              .contains(locationsearchcontroller.text.toLowerCase()))
          .toList();

      setState(() {
        matchQuery;
      });
      print(matchQuery);
    });
  }

  removeallemptyhistory() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var locations = value.data()!["locations"];
      print("lsldddddd: $locations");
      var toremove = [];
      for (var i in locations) {
        if (i["history"].length == 0) {
          toremove.add(i);
        }
      }
      locations.removeWhere((e) => toremove.contains(e));
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"locations": locations});
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
                              flex: 2,
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
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
                            ),
                            Expanded(
                              flex: 19,
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
                                            if (uniqueList.isEmpty) {
                                              uniqueList.add(i);
                                            } else {
                                              if (uniqueList
                                                      .where((element) =>
                                                          element.pname ==
                                                              i.pname &&
                                                          element.category ==
                                                              i.category)
                                                      .toList()
                                                      .length ==
                                                  0) {
                                                uniqueList.add(i);
                                              }
                                            }
                                          } catch (e) {
                                            print("isjdofjiwoe:: $e");
                                          }
                                        }
                                        print("wefwefwfw$uniqueList");
                                        print(datalist);
                                        // sort datalist according to pname
                                        datalist.sort((a, b) =>
                                            a.pname!.compareTo(b.pname!));

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
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      datalist[index].category == ''
                                                                                          ? Text('${datalist[index].pname}',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color(0xFF14181B),
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ))
                                                                                          : Text('${datalist[index].pname} (${datalist[index].category})',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color(0xFF14181B),
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 18.0),
                                                                                        child: Icon(
                                                                                          Icons.arrow_forward_outlined,
                                                                                          color: Color(0xFF4B39EF),
                                                                                          size: 14,
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 6.0),
                                                                                        child: Text("${datalist[index].quantity}", style: TextStyle(color: Color(0xFF4B39EF))),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
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
                                                                                  editTextController1.text = datalist[index].category!;
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (ctx) => AlertDialog(
                                                                                      title: Text('Edit'),
                                                                                      content: SingleChildScrollView(
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            TextFormField(
                                                                                              controller: editTextController,
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Product Name',
                                                                                              ),
                                                                                            ),
                                                                                            TextFormField(
                                                                                              controller: editTextController1,
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Brand Name',
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
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
                                                                                                  i["product"]['category'] = "${editTextController1.text}";
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
                                                                                            var toRemove = [];
                                                                                            for (var i in locations) {
                                                                                              if (i["product"]['pname'] == datalist[index].pname! && i["product"]['category'] == datalist[index].category!) {
                                                                                                toRemove.add(i);
                                                                                              }
                                                                                            }
                                                                                            locations.removeWhere((e) => toRemove.contains(e));

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
                                                            matchQuery[index],
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
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      datalist[index].category == ''
                                                                                          ? Text('${matchQuery[index].pname}',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color(0xFF14181B),
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ))
                                                                                          : Text('${matchQuery[index].pname} (${matchQuery[index].category})',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color(0xFF14181B),
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 14.0),
                                                                                        child: Icon(
                                                                                          Icons.arrow_forward_outlined,
                                                                                          color: Color(0xFF4B39EF),
                                                                                          size: 18,
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 6.0),
                                                                                        child: Text("${matchQuery[index].quantity}", style: TextStyle(color: Color(0xFF4B39EF))),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
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
                                                                                  editTextController1.text = matchQuery[index].category!;
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (ctx) => AlertDialog(
                                                                                      title: Text('Edit'),
                                                                                      content: SingleChildScrollView(
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            TextFormField(
                                                                                              controller: editTextController,
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Product Name',
                                                                                              ),
                                                                                            ),
                                                                                            TextFormField(
                                                                                              controller: editTextController1,
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Brand Name',
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
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
                                                                                                  i["product"]['category'] = "${editTextController1.text}";
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
                                                                                            var toRemove = [];
                                                                                            for (var i in locations) {
                                                                                              if (i["product"]['pname'] == matchQuery[index].pname! && i["product"]['category'] == matchQuery[index].category!) {
                                                                                                toRemove.add(i);
                                                                                              }
                                                                                            }
                                                                                            locations.removeWhere((e) => toRemove.contains(e));

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
              padding: const EdgeInsets.only(bottom: 40.0),
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
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 45.0),
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AddProductInputDialog(location);
            //         },
            //       );
            //     },
            //     backgroundColor: Color(0xFF4B39EF),
            //     elevation: 8,
            //     child: Icon(
            //       Icons.download_outlined,
            //       color: Colors.white,
            //       size: 24,
            //     ),
            //   ),
            // ),
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

  @override
  void initState() {
    super.initState();
    removeallemptyhistory();
  }

  removeallemptyhistory() async {
    print('ifjweijfowjfiow');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      List<Location> locations = (value.data()!['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e))
          .toList();
      print("lsldddddd: $locations");
      List<Location> toremove1 = [];
      List<Location> topreremove1 = [];
      for (Location j in locations) {
        if (j.history!.isEmpty) {
          topreremove1.add(j);
        }
      }

      for (Location k in topreremove1) {
        int count = 0;
        for (Location m in locations) {
          if (k.locationName == m.locationName) {
            count++;
            if (count > 1) {
              try {
                print("kjjjjjjjjj  ${k.locationName}");
                toremove1.add(k);
              } catch (e) {
                print("wjefoweo$e");
              }
            }
          }
        }
      }
      try {
        // ignore: iterable_contains_unrelated_type
        locations.removeWhere((e) => toremove1.contains(e));
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"locations": locations.map((e) => e.toJson()).toList()})
            .whenComplete(() => print("done"))
            .onError((error, stackTrace) => print("error: $error"));
      } catch (e) {
        print("okwefoiwj $e");
      }
    });
  }

  var alreadyexist = false;
  List<Location> toremove = [];
  List<Location> topreremove = [];
  List<Location> locations = [];

  void _addProduct() async {
    if (_nameController.text.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      for (var k in value.data()!['locations']) {
        locations.add(Location.fromJson(k));
      }
      for (Location j in locations) {
        if (j.history!.isEmpty) {
          topreremove.add(j);
        }
      }

      for (var k in topreremove) {
        int count = 0;
        for (var m in locations) {
          if (k.locationName == m.locationName) {
            count++;
            if (count > 1) {
              print("kjjjjjjjjj  ${k.locationName}");
              toremove.add(m);
            }
          }
        }
      }
      for (Location i in locations) {
        try {
          if (i.locationName == widget.location) {
            if (_nameController.text.toLowerCase() ==
                    i.product!.pname!.toLowerCase() &&
                _categoryController.text.toLowerCase() ==
                    i.product!.category!.toLowerCase()) {
              alreadyexist = true;
            }
            print("location found ${i.locationName}");
            print("product found1 ${i.product}");
            print("product name: ${i.product!.pname}");
            if (i.product!.pname == null) {
              print("product found2 ${i.product}");
            }
          }
        } catch (e) {
          print("this is the error $e");
        }
      }
      // try {

      //   await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(FirebaseAuth.instance.currentUser!.uid)
      //       .update({
      //     "locations": locations.map((location) => location.toJson()).toList()
      //   });
      // } catch (e) {
      //   print("this is the error2 ${e}");
      // }
    });
    if (alreadyexist) {
      Get.showSnackbar(GetBar(
        message: 'Product Already Exist',
        duration: Duration(seconds: 2),
      ));
    } else {
      if (_nameController.text == '') {
        Get.showSnackbar(GetBar(
          message: 'Product Name Cannot Be Empty!',
          duration: Duration(seconds: 2),
        ));
      } else {
        locations.removeWhere((element) => toremove.contains(element));
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'locations': FieldValue.arrayUnion([
            {
              "locationName": widget.location,
              "product": {
                "category": _categoryController.text == ''
                    ? 'No Brand'
                    : _categoryController.text.toString().trim(),
                "datetime": DateTime.now().toString(),
                "pname": _nameController.text.toString().trim(),
                "quantity": "0"
              },
              "history": [
                {
                  "initialquantity": "0",
                  "finalquantity": "0",
                  "quantity": "0",
                  "datetime": DateTime.now().toString(),
                  "status": "in",
                  "type": "add",
                  "brand": _categoryController.text == ''
                      ? 'No Brand'
                      : _categoryController.text,
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
      }
    }

    // Perform your desired action with the entered data here
    Navigator.of(context).pop(); // Close the dialog box
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
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
                labelText: 'Brand(Optional)',
              ),
            ),
          ],
        ),
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

  var Oid;

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
              productlist.add("${i.product!.pname!} (${i.product!.category!})");
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
      String productName = _nameController.text.toString().split('(')[0].trim();
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
              print("isofwjeo5.0");
              if (productName == i.product!.pname &&
                  _nameController.text
                          .toString()
                          .split('(')[1]
                          .toString()
                          .split(')')[0]
                          .trim() ==
                      i.product!.category) {
                print("isofwjeo5.1");
                //
                bool doesexist2 = false;
                bool doesexist = false;
                print("isofwjeo5.2");
                var maxdate = "2000-06-25 00:00:48.033";
                print("isofwjeo5.3");
                var qunt;
                print("isofwjeo5.4");
                for (var k in i.history!) {
                  print("isofwjeo5.5");
                  print(k.datetime);
                  print(k.datetime.toString().split(" ")[0]);
                  print(dateTimeList1);
                  if (k.datetime!.compareTo(dateTimeList1.toString()) < 0 ||
                      k.datetime!.compareTo(dateTimeList1.toString()) == 0) {
                    print("isofwjeo5.6");
                    print(maxdate);
                    print("isofwjeo5.61");

                    print("isofwjeo5.62");
                    print(k.toJson());

                    print("isofwjeo5.63");
                    print(k.finalquantity);
                    print(k.datetime);
                    for (var n in i.history!) {
                      if (n.finalquantity != null) {
                        print(n.datetime);
                        print(dateTimeList1.toString());

                        if (n.datetime!.compareTo(dateTimeList1.toString()) <
                                0 ||
                            n.datetime!.compareTo(dateTimeList1.toString()) ==
                                0) {
                          if (n.datetime!.compareTo(maxdate) > 0) {
                            print("isofwjeo5.7");
                            maxdate = n.datetime!;
                            print(maxdate);
                            print("isofwjeo5.8");
                            print(n.finalquantity);
                            print(qunt);
                            qunt = n.finalquantity;
                            print(qunt);
                            print("isofwjeo5.9");
                            doesexist2 = true;
                          }
                          doesexist = true;
                        }
                      }
                    }
                    break;
                  }
                }
                qunt ??= "0";

                var quantity = doesexist ? qunt : '0';
                var finalquantity =
                    (int.parse(quantity!) + int.parse(_quantityController.text))
                        .toString();
                i.product!.quantity = (int.parse(i.product!.quantity!) +
                        int.parse(_quantityController.text))
                    .toString();
                ;
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
                Oid = DateTime.now().millisecondsSinceEpoch.toString() +
                    Random().nextInt(10000).toString();

                try {
                  print("isofwjeo9");
                  print((int.parse(quantity!) +
                          int.parse(_quantityController.text))
                      .toString());

                  i.history!.add(History(
                      id: Oid,
                      initialquantity: quantity,
                      finalquantity: finalquantity,
                      status: "in",
                      type: "edit",
                      pname:
                          _nameController.text.toString().split('(')[0].trim(),
                      datetime: dateTimeList1.toString(),
                      brand: _nameController.text
                          .toString()
                          .split('(')[1]
                          .split(')')[0]
                          .trim(),
                      quantity: _quantityController.text,
                      description: _descriptionController.text,
                      lotid: _numberController.text));
                } catch (e) {
                  print("isofwjeo10");
                  i.history = [
                    History(
                        id: Oid,
                        initialquantity: quantity,
                        finalquantity: finalquantity,
                        status: "in",
                        type: "edit",
                        pname: _nameController.text
                            .toString()
                            .split('(')[0]
                            .trim(),
                        brand: _nameController.text
                            .toString()
                            .split('(')[1]
                            .split(')')[0]
                            .trim(),
                        datetime: dateTimeList1.toString(),
                        quantity: _quantityController.text,
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
            .update(data.toJson())
            .whenComplete(() {
          try {
            var id = Oid;
            print("lid: $id");
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((value) {
              OwnerModel data =
                  OwnerModel.fromJson(value.data() as Map<String, dynamic>);
              print('klklk');
              var quantity;
              var date;

              for (Location i in data.locations!) {
                print('hhh');
                try {
                  for (History j in i.history!) {
                    print('klklkmmm');
                    try {
                      try {
                        print(j.id);
                      } catch (e) {
                        print("error id iowjoiwgieof: ${e.toString()}");
                      }

                      if (j.id == id) {
                        quantity = j.quantity;
                        date = j.datetime;
                        var diddff;
                        bool decor = false;
                        print('klklbnbk');
                        for (History n in i.history!) {
                          print('klklkmdrgermm');
                          try {
                            if (n.datetime!.compareTo(date) > 0) {
                              print('iejiwoejfoiww');

                              decor = false;
                              print('klklkmdr9990wo');

                              try {
                                int diff1 = int.parse(quantity.toString());
                                print("dsoiwe1 ${n.toJson()}");
                                n.initialquantity =
                                    (int.parse(n.initialquantity!) + diff1)
                                        .toString();
                                print("dsoiwe2");
                                n.finalquantity =
                                    (int.parse(n.finalquantity!) + diff1)
                                        .toString();
                                print("dsoiwe3");
                                diddff = diff1;
                                print('diffk1: $diff1');
                                print(n.finalquantity);
                              } catch (e) {
                                print('oweioij: ${e.toString()}');
                              }
                            }
                          } catch (e) {
                            print("errorhjkl'jj: $e");
                          }
                        }
                        try {
                          print('${j.quantity} ${j.description} ${j.datetime}');
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
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "locations": data.locations!.map((e) => e.toJson()).toList()
              });
            });
          } catch (e) {
            print("sdsddd: $e");
          }
        });
      });
    } catch (e) {
      print("error id wiejowiefi ${e.toString()}");
    }

    Navigator.of(context).pop(); // Close the dialog box
  }

  var dateTimeList1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Quantity'),
      content: SingleChildScrollView(
        child: Column(
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
              decoration: InputDecoration(
                labelText: 'Lot Id',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(
              height: 30,
              width: 300,
              child: ElevatedButton(
                  onPressed: () async {
                    dateTimeList1 = await showOmniDateTimePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime(1600).subtract(const Duration(days: 3652)),
                      lastDate: DateTime.now().add(
                        const Duration(days: 3652),
                      ),
                      type: OmniDateTimePickerType.date,
                      is24HourMode: true,
                      isShowSeconds: false,
                      minutesInterval: 1,
                      secondsInterval: 1,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                        maxHeight: 650,
                      ),
                      transitionBuilder: (context, anim1, anim2, child) {
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
                      transitionDuration: const Duration(milliseconds: 200),
                      barrierDismissible: true,
                    );
                    setState(() {
                      dateTimeList1;
                      dateTimeList1 =
                          "${dateTimeList1.toString().split(" ")[0]} ${DateTime.now().toString().split(" ")[1]}";
                      dateTimeList1 = DateTime.parse(dateTimeList1);
                      print('datetkime:vwek: $dateTimeList1');
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  )),
                  child: dateTimeList1 == null
                      ? Center(child: Text("Select Date"))
                      : Center(
                          child: Text(
                              "${dateTimeList1.toString().split(" ")[0]}"))),
            )
          ],
        ),
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
          onPressed: () {
            if (_nameController.text == '' ||
                _nameController.text == 'select product' ||
                _quantityController.text == '' ||
                _numberController.text == '' ||
                dateTimeList1 == null) {
              Get.showSnackbar(GetBar(
                message: "Please fill all the fields",
                duration: Duration(seconds: 2),
              ));
              return;
            } else {
              _editProduct();
            }
          },
        ),
      ],
    );
  }
}
