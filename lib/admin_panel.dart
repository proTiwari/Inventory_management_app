import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xplode_management/router.dart';

class AdminpanelWidget extends StatefulWidget {
  const AdminpanelWidget({Key? key}) : super(key: key);

  @override
  _AdminpanelWidgetState createState() => _AdminpanelWidgetState();
}

class _AdminpanelWidgetState extends State<AdminpanelWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  void _signup() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'uid': userCredential.user!.uid,
          'role': 'owner',
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      } catch (e) {
        Get.snackbar(
          "Error",
          "$e",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        print("error id 84r94289: ${e}");
      }
      Get.snackbar(
        "Success",
        "Owner Created Successfully",
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });
    }).catchError((error) {
      try {
        Get.snackbar(
          "Error",
          "$error",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        print("error id ttt94289: ${error}");
      } catch (e) {
        print("error id 84fwef239: ${e}");
      }
    });
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // Password reset email sent successfully
    } catch (e) {
      // An error occurred while sending the password reset email
      print('Error sending password reset email: $e');
    }
  }

  bool isEmailValid(String email) {
    // Regular expression pattern to validate email addresses
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  disableOwner() {
    if (isEmailValid(_emailController.text.trim())) {
      String email = _emailController.text.trim();
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'role': 'disabled'});
        });
        Get.snackbar(
          "Success",
          "updated role to disable",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
      });
    } else {
      Get.snackbar(
        "Error",
        "Please enter valid email",
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
    }
  }

  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  alignment: AlignmentDirectional(0, -1),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                            child: Text(
                              'Xplode.Solutions',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF101213),
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome Back',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF101213),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 24),
                                    child: Text(
                                        'Let\'s get started by filling out the form \nbelow to create owner.',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Color(0xFF57636C),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: 370,
                                      child: TextFormField(
                                        controller: _emailController,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.email],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFF1F4F8),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF4B39EF),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Color(0xFF101213),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter your email';
                                          }
                                          if (value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: 370,
                                      child: TextFormField(
                                        controller: _passwordController,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.password],
                                        obscureText: !passwordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFF1F4F8),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF4B39EF),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => passwordVisibility =
                                                  !passwordVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              passwordVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Color(0xFF57636C),
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Color(0xFF101213),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter your password';
                                          }
                                          if (value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                    child: SizedBox(
                                      width: 370,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: Text(
                                          'Create Owner',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF4B39EF),
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _signup();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 30),
                                    child: SizedBox(
                                      width: 370,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: Text(
                                          'disable Owner',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF4B39EF),
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () {
                                          disableOwner();
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 370,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 30),
                                          child: SizedBox(
                                            width: 240,
                                            height: 40,
                                            child: GestureDetector(
                                              onTap: () {
                                                FirebaseAuth.instance.signOut();
                                                Get.offAllNamed(
                                                    AppRoutes.loginscreen);
                                              },
                                              child: const Text(
                                                'Log Out',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 30),
                                          child: SizedBox(
                                            width: 370,
                                            height: 40,
                                            child: GestureDetector(
                                              onTap: () {
                                                resetPassword();
                                                if (isEmailValid(
                                                    _emailController.text
                                                        .trim())) {
                                                  Get.snackbar(
                                                    "Success",
                                                    "Password Reset Email Sent",
                                                    colorText: Colors.white,
                                                    backgroundColor:
                                                        Colors.lightBlue,
                                                    icon: const Icon(
                                                        Icons.add_alert),
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                    "Error",
                                                    "Please enter valid email",
                                                    colorText: Colors.white,
                                                    backgroundColor:
                                                        Colors.lightBlue,
                                                    icon: const Icon(
                                                        Icons.add_alert),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
