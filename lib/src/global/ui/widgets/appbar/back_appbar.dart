import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar({
  String? title,
  Widget? titleWidget,
  Color color = AppColors.white,
  bool hasBack = true,
  bool ct = false,
  List<Widget>? trailing,
}) {
  return AppBar(
    toolbarHeight: 72,
    backgroundColor: AppColors.primaryColor,
    title: title == null
        ? titleWidget
        : AppText.medium(title, fontSize: 24, color: color),
    elevation: 0,
    // shadowColor: Color(0xFFE80976).withOpacity(0.05),
    // bottom: PreferredSize(
    //   preferredSize: Size(Ui.width(Get.context!), 1),
    //   child: Builder(
    //     builder: (context) {
    //       return CDivider();
    //     },
    //   ),
    // ),
   
    centerTitle: ct,
    // forceMaterialTransparency: true,
    actions: trailing ?? [],
    leadingWidth: hasBack ? 56 : 28,
    leading: hasBack
        ? MyBackButton()
        : SizedBox(),
  );
}

class CDivider extends StatelessWidget {
  const CDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ui.width(context),
      height: 1,
      color: AppColors.borderColor,
    );
  }
}

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleIcon(
              Icons.arrow_back,
              onTap: () {
                Get.back();
              },
              iconColor: AppColors.accentColor,
              color: AppColors.transparent
              ,
            ),
          );
  }
}