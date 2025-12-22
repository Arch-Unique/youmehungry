import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/features/dashboard/views/city_guide/city_guide_page.dart';
import 'package:youmehungry/src/features/dashboard/views/home/home_page.dart';
import 'package:youmehungry/src/features/dashboard/views/home/views/aichat.dart';
import 'package:youmehungry/src/features/dashboard/views/profile/profile_page.dart';
import 'package:youmehungry/src/features/dashboard/views/wallet/wallet_page.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final screens = [
    Builder(
      builder: (context) {
        return HomeScreen();
      },
    ),
    Builder(
      builder: (context) {
        return WalletScreen();
      },
    ),
    Builder(
      builder: (context) {
        return CityGuideScreen();
      },
    ),
    Builder(
      builder: (context) {
        return ProfileScreen();
      },
    ),
  ];

  final controller = Get.find<DashboardController>();

  @override
  void initState() {
    // controller.initApp();
    print("hello");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Ui.width(context));
    return ConnectivityWidget(
      child: Scaffold(
        body: Obx(() {
          return screens[controller.curScreen.value];
        }),
        floatingActionButton: InkWell(
          onTap: () {
            Get.to(AIChatScreen());
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 0),
                  blurRadius: 50,
                  spreadRadius: 3,
                  color: Color(0xFFF2F2F2).withOpacity(0.1),
                ),
              ],
            ),
            child: Center(child: UniversalImage(Assets.rlogo, width: 24)),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CDivider(),
              Container(
                width: Ui.width(context),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(screens.length, (i) {
                    return InkWell(
                      onTap: () {
                        if (i == 1 &&
                            controller.dbRepo.appService.currentUser.value.id ==
                                0) {
                          Ui.showError("Please login to access wallet");
                          controller.curScreen.value = 3;
                          return;
                        }
                        controller.curScreen.value = i;
                      },
                      child: SizedBox(
                        width: ((Ui.width(context) - 16) / 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return AppIcon(
                                DashboardMode.values[i].icon,
                                color: controller.curScreen.value == i
                                    ? AppColors.primaryColor
                                    : AppColors.disabledColor,
                              );
                            }),
                            Ui.boxHeight(4),
                            Obx(() {
                              return AppText.thin(
                                DashboardMode.values[i].title,
                                fontSize: 12,
                                alignment: TextAlign.center,
                                color: controller.curScreen.value == i
                                    ? AppColors.primaryColor
                                    : AppColors.disabledColor,
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
