import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xplode_management/router.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'model/owner_model.dart';
import 'package:intl/intl.dart';

class ProductActivitylistWidget extends StatefulWidget {
  const ProductActivitylistWidget({Key? key}) : super(key: key);

  @override
  _ProductActivitylistWidgetState createState() =>
      _ProductActivitylistWidgetState();
}

class _ProductActivitylistWidgetState extends State<ProductActivitylistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var location;
  Product productdata = Product();

  @override
  void initState() {
    super.initState();
    getAllLocations();
    location = Get.arguments[1];
    productdata = Get.arguments[0];
  }

  List<String> allLocations = [];

  getAllLocations() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var locations = value.data()!['locations'];
      for (var i in locations) {
        print(i['locationName']);
        setState(() {
          if (allLocations.contains(i['locationName']) == false) {
            allLocations = [...allLocations, i['locationName']];
          }
          ;
          // allLocations.add(i['locationName']);
        });
      }
      List<String> uniqueList = [];

      // for (String str in allLocations) {
      //   if (!uniqueList.contains(str)) {
      //     uniqueList.add(str);
      //   }
      // }
      setState(() {
        // allLocations = uniqueList;
      });
    });
  }

  var date;
  List<DateTime>? dateTimeList;

  bool isDateGreaterThan(String date1, String date2) {
    DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(date1);
    DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(date2);

    return parsedDate1.isAfter(parsedDate2);
  }

  Widget sendLocationList() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255), width: 0)),
          focusColor: Colors.white,
          fillColor: Colors.white,
          hoverColor: Colors.white),
      value: location,
      hint: Text('Select location',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18)),
      items: allLocations.map((String customer) {
        return DropdownMenuItem<String>(
          value: customer,
          child: Text(customer,
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          location = value!;
        });
      },
    );
  }

  bool isDateLessThan(String date1, String date2) {
    DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(date1);
    DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(date2);

    return parsedDate1.isBefore(parsedDate2);
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
                length: 1,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        dateTimeList =
                                            await showOmniDateTimeRangePicker(
                                          context: context,
                                          startInitialDate: DateTime.now(),
                                          startFirstDate: DateTime(1600)
                                              .subtract(
                                                  const Duration(days: 3652)),
                                          startLastDate: DateTime.now().add(
                                            const Duration(days: 3652),
                                          ),
                                          endInitialDate: DateTime.now(),
                                          endFirstDate: DateTime(1600).subtract(
                                              const Duration(days: 3652)),
                                          endLastDate: DateTime.now().add(
                                            const Duration(days: 3652),
                                          ),
                                          is24HourMode: false,
                                          isShowSeconds: false,
                                          minutesInterval: 1,
                                          secondsInterval: 1,
                                          borderRadius: const BorderRadius.all(
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
                                          transitionDuration:
                                              const Duration(milliseconds: 200),
                                          barrierDismissible: true,
                                          selectableDayPredicate: (dateTime) {
                                            return true;
                                          },
                                        );
                                        setState(() {
                                          dateTimeList;
                                        });
                                      },
                                      child: Container(
                                          child: dateTimeList == null
                                              ? Text(
                                                  "Select Date Range",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 18),
                                                )
                                              : Text(
                                                  "${dateTimeList![0].day}-${dateTimeList![0].month}-${dateTimeList![0].year} to ${dateTimeList![1].day}-${dateTimeList![1].month}-${dateTimeList![1].year}",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                )),
                                    ),
                                    Container(
                                        width: 160, child: sendLocationList())
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 11,
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
                                        List<History> datalist = [];
                                        List<History>
                                            datalistwithfilteredvalue = [];
                                        try {
                                          OwnerModel data = OwnerModel.fromJson(
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>);

                                          for (Location i in data.locations!) {
                                            if (i.locationName == location) {
                                              print("fijoefowie: ${i.history}");

                                              for (var j in i.history!) {
                                                datalist.add(j);
                                              }
                                            }
                                          }
                                          // code for filtering through date

                                          for (History k in datalist) {
                                            try {
                                              var logdate;
                                              k.datetime;
                                              print("iwjefiweofjijiiiii");
                                              print(
                                                  "datetimefwefwddd: ${k.datetime}");
                                              print(
                                                  "datetime: ${k.datetime.toString().split(" ")[0].split('-')}");
                                              logdate = k.datetime
                                                  .toString()
                                                  .split(" ")[0]
                                                  .split('-');
                                              print("logdateiojwe ${logdate}");
                                              var day = logdate[2];
                                              var month = logdate[1];
                                              var year = logdate[0];
                                              var finallogdate =
                                                  "$day-$month-$year";
                                              print(
                                                  "finallogdate: $finallogdate");
                                              var dayat0;
                                              var monthat0;
                                              var monthat1;
                                              var dayat1;
                                              dateTimeList![0]
                                                          .day
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? dayat0 =
                                                      "0${dateTimeList![0].day}"
                                                  : dayat0 =
                                                      dateTimeList![0].day;

                                              dateTimeList![1]
                                                          .day
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? dayat1 =
                                                      "0${dateTimeList![1].day}"
                                                  : dayat1 =
                                                      dateTimeList![1].day;

                                              dateTimeList![0]
                                                          .month
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? monthat0 =
                                                      "0${dateTimeList![0].month}"
                                                  : monthat0 =
                                                      dateTimeList![0].month;

                                              dateTimeList![1]
                                                          .month
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? monthat1 =
                                                      "0${dateTimeList![1].month}"
                                                  : monthat1 =
                                                      dateTimeList![1].month;
                                              bool isdategreaterthan =
                                                  isDateGreaterThan(
                                                      finallogdate,
                                                      "$dayat0-$monthat0-${dateTimeList![0].year}");
                                              print(
                                                  "isdategreaterthan ${isdategreaterthan}");
                                              bool isdatelessthan = isDateLessThan(
                                                  finallogdate,
                                                  "$dayat1-$monthat1-${dateTimeList![1].year}");
                                              print(
                                                  "isdatelessthan ${isdatelessthan}");
                                              if (finallogdate ==
                                                  "$dayat1-$monthat1-${dateTimeList![1].year}") {
                                                isdatelessthan = true;
                                                isdategreaterthan = true;
                                              }
                                              print(
                                                  "finallogdate jjj: ${finallogdate}");
                                              print(
                                                  "$dayat0-$monthat0-${dateTimeList![0].year}");
                                              print(
                                                  "$dayat1-$monthat1-${dateTimeList![1].year}");

                                              if (finallogdate ==
                                                  "$dayat0-$monthat0-${dateTimeList![0].year}") {
                                                isdatelessthan = true;
                                                isdategreaterthan = true;
                                              }
                                              if (isdatelessthan &&
                                                  isdategreaterthan) {
                                                print("k.pname: ${k.pname}");
                                                print(
                                                    "productdata.pname: ${productdata.pname}");
                                                if (k.pname ==
                                                    productdata.pname) {
                                                  datalistwithfilteredvalue
                                                      .add(k);
                                                  print(
                                                      "iwoejfowjeio $datalistwithfilteredvalue");
                                                }
                                              }
                                            } catch (e) {
                                              print("errorid weifjowiej: $e");
                                            }
                                          }

                                          print("datasfewe: ${datalist}");
                                          if (dateTimeList != null &&
                                              datalistwithfilteredvalue
                                                      .length ==
                                                  0) {
                                            return Center(
                                                child: Text(
                                                    "No data found for this date range and location"));
                                          }
                                          if (dateTimeList == null) {
                                            return GestureDetector(
                                              onTap: () async {
                                                dateTimeList =
                                                    await showOmniDateTimeRangePicker(
                                                  context: context,
                                                  startInitialDate:
                                                      DateTime.now(),
                                                  startFirstDate: DateTime(1600)
                                                      .subtract(const Duration(
                                                          days: 3652)),
                                                  startLastDate:
                                                      DateTime.now().add(
                                                    const Duration(days: 3652),
                                                  ),
                                                  endInitialDate:
                                                      DateTime.now(),
                                                  endFirstDate: DateTime(1600)
                                                      .subtract(const Duration(
                                                          days: 3652)),
                                                  endLastDate:
                                                      DateTime.now().add(
                                                    const Duration(days: 3652),
                                                  ),
                                                  is24HourMode: false,
                                                  isShowSeconds: false,
                                                  minutesInterval: 1,
                                                  secondsInterval: 1,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16)),
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxWidth: 350,
                                                    maxHeight: 650,
                                                  ),
                                                  transitionBuilder: (context,
                                                      anim1, anim2, child) {
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
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  barrierDismissible: true,
                                                  selectableDayPredicate:
                                                      (dateTime) {
                                                    return true;
                                                  },
                                                );
                                                setState(() {
                                                  dateTimeList;
                                                });
                                              },
                                              child: Center(
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 200,
                                                  child: Container(
                                                    decoration: ShapeDecoration(
                                                      shape:
                                                          RoundedRectangleBorder(),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(1),
                                                      child: DecoratedBox(
                                                        child: Center(
                                                          child: Text(
                                                            'Please Select Date Range!',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        decoration:
                                                            ShapeDecoration(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          print("errorId: iefjowje: ${e}");
                                          return Center(
                                            child: SizedBox(
                                              height: 50,
                                              width: 200,
                                              child: Container(
                                                decoration: ShapeDecoration(
                                                  shape:
                                                      RoundedRectangleBorder(),
                                                  color: Colors.transparent,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(1),
                                                  child: DecoratedBox(
                                                    child: Center(
                                                      child: Text(
                                                        'Please Select Location!',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    decoration: ShapeDecoration(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              datalistwithfilteredvalue.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
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
                                                      .fromSTEB(0, 0, 0, 0),
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
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '${datalistwithfilteredvalue[index].pname}${"\n"}(${datalistwithfilteredvalue[index].brand})',
                                                                              style: TextStyle(
                                                                                color: Color(0xFF4B39EF),
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.normal,
                                                                              )),
                                                                          datalistwithfilteredvalue[index].status == "in"
                                                                              ? Text('Description: ${datalistwithfilteredvalue[index].description}',
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF4B39EF),
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ))
                                                                              : Container()
                                                                        ],
                                                                      ),
                                                                      datalistwithfilteredvalue[index].type ==
                                                                              "add"
                                                                          ? Text(
                                                                              'Product Added',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                color: Color.fromARGB(255, 0, 197, 85),
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.normal,
                                                                              ))
                                                                          : datalistwithfilteredvalue[index].status == "in"
                                                                              ? Text('Quantity Added (${datalistwithfilteredvalue[index].initialquantity} + ${int.parse(datalistwithfilteredvalue[index].finalquantity.toString()) - int.parse(datalistwithfilteredvalue[index].initialquantity.toString())} = ${datalistwithfilteredvalue[index].finalquantity})',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Color.fromARGB(255, 0, 197, 85),
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ))
                                                                              : Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    Text('Sold Quantity ${int.parse(datalistwithfilteredvalue[index].initialquantity.toString()) - int.parse(datalistwithfilteredvalue[index].finalquantity.toString())}',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                                          color: Color.fromARGB(255, 204, 90, 33),
                                                                                          fontSize: 11,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        )),
                                                                                    Text('Available: ${datalistwithfilteredvalue[index].initialquantity} - ${int.parse(datalistwithfilteredvalue[index].initialquantity.toString()) - int.parse(datalistwithfilteredvalue[index].finalquantity.toString())} = ${datalistwithfilteredvalue[index].finalquantity}, ${datalistwithfilteredvalue[index].datetime.toString().split(" ")[0]}',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                                          color: Color.fromARGB(255, 204, 90, 33),
                                                                                          fontSize: 11,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        )),
                                                                                  ],
                                                                                ), //
                                                                    ],
                                                                  ),
                                                                  datalistwithfilteredvalue[index]
                                                                              .lotid ==
                                                                          null
                                                                      ? Container()
                                                                      : Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                child: Text("Lot Id: ${datalistwithfilteredvalue[index].lotid}",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4B39EF),
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    )),
                                                                              ),
                                                                              Text("Date: ${datalistwithfilteredvalue[index].datetime.toString().split(" ")[0]}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF4B39EF),
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ))
                                                                            ],
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
                                                ),
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
      ),
    );
  }
}
