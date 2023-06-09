import 'package:flutter/material.dart';

const kMobileWidthCutoff = 479.0;
bool responsiveVisibility({
  required BuildContext context,
  bool phone = true,
  bool tablet = true,
  bool tabletLandscape = true,
  bool desktop = true,
}) {
  final width = MediaQuery.of(context).size.width;
  if (width < kMobileWidthCutoff) {
    return phone;
  } else if (width < 767) {
    return tablet;
  } else if (width < 991) {
    return tabletLandscape;
  } else {
    return desktop;
  }
}
