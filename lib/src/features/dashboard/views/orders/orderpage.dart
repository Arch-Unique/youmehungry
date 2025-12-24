import 'package:flutter/material.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';
import '../../../shared.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyOrder = EmptyScreen(
      "Empty",
      "You do not have an active order at this time",
      Assets.emptyOrder,
    );
    return SinglePageScaffold(
      title: "Orders",
      child: TabSliderWidget(
        ["Active", "Completed", "Cancelled"],
        [activeItems(), completedItems(),emptyOrder],
      ),
    );
  }

  activeItems() {
    return ListView.separated(
      itemBuilder: (c, i) {
        return orderItem(
          "Life of Salad",
          Assets.test1,
          i + 1,
          24.55,
          "Active",
        );
      },
      separatorBuilder: (c, i) => CDivider(),
      itemCount: 3,
    );
  }

  completedItems() {
    return ListView.separated(
      itemBuilder: (c, i) {
        return orderItem(
          "Life of Salad",
          Assets.test1,
          i + 1,
          24.55,
          "Completed"
        );
      },
      separatorBuilder: (c, i) => CDivider(),
      itemCount: 3,
    );
  }

  orderItem(String name, String image, int qty, double price, String status) {
    final double w = 108;
    return CurvedContainer(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: [
          CurvedImage(image, w: 90, h: 90, fit: BoxFit.cover),
          Ui.boxWidth(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bold(name),
              AppText.thin(
                "$qty items | 2.7 km",
                color: AppColors.lightTextColor3,
              ),
              AppText.bold(price.toCurrency(), color: AppColors.primaryColor),
              Row(
                children: [
                  if (status.toLowerCase() == "active")
                    SizedBox(
                      width: w,
                      child: AppButton(
                        onPressed: () {},
                        text: "Cancel Order",
                        color: AppColors.accentColor,
                        textColor: AppColors.primaryColor,
                        v: 8,
                      ),
                    ),
                  if (status.toLowerCase() == "active") Ui.boxWidth(8),
                  if (status.toLowerCase() == "active")
                    SizedBox(
                      width: w,
                      child: AppButton(
                        onPressed: () {},
                        text: "Track Order",
                        v: 8,
                      ),
                    ),
                  if (status.toLowerCase() == "completed")
                    SizedBox(
                      width: w,
                      child: AppButton(
                        onPressed: () {},
                        text: "Order Details",
                        v: 8,
                      ),
                    ),
                  if (status.toLowerCase() == "cancelled")
                    SizedBox(
                      width: w,
                      child: AppButton.outline(
                        () {},
                        "Cancelled",
                        color: AppColors.red,
                        v: 8,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
