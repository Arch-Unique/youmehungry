import 'package:youmehungry/src/global/controller/connection_controller.dart';
import 'package:youmehungry/src/global/services/barrel.dart';
import 'package:get/get.dart';

import '../../features/auth/repository/auth_repo.dart';
import '../../features/dashboard/controllers/dashboard_controller.dart';
import '../../features/dashboard/repo/dashboard_repo.dart';

class AppDependency {
  static init() async {
    Get.put(MyPrefService());
    Get.put(DioApiService());
    await Get.putAsync(() async {
      final connectTivity = ConnectionController();
      await connectTivity.init();
      return connectTivity;
    });
    await Get.putAsync(() async {
      final appService = AppService();
      await appService.initUserConfig();
      return appService;
    });
    Get.put(ApiWorker());

    // //repos

    Get.put(DashboardRepo());
    Get.put(AuthRepo());
    // Get.put(ProfileRepo());
    // Get.put(FacilityRepo());

    // //controllers
    await Get.putAsync(() async {
      final db = DashboardController();
      await db.startApp();
      return db;
    });
  }
}
