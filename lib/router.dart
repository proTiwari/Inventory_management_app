import 'package:get/get.dart';
import 'package:xplode_management/admin_panel.dart';
import 'package:xplode_management/location_screen.dart';
import 'package:xplode_management/login_screen.dart';
import 'package:xplode_management/product_list.dart';
import 'package:xplode_management/product_view_activity.dart';
import 'package:xplode_management/splash_screen.dart';
import 'package:xplode_management/view_activity.dart';

import 'admin_login.dart';

class AppRoutes {
  static const String splashscreen = '/splashscreen';
  static const String adminpanel = '/adminpanel';
  static const String saleorder = '/saleorder';
  static const String locationscreen = '/locationscreen';
  static const String productlist = '/productlist';
  static const String loginscreen = '/loginscreen';
  static const String admin = '/admin/';
  static const String activity = '/activity';
  static const String productactivity = '/productactivity';

  static final List<GetPage> routes = [
    GetPage(name: splashscreen, page: () => SplashScreen()),
    GetPage(name: adminpanel, page: () => AdminpanelWidget()),
    GetPage(name: locationscreen, page: () => LocationlistWidget()),
    GetPage(name: productlist, page: () => ProductlistWidget()),
    GetPage(name: loginscreen, page: () => LoginpageWidget()),
    GetPage(name: admin, page: () => AdminLoginpageWidget()),
    GetPage(name: activity, page: () => ActivitylistWidget()),
    GetPage(name: productactivity, page: () => ProductActivitylistWidget()),
  ];
}
