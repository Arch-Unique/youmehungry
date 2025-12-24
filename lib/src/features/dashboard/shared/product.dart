import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/appbar/back_appbar.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/src_barrel.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(
    this.url, {
    this.width = 120,
    this.height = 120,
    this.hasBack = false,
    this.makerLogoWidget,
    this.discountWidget,
    super.key,
  });
  final String url;
  final double width, height;
  final bool hasBack;
  final Widget? discountWidget, makerLogoWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          CurvedImage(url, w: width, h: height, radius: 4,fit: BoxFit.cover,),
          if (hasBack)
            Positioned(
              top: 0,
              left: 24,
              child: SafeArea(child: MyBackButton()),
            ),
          if (discountWidget != null)
            Positioned(bottom: 12, right: 12, child: discountWidget!),
          if (makerLogoWidget != null)
            Positioned(bottom: 12, left: 12, child: makerLogoWidget!),
        ],
      ),
    );
  }
}

class RestaurantItemWidget extends StatelessWidget {
  const RestaurantItemWidget({this.restaurant, required this.width, super.key});
  final restaurant;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      color: Color(0xFFf5f5f5),
      width: width,
      height: 260,
      child: Column(
        children: [
          ProductImage(
            Assets.test1,
            width: width,
            height: 160,
            makerLogoWidget: CurvedContainer(
              color: AppColors.white,
              padding: EdgeInsets.all(6),
              child: Image.asset(Assets.test2, width: 32, height: 32,fit: BoxFit.cover,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AppText.thin(
                      "Open 6am-10pm",
                      color: AppColors.lightTextColor3,
                    ),
                    Spacer(),
                    AppIcon(Icons.star, color: AppColors.accentColor),
                    AppText.thin("4.2", color: AppColors.lightTextColor3),
                  ],
                ),
                AppText.medium(
                  "McDonald's",
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    AppIcon(Assets.time),
                    Ui.boxWidth(8),
                    AppText.thin(
                      "35-45 mins",
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.lightTextColor3,
                    ),
                    AppText.thin(
                      " | ",
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.lightTextColor2,
                    ),
                    Expanded(
                      child: AppText.thin(
                        "\$3.99 Delivery",
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.lightTextColor3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedRestaurantList extends StatelessWidget {
  const FeaturedRestaurantList(this.restaurants, {super.key});
  final List restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      itemBuilder: (c, i) {
        return RestaurantItemWidget(width: 0.67 * Ui.width(context));
      },
      separatorBuilder: (c, i) {
        return Ui.boxWidth(16);
      },
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(16),
    );
  }
}

class CategorizedRestaurantList extends StatelessWidget {
  const CategorizedRestaurantList(this.restaurants, {super.key});
  final List restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      itemBuilder: (c, i) {
        return RestaurantItemWidget(width: Ui.width(context) - 32);
      },
      separatorBuilder: (c, i) {
        return Ui.boxHeight(24);
      },
      padding: EdgeInsets.all(16),
    );
  }
}

class FeaturedRestaurantWidget extends StatelessWidget {
  const FeaturedRestaurantWidget(this.title, this.restaurants, {super.key});
  final String title;
  final List restaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: AppText.bold(title),
        ),
        SizedBox(height: 292, child: FeaturedRestaurantList(restaurants)),
      ],
    );
  }
}

class CategorizedRestaurantWidget extends StatelessWidget {
  const CategorizedRestaurantWidget(this.title, this.restaurants, {super.key});
  final String title;
  final List restaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Ui.boxWidth(16),
            AppText.bold(title),
            Ui.boxWidth(24),
            AppText.thin("(700 Results)"),
            Spacer(),
            AppText(
              "Reset",
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
            ),
            Ui.boxWidth(16),
          ],
        ),
        Expanded(child: CategorizedRestaurantList(restaurants)),
      ],
    );
  }
}
