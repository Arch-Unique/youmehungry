import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/global/model/esim.dart';
import 'package:youmehungry/src/global/services/barrel.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/plugin/paypal.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:youmehungry/src/utils/constants/countries.dart';
import 'package:flutter/foundation.dart' as fff;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../repo/dashboard_repo.dart';

class DashboardController extends GetxController {
  Rx<DashboardMode> currentDashboardMode = DashboardMode.home.obs;
  RxBool isLoading = false.obs;
  RxBool needsUpdate = false.obs;
  int get currentDashboardModeIndex => currentDashboardMode.value.index;
  RxInt curScreen = 0.obs;
  RxString curQuery = "".obs;

  List<TextEditingController> tecs = List.generate(
    11,
    (i) => TextEditingController(),
  );
  List<TextEditingController> walletTecs = List.generate(
    15,
    (i) => TextEditingController(),
  );

  final dbRepo = Get.find<DashboardRepo>();
  final profkey = GlobalKey<FormState>();
  final walletkey = GlobalKey<FormState>();
  late PackageInfo packageInfo;

  void resetInit() {
    currentDashboardMode.value = DashboardMode.home;
    curScreen.value = 0;
    curQuery.value = "";
  }

  Future<void> startApp() async {
    if (dbRepo.appService.isLoggedIn.value) {
      initApp();
    }
  }

  Future<void> initApp({Location? loc}) async {
    try {
      isLoading.value = true;
      packageInfo = await PackageInfo.fromPlatform();
      // allAppInfos.value = (await dbRepo.getAllAppInfo()).data;

      // if ((allAppInfos[1].numberValue?.toInt() ?? 0) >
      //     (int.tryParse(packageInfo.buildNumber) ?? 1)) {
      //   needsUpdate.value = true;
      // }

      final ml = await dbRepo.apiWorker.getUserLoc();

      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }
}
