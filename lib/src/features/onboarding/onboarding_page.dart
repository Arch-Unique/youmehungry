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
    final pics = [Assets.onb, Assets.onb1, Assets.onb3];
    final controller = PageController();
    RxInt curPic = 0.obs;
    Timer.periodic(const Duration(seconds: 3), (t) {
      if (curPic.value == pics.length - 1) {
        // curPic.value = 0;
        controller.jumpToPage(0);
      } else {
        controller.animateToPage(
          ++curPic.value,
          duration: Duration(seconds: 1),
          curve: Curves.easeIn,
        );
        // curPic.value++;
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (c, i) {
              return FadeAnimWidget(
                child: UniversalImage(
                  pics[i],
                  height: Ui.height(context),
                  width: Ui.width(context),
                  fit: BoxFit.cover,
                ),
              );
            },
            reverse: false,
            itemCount: pics.length,
            onPageChanged: (v) {
              curPic.value = v;
            },
            controller: controller,
            padEnds: false,
          ),
          // Obx(
          //    () {
          //     return UniversalImage(
          //       pics[curPic.value],
          //       height: Ui.height(context),
          //       width: Ui.width(context),
          //       fit: BoxFit.cover,
          //     );
          //   }
          // ),
          Container(
            height: Ui.height(context),
            width: Ui.width(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.red.withOpacity(0), AppColors.black],
              ),
            ),
          ),
          Positioned(
            width: Ui.width(context),
            bottom: 0,
            child: Ui.padding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UniversalImage(Assets.logo, width: Ui.width(context) - 64),
                  OnboardingActions(),
                ],
              ),
            ),
          ),
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
            text: "Create Account",
          ),
          Ui.boxHeight(12),
          AppButton.outline(() {
            Get.off(AuthScreen(isLogin: true));
          }, "Login"),
          Ui.boxHeight(12),
          SafeArea(
            child: GestureDetector(
              onTap: () async {
                Get.find<DashboardController>().initApp();
                Get.offAll(ExplorerScreen());
              },
              child: Ui.padding(
                padding: 8,
                child: AppText.medium("Continue as Guest", fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
