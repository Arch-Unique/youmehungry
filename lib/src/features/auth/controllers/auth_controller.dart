import 'package:youmehungry/src/features/auth/add_destination_page.dart';
import 'package:youmehungry/src/features/auth/auth_page.dart';
import 'package:youmehungry/src/features/auth/forgot_password_page.dart';
import 'package:youmehungry/src/features/auth/repository/auth_repo.dart';
import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/features/dashboard/explorer_page.dart';
import 'package:youmehungry/src/global/model/loading.dart';
import 'package:youmehungry/src/global/model/location.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController {
  Rx<AuthMode> authMode = AuthMode.register.obs;
  bool get isRegister => authMode.value == AuthMode.register;
  List<Location> locations = [];
  List<Location> country = [];
  RxBool locationLoading = true.obs;

  /// 0 - full name
  /// 1 - email
  /// 2 - password
  /// 3 - password
  /// 4 - password
  /// 5 - address
  /// 6 - dob
  /// 7 - password
  /// 8 - password
  /// 9 - password
  List<TextEditingController> tecs = List.generate(
    10,
    (i) => TextEditingController(),
  );
  final afcController = AddressFieldController(TextEditingController(), true);
  final authKey = GlobalKey<FormState>();
  final fpKey = GlobalKey<FormState>();
  final rpKey = GlobalKey<FormState>();
  final authRepo = Get.find<AuthRepo>();
  final dbController = Get.find<DashboardController>();

  onAuthPressed() async {
    try {
      if (isRegister) {
        if (authKey.currentState!.validate()) {
          //register user\
          await authRepo.register(
            tecs[0].text,
            tecs[1].text,
            tecs[2].text,
            tecs[3].text,
            afcController.tec.text,
            tecs[6].text,
            afcController.country,
          );
          // Get.to(AddDestinationScreen());

          Get.offAll(AuthScreen(isLogin: true));
          Ui.showInfo("A verification link has been sent to your email");
        }
      } else {
        if (authKey.currentState!.validate()) {
          //login user
          await authRepo.login(tecs[1].text, tecs[2].text);
          dbController.resetInit();
          dbController.initApp();
          Get.offAllNamed(AppRoutes.dashboard);
        }
      }
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  onSocialPressed(ThirdPartyTypes tpt) async {
    try {
      await authRepo.loginSocial(tpt);
      dbController.initApp();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  onFPPressed() async {
    try {
      if (fpKey.currentState!.validate()) {
        //forgot password
        await authRepo.forgotPassword(tecs[1].text);
        Get.to(ForgotPasswordSuccess());
      }
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  onRPPressed() async {
    if (rpKey.currentState!.validate()) {
      //forgot password
      Get.to(AuthScreen(isLogin: true));
    }
  }

  initAllLocations() async {
    locationLoading.value = true;
    locations = (await authRepo.dbRepo.getAllLocations()).data;
    List<String> ct = locations
        .map((e) => e.country ?? "Nigeria")
        .toSet()
        .toList();
    final ctt = ct
        .map(
          (e) => e == "South Africa"
              ? locations.lastWhere((f) => f.country == e)
              : locations.firstWhere((f) => f.country == e),
        )
        .toList();
    List<Location> ctg = List.from(ctt);
    final ls = ctg.last;
    ctg.removeLast();
    ctg.insert(0, ls);
    country = ctg;

    locationLoading.value = false;
  }
}
