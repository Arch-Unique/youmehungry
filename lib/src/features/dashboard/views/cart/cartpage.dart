import 'package:flutter/material.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/ui/functions/ui_functions.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/src_barrel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyCart = EmptyScreen(
      "Empty",
      "You do not have an foods in cart at this time",
      Assets.emptyCart,
    );
    return SinglePageScaffold(
      title: "My Cart",
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (c, i) {
                return cartItem(
                  "Life Of Salad",
                  "McDonald's",
                  Assets.test1,
                  24.56,
                  i + 1,
                );
              },
              separatorBuilder: (c, i) {
                return CDivider();
              },
              itemCount: 10,
            ),
          ),
          Ui.padding(child: Stack(
            children: [
              
              AppButton(onPressed: (){},text: "Proceed to order",),
              Positioned(
                left: 16,
                top: 12,
                child: CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xff3a70e2).withValues(alpha: 0.12),
                child: Center(
                  child: AppText.medium("5",color: AppColors.accentColor),
                ),
              ))
            ],
          ))
        ],
      ),
    );
  }

  cartItem(
    String name,
    String restaurant,
    String product,
    double price,
    int qty,
  ) {
    return CurvedContainer(
      radius: 0,
      padding: EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CurvedImage(product, w: 64, h: 64, fit: BoxFit.cover),
          ),
          Ui.boxWidth(24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bold(name),
              AppText.thin(restaurant, color: AppColors.lightTextColor3),
              AppText.thin(
                "$qty items | 2.7 km",
                color: AppColors.lightTextColor3,
              ),
              AppText.bold(price.toCurrency(), color: AppColors.primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}
