import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xplode_management/router.dart';
import 'package:xplode_management/utils.dart';

class LoginpageWidget extends StatefulWidget {
  const LoginpageWidget({Key? key}) : super(key: key);

  @override
  _LoginpageWidgetState createState() => _LoginpageWidgetState();
}

class _LoginpageWidgetState extends State<LoginpageWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  bool passwordVisibility2 = false;
  bool passwordVisibility1 = false;
  final _emailControlleradmin = TextEditingController();
  final _passwordControlleradmin = TextEditingController();
  final _emailControllerowner = TextEditingController();
  final _passwordControllerowner = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  var role;
  var email;

  void _signin(variable) async {
    if (variable == "owner") {
      email = _emailControllerowner.text.trim();
    }
    if (variable == 'admin') {
      email = _emailControlleradmin.text.trim();
    }
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        role = value.docs[0].data()['role'];
        print("role: ${value.docs[0].data()['role']}");
        print("user exist");
      } else {
        print("user not exist");
        Get.snackbar(
          "Error",
          "User not exist",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        return;
      }
    });
    if (variable == 'owner' && role == 'owner') {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailControllerowner.text.trim(),
                password: _passwordControllerowner.text.trim())
            .catchError((e) {
          print("error id $e");
          Get.snackbar(
            "Error",
            "$e",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add_alert),
          );
        });
        Get.toNamed(AppRoutes.locationscreen );
      } catch (e) {
        Get.snackbar(
          "Error",
          "$e",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        print("error id $e");
      }
    }

    if (role == 'disabled') {
      Get.snackbar(
        "Error",
        "Your account is disabled",
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
      return;
    }

    if (variable == 'admin' && role == 'admin') {
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailControlleradmin.text.trim(),
                password: _passwordControlleradmin.text.trim())
            .catchError((e) {
          print("error id $e");
          Get.snackbar(
            "Error",
            "$e",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add_alert),
          );
        });
        Get.toNamed(AppRoutes.adminpanel);
      } catch (e) {
        Get.snackbar(
          "Error",
          "$e",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        print("error id $e");
      }
    }
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                child: Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 72),
                    child: Text(
                      'Xplode.Solutions',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 170, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width >= 768.0
                                ? 530.0
                                : 630.0,
                            constraints: BoxConstraints(
                              maxWidth: 570,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFF1F4F8),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                              child: DefaultTabController(
                                length: 1,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment(0, 0),
                                      child: TabBar(
                                        isScrollable: true,
                                        labelColor: Color(0xFF101213),
                                        unselectedLabelColor: Color(0xFF57636C),
                                        labelPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                32, 0, 32, 0),
                                        labelStyle: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        indicatorColor: Color(0xFF4B39EF),
                                        indicatorWeight: 3,
                                        tabs: [
                                          Tab(
                                            text: 'Owner\'s Account',
                                          ),
                                          // Tab(
                                          //   text: 'Admin',
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, -1),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(24, 16, 24, 0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (responsiveVisibility(
                                                      context: context,
                                                      phone: false,
                                                      tablet: false,
                                                    ))
                                                      Container(
                                                        width: 230,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 24),
                                                      child: Text(
                                                          'Let\'s get started by filling out the form below.',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Color(
                                                                0xFF57636C),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 16),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller:
                                                              _emailControllerowner,
                                                          autofocus: true,
                                                          autofillHints: [
                                                            AutofillHints.email
                                                          ],
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Email',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF57636C),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFE0E3E7),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFF4B39EF),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFFF5963),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFFF5963),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24,
                                                                        24,
                                                                        24,
                                                                        24),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: const Color
                                                                    .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 16),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller:
                                                              _passwordControllerowner,
                                                          autofocus: true,
                                                          autofillHints: [
                                                            AutofillHints
                                                                .password
                                                          ],
                                                          obscureText:
                                                              !passwordVisibility1,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Password',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF57636C),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFE0E3E7),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFF4B39EF),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFFF5963),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color(
                                                                    0xFFFF5963),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24,
                                                                        24,
                                                                        0,
                                                                        24),
                                                            suffixIcon: InkWell(
                                                              onTap: () =>
                                                                  setState(
                                                                () => passwordVisibility1 =
                                                                    !passwordVisibility1,
                                                              ),
                                                              focusNode: FocusNode(
                                                                  skipTraversal:
                                                                      true),
                                                              child: Icon(
                                                                passwordVisibility1
                                                                    ? Icons
                                                                        .visibility_outlined
                                                                    : Icons
                                                                        .visibility_off_outlined,
                                                                color: Color(
                                                                    0xFF57636C),
                                                                size: 24,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Color(
                                                                0xFF101213),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      0, 0, 16),
                                                          child: SizedBox(
                                                            height: 45,
                                                            width: 100,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Color(
                                                                            0xFF4B39EF)),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // sign in
                                                                _signin(
                                                                    "owner");
                                                              },
                                                              child: Text(
                                                                'Sign In',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Align(
                                          //   alignment:
                                          //       AlignmentDirectional(0, -1),
                                          //   child: Padding(
                                          //     padding: EdgeInsetsDirectional
                                          //         .fromSTEB(24, 16, 24, 0),
                                          //     child: SingleChildScrollView(
                                          //       child: Column(
                                          //         mainAxisSize:
                                          //             MainAxisSize.max,
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         children: [
                                          //           if (responsiveVisibility(
                                          //             context: context,
                                          //             phone: false,
                                          //             tablet: false,
                                          //           ))
                                          //             Container(
                                          //               width: 230,
                                          //               height: 40,
                                          //               decoration:
                                          //                   BoxDecoration(
                                          //                 color: Colors.white,
                                          //               ),
                                          //             ),
                                          //           Padding(
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         0, 4, 0, 24),
                                          //             child: Text(
                                          //                 'Fill out the information below in order to access your account.',
                                          //                 textAlign:
                                          //                     TextAlign.start,
                                          //                 style: TextStyle(
                                          //                   fontFamily:
                                          //                       'Plus Jakarta Sans',
                                          //                   color: Color(
                                          //                       0xFF57636C),
                                          //                   fontSize: 14,
                                          //                   fontWeight:
                                          //                       FontWeight.w500,
                                          //                 )),
                                          //           ),
                                          //           Padding(
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         0, 0, 0, 16),
                                          //             child: Container(
                                          //               width: double.infinity,
                                          //               child: TextFormField(
                                          //                 controller:
                                          //                     _emailControlleradmin,
                                          //                 autofocus: true,
                                          //                 autofillHints: [
                                          //                   AutofillHints.email
                                          //                 ],
                                          //                 obscureText: false,
                                          //                 decoration:
                                          //                     InputDecoration(
                                          //                   labelText: 'Email',
                                          //                   labelStyle:
                                          //                       TextStyle(
                                          //                     fontFamily:
                                          //                         'Plus Jakarta Sans',
                                          //                     color: Color(
                                          //                         0xFF57636C),
                                          //                     fontSize: 16,
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w500,
                                          //                   ),
                                          //                   enabledBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFF1F4F8),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   focusedBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFF4B39EF),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   errorBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFE0E3E7),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   focusedErrorBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFE0E3E7),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   filled: true,
                                          //                   fillColor:
                                          //                       Colors.white,
                                          //                   contentPadding:
                                          //                       EdgeInsetsDirectional
                                          //                           .fromSTEB(
                                          //                               24,
                                          //                               24,
                                          //                               0,
                                          //                               24),
                                          //                 ),
                                          //                 style: TextStyle(
                                          //                   fontFamily:
                                          //                       'Plus Jakarta Sans',
                                          //                   color: Color(
                                          //                       0xFF101213),
                                          //                   fontSize: 16,
                                          //                   fontWeight:
                                          //                       FontWeight.w500,
                                          //                 ),
                                          //                 keyboardType:
                                          //                     TextInputType
                                          //                         .emailAddress,
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           Padding(
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         0, 0, 0, 16),
                                          //             child: Container(
                                          //               width: double.infinity,
                                          //               child: TextFormField(
                                          //                 controller:
                                          //                     _passwordControlleradmin,
                                          //                 autofocus: true,
                                          //                 autofillHints: [
                                          //                   AutofillHints
                                          //                       .password
                                          //                 ],
                                          //                 obscureText:
                                          //                     !passwordVisibility2,
                                          //                 decoration:
                                          //                     InputDecoration(
                                          //                   labelText:
                                          //                       'Password',
                                          //                   labelStyle:
                                          //                       TextStyle(
                                          //                     fontFamily:
                                          //                         'Plus Jakarta Sans',
                                          //                     color: Color(
                                          //                         0xFF57636C),
                                          //                     fontSize: 16,
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w500,
                                          //                   ),
                                          //                   enabledBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFE0E3E7),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   focusedBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFF4B39EF),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   errorBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFFF5963),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   focusedErrorBorder:
                                          //                       OutlineInputBorder(
                                          //                     borderSide:
                                          //                         BorderSide(
                                          //                       color: Color(
                                          //                           0xFFFF5963),
                                          //                       width: 2,
                                          //                     ),
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 40),
                                          //                   ),
                                          //                   filled: true,
                                          //                   fillColor:
                                          //                       Colors.white,
                                          //                   contentPadding:
                                          //                       EdgeInsetsDirectional
                                          //                           .fromSTEB(
                                          //                               24,
                                          //                               24,
                                          //                               0,
                                          //                               24),
                                          //                   suffixIcon: InkWell(
                                          //                     onTap: () =>
                                          //                         setState(
                                          //                       () => passwordVisibility2 =
                                          //                           !passwordVisibility2,
                                          //                     ),
                                          //                     focusNode: FocusNode(
                                          //                         skipTraversal:
                                          //                             true),
                                          //                     child: Icon(
                                          //                       passwordVisibility2
                                          //                           ? Icons
                                          //                               .visibility_outlined
                                          //                           : Icons
                                          //                               .visibility_off_outlined,
                                          //                       color: Color(
                                          //                           0xFF57636C),
                                          //                       size: 24,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 style: TextStyle(
                                          //                   fontFamily:
                                          //                       'Plus Jakarta Sans',
                                          //                   color: Color(
                                          //                       0xFF101213),
                                          //                   fontSize: 16,
                                          //                   fontWeight:
                                          //                       FontWeight.w500,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           Align(
                                          //             alignment:
                                          //                 AlignmentDirectional(
                                          //                     0, 0),
                                          //             child: Padding(
                                          //               padding:
                                          //                   EdgeInsetsDirectional
                                          //                       .fromSTEB(0, 0,
                                          //                           0, 16),
                                          //               child: SizedBox(
                                          //                 height: 45,
                                          //                 width: 100,
                                          //                 child: ElevatedButton(
                                          //                   style: ButtonStyle(
                                          //                     backgroundColor:
                                          //                         MaterialStateProperty.all<
                                          //                                 Color>(
                                          //                             Color(
                                          //                                 0xFF4B39EF)),
                                          //                     shape: MaterialStateProperty
                                          //                         .all<
                                          //                             RoundedRectangleBorder>(
                                          //                       RoundedRectangleBorder(
                                          //                         borderRadius:
                                          //                             BorderRadius
                                          //                                 .circular(
                                          //                                     40.0),
                                          //                       ),
                                          //                     ),
                                          //                   ),
                                          //                   onPressed: () {
                                          //                     // sign in
                                          //                     _signin("admin");
                                          //                   },
                                          //                   child: Text(
                                          //                     'Sign In',
                                          //                     style: TextStyle(
                                          //                         color: Colors
                                          //                             .white),
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //         ], //0xFF4B39EF
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
