import 'package:youmehungry/src/global/services/barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../route.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    FlutterNativeSplash.remove();

    final controller = Get.find<AppService>();
    if (controller.hasOpenedOnboarding.value) {
      if (controller.isLoggedIn.value) {
        return const RouteSettings(name: AppRoutes.dashboard);
      } else {
        return const RouteSettings(name: AppRoutes.auth);
      }
    }
    return super.redirect(route);
  }
}
