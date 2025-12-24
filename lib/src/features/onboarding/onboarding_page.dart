import 'dart:async';

import 'package:youmehungry/src/features/auth/auth_page.dart';
import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/features/dashboard/explorer_page.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = true.obs;
    Timer.periodic(const Duration(seconds: 2), (t) {
      isLoading.value = false;
    });
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const Spacer(),
          Image.asset(Assets.slogo, width: Ui.width(context)),
          Image.asset(Assets.fulllogo, width: Ui.width(context) - 64),
          Obx(() {
            return isLoading.value
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 48,
                      left: 16,
                      right: 16,
                    ),
                    child: const OnboardingActions(),
                  );
          }),

          const Spacer(),
        ],
      ),
    );
  }
}

class OnboardingActions extends StatelessWidget {
  const OnboardingActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Ui.boxHeight(12),
          AppButton(
            onPressed: () {
              Get.off(AuthScreen());
            },
            text: "Get Started",
            color: AppColors.black,
          ),
          Ui.boxHeight(12),
          AppButton(
            onPressed: () {
              Get.off(LoginScreen());
            },
            text: "Sign In",
            color: AppColors.accentColor,
            textColor: AppColors.black,
          ),
          Ui.boxHeight(12),
        ],
      ),
    );
  }
}
