import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:youmehungry/src/features/dashboard/views/cart/cartpage.dart';
import 'package:youmehungry/src/features/dashboard/views/home/notificationpage.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_dropdown.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      color: AppColors.primaryColor,
      padding: EdgeInsets.all(16),
      radius: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CurvedContainer(
                padding: EdgeInsets.all(8),
                color: AppColors.accentColor,
                child: AppIcon(Icons.location_on_outlined),
              ),
              Ui.boxWidth(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.thin(
                          "Current Location ",
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                        AppIcon(
                          Icons.arrow_drop_down,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ],
                    ),
                    Ui.boxHeight(8),
                    AppText.medium(
                      "Times Square NYC, Manhanttan Manhattan",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              Ui.boxWidth(24),
              CurvedContainer(
                padding: EdgeInsets.all(8),
                color: AppColors.black,
                child: AppIcon(
                  Iconsax.shopping_cart_outline,
                  color: AppColors.white,
                ),
                onPressed: (){
                  Get.to(CartPage());
                },
              ),
              Ui.boxWidth(10),
              CurvedContainer(
                padding: EdgeInsets.all(8),
                color: AppColors.black,
                onPressed: (){
                  Get.to(NotificationPage());
                },
                child: AppIcon(
                  Icons.notifications_none_outlined,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Ui.boxHeight(16),
          CurvedContainer(
            width: Ui.width(context) - 32,
            onPressed: () {},
            padding: EdgeInsets.all(8),
            color: AppColors.white,
            child: Row(
              children: [
                AppIcon(
                  Icons.search,
                  color: AppColors.lightTextColor2,
                  
                ),

                Ui.boxWidth(16),
                Expanded(
                  child: AppText.thin(
                    "Search Menu,Restaurant, etc",
                    color: AppColors.borderColor,
                  ),
                ),
                Ui.boxWidth(16),
                AppIcon(
                  Iconsax.setting_5_outline,
                  color: AppColors.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
