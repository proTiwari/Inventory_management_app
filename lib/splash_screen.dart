import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplode_management/location_screen.dart';
import 'package:xplode_management/login_screen.dart';
import 'package:xplode_management/router.dart';

import 'admin_panel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() async {
    bool status = false;
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser != null) {
        status = true;
      }
    } catch (e) {
      print(e);
    }
    print(status);
    if (status) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LocationlistWidget(),
          ),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginpageWidget(),
          ),
        );
      });
    }
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginpageWidget(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
