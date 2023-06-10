import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplode_management/product_list.dart';
import 'package:xplode_management/router.dart';

import 'create_order.dart';
import 'global_variables.dart';
import 'model/owner_model.dart';

class LocationlistWidget extends StatefulWidget {
  const LocationlistWidget({Key? key}) : super(key: key);

  @override
  _LocationlistWidgetState createState() => _LocationlistWidgetState();
}

class _LocationlistWidgetState extends State<LocationlistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<String> uniqueList = [];
  TextEditingController editTextController = TextEditingController();
  TextEditingController locationsearchcontroller = TextEditingController();
  List<String> matchQuery = [];

  @override
  void initState() {
    super.initState();
    editTextController.text = "";
    // testfun();
    locationsearchcontroller.addListener(() {
      print("printing text ${locationsearchcontroller.text}");
      matchQuery = uniqueList
          .where((item) => item
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
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      print(
          "FirebaseAuth.instance.currentUser: ${FirebaseAuth.instance.currentUser}");
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF4B39EF),
        appBar: AppBar(
          backgroundColor: Color(0xFF4B39EF),
          automaticallyImplyLeading: false,
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
        body: FirebaseAuth.instance.currentUser == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment(0, 0),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Color(0xB3FFFFFF),
                              labelStyle: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              indicatorColor: Color(0xFF4B39EF),
                              indicatorWeight: 5,
                              tabs: [
                                Tab(
                                  text: 'Locations',
                                ),
                                Tab(
                                  text: 'Create Order',
                                ),
                                Tab(
                                  text: 'My Customers',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: TabBarView(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        flex: 11,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF1F4F8),
                                            ),
                                            child:
                                                StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .snapshots(), // Replace with your actual stream
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.hasData) {
                                                  OwnerModel data =
                                                      OwnerModel.fromJson(
                                                          snapshot.data!.data()
                                                              as Map<String,
                                                                  dynamic>);

                                                  List<String> location = [];
                                                  for (var i
                                                      in data.locations!) {
                                                    try {
                                                      location
                                                          .add(i.locationName!);
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  }

                                                  uniqueList = [];

                                                  for (String str in location) {
                                                    if (!uniqueList
                                                        .contains(str)) {
                                                      uniqueList.add(str);
                                                    }
                                                  }

                                                  print(matchQuery);
                                                  if (locationsearchcontroller
                                                      .text.isEmpty) {
                                                    return ListView.builder(
                                                      itemCount:
                                                          uniqueList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return index == 0
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsetsDirectional.fromSTEB(
                                                                              16,
                                                                              8,
                                                                              16,
                                                                              0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.toNamed(
                                                                              AppRoutes.productlist,
                                                                              arguments: uniqueList[index]);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 3,
                                                                                color: Color(0x20000000),
                                                                                offset: Offset(0, 1),
                                                                              )
                                                                            ],
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                8,
                                                                                8,
                                                                                12,
                                                                                8),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                        child: Text(
                                                                                          '${uniqueList[index]}',
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Plus Jakarta Sans',
                                                                                            color: Color(0xFF14181B),
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        print(uniqueList[index]);
                                                                                        editTextController.text = uniqueList[index];
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
                                                                                                    labelText: 'Location Name',
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
                                                                                                      if (i["locationName"] == uniqueList[index]) {
                                                                                                        Map v = i;
                                                                                                        //change the key name locationName of the map i to the new value
                                                                                                        v["locationName"] = "${editTextController.text}";
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
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          print(uniqueList[index]);
                                                                                          editTextController.text = uniqueList[index];
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
                                                                                                      labelText: 'Location Name',
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
                                                                                                        if (i["locationName"] == uniqueList[index]) {
                                                                                                          //change the key name locationName of the map i to the new value
                                                                                                          i["locationName"] = "${editTextController.text}";
                                                                                                        }
                                                                                                      }
                                                                                                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"locations": locations});
                                                                                                    });
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                                                                          child: Icon(
                                                                                            Icons.edit_outlined,
                                                                                            color: Color(0xFF4B39EF),
                                                                                            size: 24,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        print(uniqueList[index]);
                                                                                        editTextController.text = uniqueList[index];
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
                                                                                                    labelText: 'Are you sure you want to delete this location?',
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
                                                                                                      if (i["locationName"] == uniqueList[index]) {
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            8,
                                                                            16,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                        AppRoutes
                                                                            .productlist,
                                                                        arguments:
                                                                            uniqueList[index]);
                                                                  },
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
                                                                          color:
                                                                              Color(0x20000000),
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
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                  child: Text(
                                                                                    '${uniqueList[index]}',
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Plus Jakarta Sans',
                                                                                      color: Color(0xFF14181B),
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
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
                                                                                    print(uniqueList[index]);
                                                                                    editTextController.text = uniqueList[index];
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
                                                                                                labelText: 'Location Name',
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
                                                                                                  if (i["locationName"] == uniqueList[index]) {
                                                                                                    Map v = i;
                                                                                                    //change the key name locationName of the map i to the new value
                                                                                                    v["locationName"] = "${editTextController.text}";
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
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      print(uniqueList[index]);
                                                                                      editTextController.text = uniqueList[index];
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
                                                                                                  labelText: 'Location Name',
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          actions: <Widget>[
                                                                                            ElevatedButton(
                                                                                              child: Text('cancel'),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                            ElevatedButton(
                                                                                              child: Text('save'),
                                                                                              onPressed: () {
                                                                                                FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                                  List<dynamic> locations = value.data()!["locations"];

                                                                                                  for (var i in locations) {
                                                                                                    if (i["locationName"] == uniqueList[index]) {
                                                                                                      i['locationName'] = "${editTextController.text}";
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
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  print(uniqueList[index]);
                                                                                  editTextController.text = uniqueList[index];
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
                                                                                              labelText: 'Are you sure you want to delete this location?',
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
                                                                                                if (i["locationName"] == uniqueList[index]) {
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
                                                              );
                                                      },
                                                    );
                                                  }
                                                  return ListView.builder(
                                                    itemCount:
                                                        matchQuery.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return index == 0
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            8,
                                                                            16,
                                                                            0),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get.toNamed(
                                                                            AppRoutes
                                                                                .productlist,
                                                                            arguments:
                                                                                matchQuery[index]);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 3,
                                                                              color: Color(0x20000000),
                                                                              offset: Offset(0, 1),
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              8,
                                                                              8,
                                                                              12,
                                                                              8),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                      child: Text(
                                                                                        '${matchQuery[index]}',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                                          color: Color(0xFF14181B),
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      print(matchQuery[index]);
                                                                                      editTextController.text = matchQuery[index];
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
                                                                                                  labelText: 'Location Name',
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
                                                                                                    if (i["locationName"] == matchQuery[index]) {
                                                                                                      Map v = i;
                                                                                                      //change the key name locationName of the map i to the new value
                                                                                                      v["locationName"] = "${editTextController.text}";
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
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        print(matchQuery[index]);
                                                                                        editTextController.text = matchQuery[index];
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
                                                                                                    labelText: 'Location Name',
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
                                                                                                      if (i["locationName"] == matchQuery[index]) {
                                                                                                        i["locationName"] = "${editTextController.text}";
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
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                                                                        child: Icon(
                                                                                          Icons.edit_outlined,
                                                                                          color: Color(0xFF4B39EF),
                                                                                          size: 24,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      print(matchQuery[index]);
                                                                                      editTextController.text = matchQuery[index];
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
                                                                                                  labelText: 'Are you sure you want to delete this location?',
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
                                                                                                    if (i["locationName"] == matchQuery[index]) {
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
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16,
                                                                          8,
                                                                          16,
                                                                          0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Get.toNamed(
                                                                      AppRoutes
                                                                          .productlist,
                                                                      arguments:
                                                                          matchQuery[
                                                                              index]);
                                                                },
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
                                                                                child: Text(
                                                                                  '${matchQuery[index]}',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Color(0xFF14181B),
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
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
                                                                                  print(matchQuery[index]);
                                                                                  editTextController.text = matchQuery[index];
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
                                                                                              labelText: 'Location Name',
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
                                                                                                if (i["locationName"] == matchQuery[index]) {
                                                                                                  Map v = i;
                                                                                                  //change the key name locationName of the map i to the new value
                                                                                                  v["locationName"] = "${editTextController.text}";
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
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    print(matchQuery[index]);
                                                                                    editTextController.text = matchQuery[index];
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
                                                                                                labelText: 'Location Name',
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        actions: <Widget>[
                                                                                          ElevatedButton(
                                                                                            child: Text('cancel'),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                            child: Text('save'),
                                                                                            onPressed: () {
                                                                                              FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                                List<dynamic> locations = value.data()!["locations"];

                                                                                                for (var i in locations) {
                                                                                                  if (i["locationName"] == matchQuery[index]) {
                                                                                                    i['locationName'] = "${editTextController.text}";
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
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                print(matchQuery[index]);
                                                                                editTextController.text = matchQuery[index];
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
                                                                                            labelText: 'Are you sure you want to delete this location?',
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
                                                                                              if (i["locationName"] == matchQuery[index]) {
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
                                                            );
                                                    },
                                                  );
                                                } else if (snapshot.hasError) {
                                                  // Handle error from the stream
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  // Render a placeholder or loading indicator
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ))),
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text(
                                          'Add Location',
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
                                              return LocationInputDialog();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                CreateorderWidget(),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F4F8),
                                        ),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 8, 16, 0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3,
                                                      color: Color(0x20000000),
                                                      offset: Offset(0, 1),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(8, 8, 12, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16,
                                                                          16,
                                                                          16,
                                                                          16),
                                                              child: Text(
                                                                  'Customer Name',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color: Color(
                                                                        0xFF14181B),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        15,
                                                                        0),
                                                            child: Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              color: Color(
                                                                  0xFF4B39EF),
                                                              size: 24,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.delete_sharp,
                                                            color: Color(
                                                                0xFF4B39EF),
                                                            size: 24,
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
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text(
                                          'Add Customer',
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
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 45.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Generate Report",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0)),
              SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return locationselectordialog(uniqueList);
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
            ],
          ),
        ),
      ),
    );
  }
}

class locationselectordialog extends StatefulWidget {
  List<String> uniqueList;
  locationselectordialog(this.uniqueList);

  @override
  _locationselectordialogState createState() => _locationselectordialogState();
}

class _locationselectordialogState extends State<locationselectordialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.uniqueList.add("Select All");
  }

  @override
  Widget build(BuildContext context) {
    var location = widget.uniqueList[0];
    return AlertDialog(
      title: Text('Report'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: widget.uniqueList[0],
            hint: Text('Select Product'),
            items: widget.uniqueList.map((String customer) {
              return DropdownMenuItem<String>(
                value: customer,
                child: Text(customer),
              );
            }).toList(),
            onChanged: (String? value) {
              location = value!;
            },
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
          child: Text('Generate Report'),
          onPressed: () async {
            if (location == "Select All") {
              List locationList = [];
              print("Select All");
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) {
                  List<Location> locations = value
                      .data()!['locations']
                      .map<Location>((e) => Location.fromJson(e))
                      .toList();
                  for (var i in locations) {
                    if (locationList.contains(i.locationName) == false) {
                      locationList.add(i.locationName);
                    }
                  }
                  int count = 0;
                  List product = [];
                  String recentlocation = "";
                  for (var j in locationList) {
                    if (j != null) {
                      for (var k in locations) {
                        if (j == k.locationName) {
                          count++;
                          if (count > 14 || recentlocation != j) {
                            count = 1;
                            if (count == 1) {
                              locationlist.add(j);
                              product.add([
                                [
                                  k.product!.pname,
                                  k.product!.category,
                                  k.product!.quantity
                                ]
                              ]);
                            }
                          } else {
                            if (count == 1) {
                              locationlist.add(j);
                              product.add([
                                [
                                  k.product!.pname,
                                  k.product!.category,
                                  k.product!.quantity
                                ]
                              ]);
                            } else {
                              product[product.length - 1].add([
                                k.product!.pname,
                                k.product!.category,
                                k.product!.quantity
                              ]);
                            }
                          }
                          try {
                            recentlocation = j;
                          } catch (e) {
                            print("fweiofwjojf: ${e}");
                          }
                        }
                      }
                    }

                    print("location name : ${j} : ${count} : ${product}");
                  }
                  print("product: ${product}");
                  productlist = [];
                  productlist = product;
                }).whenComplete(() {
                  Get.toNamed(AppRoutes.pdfscreen);
                });
              } catch (e) {
                print(e);
              }
            } else {
              List locationList = [];
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((value) {
                List<Location> locations = value
                    .data()!['locations']
                    .map<Location>((e) => Location.fromJson(e))
                    .toList();
                for (var i in locations) {
                  if (locationList.contains(i.locationName) == false) {
                    locationList.add(i.locationName);
                  }
                }
                int count = 0;
                List product = [];
                String recentlocation = "";
                for (var k in locations) {
                  //
                  if (location == k.locationName) {
                    count++;
                    if (count > 14 || recentlocation != location) {
                      count = 1;
                      if (count == 1) {
                        product.add([
                          [
                            k.product!.pname,
                            k.product!.category,
                            k.product!.quantity
                          ]
                        ]);
                      }
                    } else {
                      if (count == 1) {
                        product.add([
                          [
                            k.product!.pname,
                            k.product!.category,
                            k.product!.quantity
                          ]
                        ]);
                      } else {
                        product[product.length - 1].add([
                          k.product!.pname,
                          k.product!.category,
                          k.product!.quantity
                        ]);
                      }
                    }
                    try {
                      locationlist = [location];
                      recentlocation = location;
                    } catch (e) {
                      print(e);
                    }
                  }
                }
                print("product: ${product}");
                productlist = product;
              }).whenComplete(() {
                Get.toNamed(AppRoutes.pdfscreen);
              });
            }
          },
        ),
      ],
    );
  }
}

class LocationInputDialog extends StatefulWidget {
  @override
  _LocationInputDialogState createState() => _LocationInputDialogState();
}

class _LocationInputDialogState extends State<LocationInputDialog> {
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addLocation() async {
    String locationName = _nameController.text;
    print(locationName);
    if (_nameController.text.isEmpty) {
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
        Get.showSnackbar(GetBar(
          message: 'Location Added',
          duration: Duration(seconds: 2),
        ));
      });
    }

    // Perform your desired action with the entered data here
    Navigator.of(context).pop(); // Close the dialog box
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Location Name',
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
          child: Text('Add Location'),
          onPressed: _addLocation,
        ),
      ],
    );
  }
}
