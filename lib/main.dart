import 'package:universal_html/html.dart' as html;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:xplode_management/location_screen.dart';
import 'package:xplode_management/product_list.dart';
import 'package:xplode_management/router.dart';

import 'admin_login.dart';
import 'admin_panel.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAFokIPvRp06kw9tQDaG0dnzTpCwQoPlEs",
      authDomain: "xplode-inventory-app.firebaseapp.com",
      projectId: "xplode-inventory-app",
      storageBucket: "xplode-inventory-app.appspot.com",
      messagingSenderId: "188414407592",
      appId: "1:188414407592:web:df17c67cf2a280614de39d",
      measurementId: "G-TFMTDLDV7D",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    try {
      String currentUrl = html.window.location.href;
      print("current url: $currentUrl");
      if (currentUrl.contains("admin")) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(AppRoutes.admin);
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return GetMaterialApp(
      routes: {
        '/admin/': (context) => const AdminLoginpageWidget(),
      },
      onGenerateInitialRoutes: (initialRoute) => [
        GetPageRoute(
          settings: RouteSettings(name: '/admin/'),
          page: () => const AdminLoginpageWidget(),
        ),
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashscreen,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppRoutes.routes,
    );
  }
}
