import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/global/controller/connection_controller.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_dropdown.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../global/ui/widgets/others/containers.dart';
import '../plugin/countries_states.dart';
import '../utils/constants/countries.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.onPressed,
    this.text = "",
    this.isDisabled = false,
    super.key,
  });
  final Function? onPressed;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Ui.width(context),
        height: 86,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.black,
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 0),
              blurRadius: 50,
              spreadRadius: 3,
              color: Color(0xFFF2F2F2).withOpacity(0.1),
            ),
          ],
        ),
        child: AppButton(
          onPressed: onPressed,
          text: text,
          disabled: isDisabled,
        ),
      ),
    );
  }
}

class SettingsItemWidget extends StatelessWidget {
  SettingsItemWidget(
    this.title,
    this.desc, {
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    super.key,
  });
  final String title, desc;
  final Function()? onTap;
  final Function(bool)? onSwitchChanged;
  final bool switchValue;
  final RxBool curSwitchValue = false.obs;

  @override
  Widget build(BuildContext context) {
    curSwitchValue.value = switchValue;
    final pp = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.thin(title),
                if (desc.isNotEmpty) Ui.boxHeight(8),
                if (desc.isNotEmpty)
                  AppText.thin(
                    desc,
                    fontSize: 14,
                    color: AppColors.lightTextColor,
                  ),
              ],
            ),
          ),
          Ui.boxWidth(24),
          if (onTap != null) AppIcon(Icons.chevron_right_rounded),
          if (onSwitchChanged != null)
            Obx(() {
              return Switch(
                activeTrackColor: AppColors.primaryColor,
                inactiveTrackColor: AppColors.disabledColor,
                inactiveThumbColor: AppColors.white,
                value: curSwitchValue.value,
                onChanged: (v) {
                  curSwitchValue.value = v;
                  onSwitchChanged!(v);
                },
              );
            }),
        ],
      ),
    );
    return InkWell(onTap: onTap, child: pp);
  }
}

class CustomKeyPad extends StatelessWidget {
  const CustomKeyPad(this.tec, {this.maxPin = 6, this.onNext, super.key});
  final TextEditingController tec;
  final Function()? onNext;
  final int maxPin;
  static const List<dynamic> keypads = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    Icons.close_rounded,
    "0",
    Icons.chevron_right_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ui.boxHeight(24),
        PinCodeTextField(
          appContext: context,
          length: maxPin,
          controller: tec,
          // validator: (s) {
          //   if ((s ?? "").isEmpty) {
          //     return "error";
          //   }
          //   return null;
          // },
          cursorColor: AppColors.primaryColor,
          textStyle: TextStyle(color: AppColors.white),
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            fieldHeight: 64,
            fieldWidth: 48,
            borderWidth: 1,
            selectedColor: AppColors.primaryColor,
            shape: PinCodeFieldShape.underline,
            inactiveColor: AppColors.borderColor,
            activeColor: AppColors.borderColor,
          ),
          autoDisposeControllers: false,
        ),
        Ui.boxHeight(24),
        SizedBox(
          width: 278,
          height: 328,
          child: Wrap(
            spacing: 34,
            runSpacing: 16,
            children: List.generate(keypads.length, (i) {
              if (i == 9) {
                return CircleIcon(
                  keypads[i],
                  color: Color(0xFF404040),
                  radius: 35,
                  onTap: () {
                    if (tec.text.isEmpty) return;
                    tec.text = tec.text.substring(0, tec.text.length - 1);
                  },
                );
              }
              if (i == 11) {
                return CircleIcon(
                  keypads[i],
                  color: AppColors.primaryColor,
                  radius: 35,
                  onTap: onNext,
                );
              }
              return InkWell(
                onTap: () {
                  if (tec.text.length >= maxPin) return;
                  tec.text = tec.text + keypads[i].toString();
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFF767680).withOpacity(0.12),
                  child: Center(child: AppText.thin(keypads[i], fontSize: 24)),
                ),
              );
            }),
          ),
        ),
        Ui.boxHeight(24),
      ],
    );
  }
}

loadAsyncFunction(Function onLoad) async {
  await Get.showOverlay(
    asyncFunction: () async {
      await onLoad();
      return true;
    },
    loadingWidget: Center(
      child: SizedBox(height: 56, child: CircularProgress(56)),
    ),
  );
}

class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectionController>();
    return Obx(() {
      if (Get.find<DashboardController>().needsUpdate.value) {
        return Material(
          color: AppColors.black,
          child: Center(
            child: CurvedContainer(
              color: AppColors.containerColor,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(Icons.sync, color: AppColors.white, size: 48),
                  Ui.boxHeight(16),
                  AppText.thin(
                    "A new version of the app is available. Please update from the ${GetPlatform.isAndroid ? "Play Store" : "App Store"} to access the latest features and improvements.",
                    color: AppColors.white,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (!controller.isConnected.value) {
        return Material(
          color: AppColors.black,
          child: Center(
            child: CurvedContainer(
              color: AppColors.containerColor,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    Icons.wifi_off_rounded,
                    color: AppColors.white,
                    size: 48,
                  ),
                  Ui.boxHeight(16),
                  AppText.thin(
                    "No internet connection",
                    color: AppColors.white,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return child;
    });
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({this.size = 54, super.key});
  final double size;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),

      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        Assets.loading,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(this.title, this.desc, this.icon, {super.key});
  final String title, desc, icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(),
          UniversalImage(icon, width: 240, fit: BoxFit.cover),
          Ui.boxHeight(20),
          AppText.bold(title, fontSize: 18),
          Ui.boxHeight(4),
          AppText.thin(desc, fontSize: 16),
        ],
      ),
    );
  }
}

class TabSliderWidget extends StatelessWidget {
  TabSliderWidget(this.titles, this.children, {super.key});
  final List<String> titles;
  final List<Widget> children;
  final selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurvedContainer(
          padding: const EdgeInsets.all(16),
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(titles.length, (i) {
                  return Expanded(child: _buildTab(titles[i], i));
                }),
              ),
              CDivider(),
              
            ],
          ),
        ),
        Expanded(
            child: Container(
              color: Color(0xFFf5f5f5),
              child: Obx(() {
                return children[selectedIndex.value];
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    return Obx(() {
      final isSelected = selectedIndex.value == index;
      return GestureDetector(
        onTap: () {
          selectedIndex.value = index;
        },
        child: Column(
          children: [
            AppText(
              text,
              fontSize: 16,
              weight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.lightTextColor3,
            ),
            
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 3,
                width: 84,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.transparent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4)),
                ),
              ),
          ],
        ),
      );
    });
  }
}
