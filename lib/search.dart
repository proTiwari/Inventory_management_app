import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplode_management/global_variables.dart';
import 'package:xplode_management/state.dart';

import 'model/owner_model.dart';

class Search extends StatefulWidget {
  List<String> allCustomers = [];
  String s = '';
  dynamic changeboolfun;
  Search(this.allCustomers, this.changeboolfun, this.s, {Key? key})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController editingController = TextEditingController();

  var items = [];
  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(widget.allCustomers);

    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.allCustomers);
      });
    }
  }

  @override
  void initState() {
    items.addAll(widget.allCustomers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 400,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey.shade300,
              ),
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                        child: TextFormField(
                          controller: editingController,
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(0, 255, 255, 255),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(0, 0, 0, 0),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(0, 0, 0, 0),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(0, 0, 0, 0),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // FFAppState().cityname = "";
                        widget.changeboolfun();
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 18, 20, 5),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.s == 'c') {
                        FFAppState().customer = items[index];
                        widget.changeboolfun();
                      }
                      if (widget.s == 'l') {
                        try {
                          FFAppState().tempquantity = 'null';
                          FFAppState().location = items[index];
                          FFAppState().productvalue = "Select Product";
                          FFAppState().product.clear();
                          FFAppState()
                              .brandmap[items[index]]!
                              .forEach((key, value) {
                            for (var k in value) {
                              if (k != "Select Brand") {
                                FFAppState().product.add("$key ($k)");
                              }
                            }
                          });
                        } catch (e) {
                          print("error from search screen: $e");
                          Get.showSnackbar(GetBar(
                            message: 'No Products Available!',
                            duration: Duration(seconds: 2),
                          ));
                        }
                        widget.changeboolfun();
                      }

                      if (widget.s == 'p') {
                        FFAppState().productvalue = items[index];
                        FFAppState().tempquantity = 'null';

                        // code for getting the heighest quantity of the selected date
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((value) {
                          print("isofwjeo3");
                          try {
                            OwnerModel data = OwnerModel.fromJson(
                                value.data() as Map<String, dynamic>);

                            for (Location i in data.locations!) {
                              print('isofwjeo4');
                              print(i.locationName);
                              print(FFAppState().location);
                              if (i.locationName ==
                                  FFAppState().location.toString()) {
                                print("isofwjeo4.1");
                                print(FFAppState().productvalue);
                                print("start....");
                                print(
                                    "${i.product!.pname}_${FFAppState().productvalue.toString().split('(')[0].trim()}");
                                print(
                                    "${i.product!.category}_${FFAppState().productvalue.toString().split('(')[1].trim().split(')')[0].trim().toString()}");
                                print(FFAppState()
                                    .productvalue
                                    .toString()
                                    .split('(')[0]
                                    .trim());
                                print(FFAppState()
                                    .productvalue
                                    .toString()
                                    .split('(')[1]
                                    .trim()
                                    .split(')')[0]
                                    .trim()
                                    .toString());
                                print(FFAppState()
                                    .productvalue
                                    .toString()
                                    .split('(')[0]
                                    .trim());
                                if (FFAppState()
                                            .productvalue
                                            .toString()
                                            .split('(')[0]
                                            .trim() ==
                                        i.product!.pname &&
                                    FFAppState()
                                            .productvalue
                                            .toString()
                                            .split('(')[1]
                                            .trim()
                                            .split(')')[0]
                                            .trim()
                                            .toString() ==
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
                                    print(dateTimeList);
                                    if (k.datetime!.compareTo(
                                                "${dateTimeList.toString().split(" ")[0]} 23:59:00.000") <
                                            0 ||
                                        k.datetime!.compareTo(
                                                "${dateTimeList.toString().split(" ")[0]} 23:59:00.000") ==
                                            0) {
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
                                          print(dateTimeList.toString());

                                          if (n.datetime!.compareTo(
                                                      "${dateTimeList.toString().split(" ")[0]} 23:59:00.000") <
                                                  0 ||
                                              n.datetime!.compareTo(
                                                      "${dateTimeList.toString().split(" ")[0]} 23:59:00.000") ==
                                                  0) {
                                            if (n.datetime!.compareTo(maxdate) >
                                                0) {
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

                                  setState(() {
                                    FFAppState().tempquantity = quantity;
                                    print("wiofowe");
                                    print(FFAppState().tempquantity);
                                  });
                                }
                              }
                            }
                          } catch (e) {
                            print('error id junki : ${e}');
                          }
                        });
                        widget.changeboolfun();
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: items[index],
                            style: TextStyle(),
                          )
                        ],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
