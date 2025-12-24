import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

class AppButton extends StatefulWidget {
  final Function? onPressed;
  final Widget? child;
  final String? text, icon;
  final bool? disabled;
  final double v;
  final Color color, borderColor, textColor;
  final bool isCircle, isWide, hasBorder;

  const AppButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.disabled,
    this.isWide = true,
    this.isCircle = false,
    this.borderColor = AppColors.white,
    this.hasBorder = false,
    this.v = 16,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.white,
    super.key,
  });

  @override
  State<AppButton> createState() => _AppButtonState();

  static social(
    Function? onPressed,
    String icon,
  ) {
    return AppButton(
      onPressed: onPressed,
      icon: icon,
      color: AppColors.white,
      isCircle: true,
    );
  }

  static half(
    Function? onPressed,
    String title,
  ) {
    return AppButton(
      onPressed: onPressed,
      text: title,
      isWide: false,
    );
  }

  static white(
    Function? onPressed,
    String title,
    Widget? child
  ) {
    return AppButton(
      onPressed: onPressed,
      color: AppColors.white,
      text: title,
      hasBorder: false,
      child: child,
    );
  }

  static outline(Function? onPressed, String title,
      {Color color = AppColors.white,double v=16,Widget? child}) {
    return AppButton(
      onPressed: onPressed,
      hasBorder: true,
      text: title,
      color: AppColors.transparent,
      borderColor: color,
      v: v,
      child: child,
    );
  }
}

class _AppButtonState extends State<AppButton> {
  bool disabled = false;
  bool isPressed = false;

  @override
  void initState() {
    disabled = widget.disabled ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    disabled = widget.disabled ?? false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: disabled ? Colors.grey[400] : widget.color,
      elevation: 0,
      shape: widget.isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: Ui.circularRadius(4),
              side: widget.hasBorder
                  ? BorderSide(color: widget.borderColor)
                  : BorderSide.none,
            ),
      onPressed: (disabled || widget.onPressed == null)
          ? null
          : () async {
              setState(() {
                disabled = true;
                isPressed = true;
              });
              await widget.onPressed!();
              setState(() {
                disabled = false;
                isPressed = false;
              });
            },
      child: widget.isCircle
          ? Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: disabled
                      ? const LoadingIndicator()
                      : Image.asset(widget.icon!)),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                vertical: widget.v,
              ),
              width: widget.isWide
                  ? double.maxFinite
                  : (Ui.width(context) / 2) - 36,
              child: Center(
                child: !isPressed
                    ? widget.child ??
                        AppText.button(
                          widget.text!,
                          alignment: TextAlign.center,
                          color: widget.hasBorder
                              ? widget.borderColor
                              : widget.color == AppColors.white
                                  ? AppColors.primaryColor
                                  : widget.textColor,
                        )
                    : const LoadingIndicator(),
              )),
    );
  }
}
