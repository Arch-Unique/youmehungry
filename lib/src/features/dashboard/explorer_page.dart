import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/features/dashboard/views/cart/cartpage.dart';
import 'package:youmehungry/src/features/dashboard/views/home/homepage.dart';
import 'package:youmehungry/src/features/dashboard/views/orders/orderpage.dart';
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
        return HomePage();
      },
    ),
    Builder(
      builder: (context) {
        return CartPage();
      },
    ),
    Builder(
      builder: (context) {
        return OrderPage();
      },
    ),
    Builder(
      builder: (context) {
        return Placeholder();
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
                                    ? AppColors.accentColor
                                    : Color(0xFF4B4B4B),
                              );
                            }),
                            Ui.boxHeight(4),
                            Obx(() {
                              return AppText(
                                DashboardMode.values[i].title,
                                fontSize: 12,
                                alignment: TextAlign.center,
                                weight: controller.curScreen.value == i ? FontWeight.w600 : FontWeight.w400,
                                color: controller.curScreen.value == i
                                    ? AppColors.primaryColor
                                    : Color(0xFF4B4B4B),
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
