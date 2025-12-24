import 'package:youmehungry/src/features/auth/auth_page.dart';
import 'package:youmehungry/src/features/dashboard/explorer_page.dart';
import 'package:youmehungry/src/features/onboarding/onboarding_page.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:youmehungry/src/utils/constants/routes/middleware/auth_middleware.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.home,
      page: () => OnboardingScreen(),
      middlewares: [AuthMiddleWare()],
    ),
    GetPage(name: AppRoutes.auth, page: () => AuthScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => ExplorerScreen()),
  ];
}
