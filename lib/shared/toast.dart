import 'package:flutter/material.dart';
import 'package:patient_app/model/navigator.dart';

final navigatorKey = GlobalKey<NavigatorState>();
showToast(String msg) {
  ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(
    content: Text(msg),
  ));
}
