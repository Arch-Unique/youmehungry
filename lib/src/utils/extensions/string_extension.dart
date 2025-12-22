part of 'extensions.dart';

extension StringExtension on String {
  String maxLength([int a = 16]) {
    return length > a ? "${substring(0, a - 3)}..." : this;
  }
}

extension DateExtension on DateTime {
  String toSQLDate() {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(this);
  }
}