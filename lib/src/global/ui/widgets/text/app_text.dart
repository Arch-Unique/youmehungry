import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';

///This is the general widget for text in this app
///use this rather than the flutter provided text widget
///
/// static methods are provided for fontWeights
/// eg. AppText.semiBoldItalic(
///       "my text",
///       fontSize: 20,
///      )...
///   for -> fontWeight = 600
///          fontSize = 20
///          fontStyle = italic
///
/// if there are font weight that are not provided here
/// feel free to add a  method for it.
/// happy coding :)
///
class AppText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final double? fontSize;
  final FontStyle? style;
  final String? fontFamily;
  final Color? color;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final int? maxlines;

  ///fontSize = 14
  const AppText(
    this.text, {
    super.key,
    this.weight = FontWeight.w600,
    this.fontSize,
    this.style = FontStyle.normal,
    this.color,
    this.fontFamily,
    this.alignment = TextAlign.start,
    this.overflow,
    this.maxlines,
    this.decoration,
  });

  ///fontSize: 15
  ///weight: w700
  static AppText bold(
    String text, {
    Color? color,
    String? fontFamily,
    int? maxLines,
    TextAlign? alignment,
    double? fontSize = 16,
  }) =>
      AppText(
        text,
        weight: FontWeight.w700,
        fontFamily: fontFamily,
        color: color,
        maxlines: maxLines,
        alignment: alignment,
        fontSize: fontSize,
      );

  ///fontSize: 15
  ///weight: w300
  static AppText thin(
    String text, {
    Color? color,
    String? fontFamily,
    TextAlign? alignment,
    int? maxLines,
    TextOverflow overflow = TextOverflow.visible,
    double? fontSize = 16,
  }) =>
      AppText(
        text,
        weight: FontWeight.w400,
        color: color,
        alignment: alignment,
        fontFamily: fontFamily,
        fontSize: fontSize,
        maxlines: maxLines,
        overflow: overflow,
      );

  ///weight: w600
  static AppText medium(
    String text, {
    Color? color,
    String? fontFamily,
    double fontSize = 16,
    int? maxLines,
    TextAlign? alignment,
    TextOverflow overflow = TextOverflow.visible,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w600,
        overflow: overflow,
        alignment: alignment,
        fontFamily: fontFamily,
        maxlines: maxLines,
        color: color,
      );

  ///weight: w300
  ///fontSize: 16
  ///color: #FFFFFF
  static AppText button(
    String text, {
    Color color = AppColors.white,
    double fontSize = 14,
    TextAlign? alignment,
    int? maxLines,
    TextDecoration? decoration,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w600,
        decoration: decoration,
        alignment: alignment,
        maxlines: maxLines,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      // softWrap: false,

      style: TextStyle(
          decoration: decoration,
          fontSize: fontSize ?? 14,
          color: color ?? AppColors.textColor,
          fontWeight: weight,
          overflow: overflow ?? TextOverflow.ellipsis,
          
          fontStyle: style,
          fontFamily: fontFamily,
          height: 1.25),
      textAlign: alignment,
    );
  }
}
