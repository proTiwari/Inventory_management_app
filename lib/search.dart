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
                    onTap: () {
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
                                FFAppState().product.add("${key} (${k})");
                              }
                            }
                          });
                        } catch (e) {
                          print("error from search screen: ${e}");
                          Get.showSnackbar(GetBar(
                            message: 'No Products Available!',
                            duration: Duration(seconds: 2),
                          ));
                        }

                        widget.changeboolfun();
                      }

                      if (widget.s == 'p') {
                        FFAppState().productvalue = items[index];
                        for (Location i in FFAppState().locations) {
                          var product =
                              items[index].toString().split("(")[0].trim();
                          if (i.product!.pname == product &&
                              i.product!.category ==
                                  items[index]
                                      .toString()
                                      .split("(")[1]
                                      .split(")")[0]
                                      .trim()) {
                            print(i.product!.quantity);
                            FFAppState().tempquantity = i.product!.quantity!;
                            print(i.product!.category);
                          }
                        }
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
