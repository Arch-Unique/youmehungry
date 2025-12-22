import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar(
    {String? title,
    Widget? titleWidget,
    Color color = AppColors.textColor,
    bool hasBack = true,
    List<Widget>? trailing}) {
  return AppBar(
      toolbarHeight: 72,
      backgroundColor: AppColors.transparent,
      title: title == null
          ? titleWidget
          : AppText.medium(title, fontSize: 18, color: color),
      elevation: 0,
      // shadowColor: Color(0xFFE80976).withOpacity(0.05),
      bottom: PreferredSize(preferredSize: Size(Ui.width(Get.context!), 1), child: Builder(
        builder: (context) {
          return CDivider();
        }
      )),
      forceMaterialTransparency: true,
      actions: trailing ?? [],
      leadingWidth: hasBack ? 56 : 28,
      leading: hasBack
          ? Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: 
            CircleIcon(Icons.arrow_back_ios_rounded,onTap: (){Get.back();},iconColor: AppColors.primaryColor,color: Color(0xFFE5F2FF).withOpacity(0.1),)
            // CircleAvatar(
            //   backgroundColor: Color(0xFFE5F2FF).withOpacity(0.1),
            //   radius: 20,
            //   child: Center(
            //     child: Builder(builder: (context) {
            //         return IconButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             icon: Icon(
            //               Icons.arrow_back_ios_rounded,
            //               color: AppColors.primaryColor,
            //             ));
            //       }),
            //   ),
            // ),
          )
          : SizedBox());
}

class CDivider extends StatelessWidget {
  const CDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ui.width(context),
      height: 1,
      color: AppColors.textBorderColor,
    );
  }
}
