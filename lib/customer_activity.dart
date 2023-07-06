import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xplode_management/router.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:xplode_management/state.dart';
import 'model/owner_model.dart';
import 'package:intl/intl.dart';

class ConsumerActivitylistWidget extends StatefulWidget {
  const ConsumerActivitylistWidget({Key? key}) : super(key: key);

  @override
  _ConsumerActivitylistWidgetState createState() =>
      _ConsumerActivitylistWidgetState();
}

class _ConsumerActivitylistWidgetState
    extends State<ConsumerActivitylistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var customername;

  @override
  void initState() {
    super.initState();
    getAllLocations();
    customername = Get.arguments;
  }

  var editquantity;
  var editdescription;
  var editdate;
  var editid;

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

  bool isDateLessThan(String date1, String date2) {
    DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(date1);
    DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(date2);

    return parsedDate1.isBefore(parsedDate2);
  }

  var locationlist = [];
  var locationlist1 = [];

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
                                          type: OmniDateTimePickerType.date,
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
                                  child: FFAppState().changestate
                                      ? Center(
                                          child: EditConsumerRecord(
                                              editquantity,
                                              editdate,
                                              editdescription,
                                              editid),
                                        )
                                      : StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .snapshots(), // Replace with your actual stream
                                          builder:
                                              (BuildContext context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<History> datalist = [];
                                              List<History>
                                                  datalistwithfilteredvalue =
                                                  [];
                                              try {
                                                OwnerModel data =
                                                    OwnerModel.fromJson(
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>);

                                                for (Location i
                                                    in data.locations!) {
                                                  print("fiwjeofjwoiejfw");
                                                  print(i.history!.length);
                                                  for (var j in i.history!) {
                                                    print("j isfjiowe ${j}");
                                                    if (j.customername ==
                                                        customername) {
                                                      locationlist
                                                          .add(i.locationName);
                                                      print(
                                                          "customer nsoiefjowie ${customername}");
                                                      datalist.add(j);
                                                    }
                                                  }
                                                }

                                                // code for filtering through date
                                                print(
                                                    "showing the data: ${datalist}");
                                                int count1 = 0;
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
                                                    print(
                                                        "logdateiojwe ${logdate}");
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
                                                            dateTimeList![0]
                                                                .day;

                                                    dateTimeList![1]
                                                                .day
                                                                .toString()
                                                                .length ==
                                                            1
                                                        ? dayat1 =
                                                            "0${dateTimeList![1].day}"
                                                        : dayat1 =
                                                            dateTimeList![1]
                                                                .day;

                                                    dateTimeList![0]
                                                                .month
                                                                .toString()
                                                                .length ==
                                                            1
                                                        ? monthat0 =
                                                            "0${dateTimeList![0].month}"
                                                        : monthat0 =
                                                            dateTimeList![0]
                                                                .month;

                                                    dateTimeList![1]
                                                                .month
                                                                .toString()
                                                                .length ==
                                                            1
                                                        ? monthat1 =
                                                            "0${dateTimeList![1].month}"
                                                        : monthat1 =
                                                            dateTimeList![1]
                                                                .month;
                                                    bool isdategreaterthan =
                                                        isDateGreaterThan(
                                                            finallogdate,
                                                            "$dayat0-$monthat0-${dateTimeList![0].year}");
                                                    print(
                                                        "isdategreaterthan ${isdategreaterthan}");
                                                    bool isdatelessthan =
                                                        isDateLessThan(
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
                                                      datalistwithfilteredvalue
                                                          .add(k);
                                                      print(
                                                          "iwoejfowjeio $datalistwithfilteredvalue");

                                                      try {
                                                        locationlist1.add(
                                                            locationlist[
                                                                count1]);
                                                      } catch (e) {
                                                        print("error: $e");
                                                      }

                                                      count1++;
                                                    } else {
                                                      count1++;
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        "errorid weifjowiej: $e");
                                                  }
                                                }

                                                datalistwithfilteredvalue.sort(
                                                    (a, b) => a.datetime!
                                                        .compareTo(
                                                            b.datetime!));
                                                datalistwithfilteredvalue =
                                                    datalistwithfilteredvalue
                                                        .reversed
                                                        .toList();
                                                print("datasfewe: ${datalist}");
                                                try {} catch (e) {
                                                  print("errorbgere: $e");
                                                }

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
                                                        type:
                                                            OmniDateTimePickerType
                                                                .date,
                                                        startFirstDate: DateTime(
                                                                1600)
                                                            .subtract(
                                                                const Duration(
                                                                    days:
                                                                        3652)),
                                                        startLastDate:
                                                            DateTime.now().add(
                                                          const Duration(
                                                              days: 3652),
                                                        ),
                                                        endInitialDate:
                                                            DateTime.now(),
                                                        endFirstDate: DateTime(
                                                                1600)
                                                            .subtract(
                                                                const Duration(
                                                                    days:
                                                                        3652)),
                                                        endLastDate:
                                                            DateTime.now().add(
                                                          const Duration(
                                                              days: 3652),
                                                        ),
                                                        is24HourMode: false,
                                                        isShowSeconds: false,
                                                        minutesInterval: 1,
                                                        secondsInterval: 1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    16)),
                                                        constraints:
                                                            const BoxConstraints(
                                                          maxWidth: 350,
                                                          maxHeight: 650,
                                                        ),
                                                        transitionBuilder:
                                                            (context, anim1,
                                                                anim2, child) {
                                                          return FadeTransition(
                                                            opacity:
                                                                anim1.drive(
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
                                                                milliseconds:
                                                                    200),
                                                        barrierDismissible:
                                                            true,
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
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(),
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            child: DecoratedBox(
                                                              child: Center(
                                                                child: Text(
                                                                  'Please Select Date Range!',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
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
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                print(
                                                    "errorId: iefjowje: ${e}");
                                                return Center(
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 200,
                                                    child: Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(),
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        child: DecoratedBox(
                                                          child: Center(
                                                            child: Text(
                                                              'Please Select Location!',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
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
                                                );
                                              }
                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount:
                                                    datalistwithfilteredvalue
                                                        .length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16, 8, 16, 0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 3,
                                                            color: Color(
                                                                0x20000000),
                                                            offset:
                                                                Offset(0, 1),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 0),
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
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            16,
                                                                            16,
                                                                            16),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text('${datalistwithfilteredvalue[index].pname}${"\n"}(${datalistwithfilteredvalue[index].brand})',
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4B39EF),
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    )),
                                                                                datalistwithfilteredvalue[index].status == "out"
                                                                                    ? Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Text('Description: ${datalistwithfilteredvalue[index].description}',
                                                                                              style: TextStyle(
                                                                                                color: Color(0xFF4B39EF),
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                          Text('Location: ${locationlist1[index]}',
                                                                                              style: TextStyle(
                                                                                                color: Color(0xFF4B39EF),
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                        ],
                                                                                      )
                                                                                    : Container(),
                                                                              ],
                                                                            ),
                                                                            datalistwithfilteredvalue[index].type == "add"
                                                                                ? Container()
                                                                                // ? Text('Product Added',
                                                                                //     style: TextStyle(
                                                                                //       fontFamily: 'Plus Jakarta Sans',
                                                                                //       color: Color.fromARGB(255, 0, 197, 85),
                                                                                //       fontSize: 11,
                                                                                //       fontWeight: FontWeight.normal,
                                                                                //     ))
                                                                                : datalistwithfilteredvalue[index].status == "in"
                                                                                    ? Text('Quantity Added (${datalistwithfilteredvalue[index].initialquantity} + ${int.parse(datalistwithfilteredvalue[index].quantity.toString())} = ${datalistwithfilteredvalue[index].finalquantity})',
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
                                                                                          Text('Sold Quantity ${int.parse(datalistwithfilteredvalue[index].quantity.toString())}',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color.fromARGB(255, 204, 90, 33),
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                          Text('Available: (${datalistwithfilteredvalue[index].initialquantity} - ${int.parse(datalistwithfilteredvalue[index].quantity.toString())} = ${datalistwithfilteredvalue[index].finalquantity})',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color.fromARGB(255, 204, 90, 33),
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )), //
                                                                                          Text('Date: ${datalistwithfilteredvalue[index].datetime.toString().split(" ")[0]}',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                                color: Color.fromARGB(255, 204, 90, 33),
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              )),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 8.0),
                                                                                            child: Card(
                                                                                              color: Colors.grey[200],
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        showDialog(
                                                                                                          context: context,
                                                                                                          builder: (ctx) => AlertDialog(
                                                                                                            title: Text('Delete'),
                                                                                                            content: Column(
                                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                                              children: <Widget>[
                                                                                                                Text(
                                                                                                                  'Are you sure you want to delete this record?',
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
                                                                                                                onPressed: () async {
                                                                                                                  try {
                                                                                                                    var id = datalistwithfilteredvalue[index].id;
                                                                                                                    print("lid: $id");
                                                                                                                    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                                                                      OwnerModel data = OwnerModel.fromJson(value.data() as Map<String, dynamic>);
                                                                                                                      print('klklk');
                                                                                                                      var quantity;
                                                                                                                      var date;
                                                                                                                      for (Location i in data.locations!) {
                                                                                                                        print('hhh');
                                                                                                                        try {
                                                                                                                          for (History j in i.history!) {
                                                                                                                            print('klklkmmm');
                                                                                                                            try {
                                                                                                                              if (j.id == id) {
                                                                                                                                quantity = j.quantity;
                                                                                                                                date = j.datetime;
                                                                                                                                print('klklbnbk');
                                                                                                                                i.history!.remove(j);
                                                                                                                                for (var n in i.history!) {
                                                                                                                                  if (n.datetime!.compareTo(date) > 0) {
                                                                                                                                    n.initialquantity = (int.parse(n.initialquantity!) + int.parse(quantity)).toString();
                                                                                                                                    n.finalquantity = (int.parse(n.finalquantity!) + int.parse(quantity)).toString();
                                                                                                                                  }
                                                                                                                                }
                                                                                                                                i.product!.quantity = (int.parse(i.product!.quantity!) + int.parse(quantity)).toString();
                                                                                                                                break;
                                                                                                                              }
                                                                                                                            } catch (e) {
                                                                                                                              print("errorhjj: $e");
                                                                                                                            }
                                                                                                                          }
                                                                                                                        } catch (e) {
                                                                                                                          print("errorhjjk: $e");
                                                                                                                        }
                                                                                                                      }

                                                                                                                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                                                        "locations": data.locations!.map((e) => e.toJson()).toList()
                                                                                                                      });
                                                                                                                    });
                                                                                                                    Navigator.of(context).pop();
                                                                                                                    print("hvhj2 ${datalistwithfilteredvalue}");
                                                                                                                  } catch (e) {
                                                                                                                    print("sdsddd: ${e}");
                                                                                                                  }
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        );
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.delete,
                                                                                                        color: Colors.blue,
                                                                                                        size: 20,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          editquantity = datalistwithfilteredvalue[index].quantity;
                                                                                                          editdate = datalistwithfilteredvalue[index].datetime;
                                                                                                          editdescription = datalistwithfilteredvalue[index].description;
                                                                                                          editid = datalistwithfilteredvalue[index].id;
                                                                                                          FFAppState().changestate = !FFAppState().changestate;
                                                                                                        });
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.edit,
                                                                                                        color: Colors.blue,
                                                                                                        size: 20,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ), //
                                                                          ],
                                                                        ),
                                                                        datalistwithfilteredvalue[index].lotid ==
                                                                                null
                                                                            ? Container()
                                                                            : Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              // Render a placeholder or loading indicator
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
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

class EditConsumerRecord extends StatefulWidget {
  var editquantity;
  var editdate;
  var editdescription;
  var editid;

  EditConsumerRecord(
      this.editquantity, this.editdate, this.editdescription, this.editid);

  @override
  _EditConsumerRecordState createState() => _EditConsumerRecordState();
}

class _EditConsumerRecordState extends State<EditConsumerRecord> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  DateTime? editdate;

  @override
  void initState() {
    super.initState();
    quantityController.text = widget.editquantity;
    descriptionController.text = widget.editdescription;
    dateController.text = widget.editdate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: quantityController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Sold Quantity',
              ),
            ),
            TextFormField(
              controller: descriptionController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              width: 300,
              child: GestureDetector(
                onTap: () async {
                  editdate = await showOmniDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    lastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: true,
                    type: OmniDateTimePickerType.date,
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
                  editdate;
                  setState(() {
                    dateController.text = editdate.toString();
                  });
                },
                child: dateController.text == ''
                    ? const Center(child: Text("Select Date"))
                    : Center(
                        child:
                            Text(dateController.text.toString().split(' ')[0]),
                      ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            FFAppState().changestate = false;
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () async {
            try {
              var id = widget.editid;
              print("lid: $id");
              await FirebaseFirestore.instance
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
                        if (j.id == id) {
                          quantity = j.quantity;
                          date = j.datetime;
                          var diddff;
                          bool decor = false;
                          print('klklbnbk');
                          for (History n in i.history!) {
                            print('klklkmdrgermm');
                            try {
                              if (n.datetime!.compareTo(date) > 0 ||
                                  n.datetime!.compareTo(date) == 0) {
                                print('iejiwoejfoiww');
                                if (int.parse(quantity!) >
                                    int.parse(quantityController.text)) {
                                  decor = true;
                                  print('klklkmdrgermmwewo');
                                  if (j.id == n.id) {
                                    try {
                                      int diff = int.parse(quantity!) -
                                          int.parse(quantityController.text);
                                      j.finalquantity =
                                          (int.parse(j.finalquantity!) + diff)
                                              .toString();
                                      j.quantity = quantityController.text;
                                      print('diff: ${diff}');
                                      diddff = diff;
                                    } catch (e) {
                                      print("string:ieow: ${e.toString()}");
                                    }
                                  } else {
                                    try {
                                      int diff = int.parse(quantity!) -
                                          int.parse(quantityController.text);
                                      n.initialquantity =
                                          (int.parse(n.initialquantity!) + diff)
                                              .toString();
                                      n.finalquantity =
                                          (int.parse(n.finalquantity!) + diff)
                                              .toString();
                                      print('diffm: ${diff}');
                                      diddff = diff;
                                    } catch (e) {
                                      print("string:ieow: ${e.toString()}");
                                    }
                                  }
                                }
                                if (int.parse(quantity!) <
                                    int.parse(quantityController.text)) {
                                  decor = false;
                                  print('klklkmdr9990wo');
                                  if (j.id == n.id) {
                                    try {
                                      int diff1 =
                                          int.parse(quantityController.text) -
                                              int.parse(quantity!);
                                      j.finalquantity =
                                          (int.parse(j.finalquantity!) - diff1)
                                              .toString();
                                      j.quantity = quantityController.text;
                                      print('diff1: ${diff1}');
                                      print(j.finalquantity);
                                      diddff = diff1;
                                    } catch (e) {
                                      print('oweioij: ${e.toString()}');
                                    }
                                  } else {
                                    try {
                                      int diff1 =
                                          int.parse(quantityController.text) -
                                              int.parse(quantity!);
                                      n.initialquantity =
                                          (int.parse(n.initialquantity!) -
                                                  diff1)
                                              .toString();
                                      n.finalquantity =
                                          (int.parse(n.finalquantity!) - diff1)
                                              .toString();
                                      diddff = diff1;
                                      print('diffk1: ${diff1}');
                                      print(n.finalquantity);
                                    } catch (e) {
                                      print('oweioij: ${e.toString()}');
                                    }
                                  }
                                }
                              }
                            } catch (e) {
                              print("errorhjkl'jj: $e");
                            }
                          }
                          try {
                            j.description = descriptionController.text;
                            j.datetime = dateController.text;
                            if (decor) {
                              i.product!.quantity =
                                  (int.parse(i.product!.quantity!) + diddff)
                                      .toString();
                            } else {
                              i.product!.quantity =
                                  (int.parse(i.product!.quantity!) - diddff)
                                      .toString();
                            }

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
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  "locations": data.locations!.map((e) => e.toJson()).toList()
                });
              });
            } catch (e) {
              print("sdsddd: ${e}");
            }
            FFAppState().changestate = false;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
