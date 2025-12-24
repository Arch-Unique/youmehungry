import 'package:flutter/material.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/global/ui/widgets/text/app_text.dart';
import 'package:youmehungry/src/src_barrel.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Notification",
      child: ListView.separated(
        separatorBuilder: (context, index) => CDivider(),
        itemBuilder: (c, i) {
          return notifItem(
            "Orders Successful",
            "You have placed an order at Burger King and paid \$24. Your food will arrive soon. Enjoy our services.",
            Icons.shopping_bag,
            "3 Mar, 2025 | 20:50 pm",
            i % 2 == 0,
          );
        },
        itemCount: 10,
      ),
    );
  }

  notifItem(String title, String desc, dynamic icon, String time, bool isNew) {
    return Ui.padding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              children: [
                AppIcon(icon, size: 40),
                Ui.boxWidth(32),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.medium(title, fontSize: 18),
                      AppText.thin(time, fontSize: 14),
                    ],
                  ),
                ),
                Ui.boxWidth(16),
                if (isNew)
                  Chip(
                    label: AppText.thin("New",color: AppColors.white,fontSize: 14),
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    color: WidgetStatePropertyAll(AppColors.primaryColor),
                  ),
              ],
            ),
          Ui.boxHeight(16),
          AppText.thin(desc, fontSize: 14),
        ],
      ),
    );
  }
}
