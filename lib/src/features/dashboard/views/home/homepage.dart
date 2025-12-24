import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmehungry/src/features/dashboard/shared/product.dart';
import 'package:youmehungry/src/features/dashboard/views/home/widgets.dart';
import 'package:youmehungry/src/global/ui/functions/ui_functions.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/src_barrel.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final currentCategory = "All".obs;
  final categories = [
    "All",
    "Breakfast",
    "Mexican",
    "Fast Food",
    "Alcohol",
    "Kids Meal",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeaderWidget(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Ui.boxWidth(8),
              ...List.generate(categories.length, (i) {
                return Obx(() {
                  return CurvedContainer(
                    width: 72,
                    height: 72,
                    color: AppColors.white,
                    margin: EdgeInsets.only(top: 8, right: 8, left: 8),
                    border: currentCategory.value == categories[i]
                        ? Border.all(color: AppColors.accentColor)
                        : null,
                    onPressed: () {
                      currentCategory.value = categories[i];
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(Icons.abc, size: 32),
                        Ui.boxHeight(4),
                        AppText.thin(categories[i]),
                      ],
                    ),
                  );
                });
              }),
              Ui.boxWidth(8),
            ],
          ),
        ),
        Ui.boxHeight(24),
        Obx(() {
          if (currentCategory.value == categories[0]) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FeaturedRestaurantWidget("Popular Near You", []),
                    FeaturedRestaurantWidget("Your Regulars", []),
                    FeaturedRestaurantWidget("Breakfast", []),
                    FeaturedRestaurantWidget("Lunch", []),
                    FeaturedRestaurantWidget("Dinner", []),
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: CategorizedRestaurantWidget(currentCategory.value, []),
          );
        }),
      ],
    );
  }
}
