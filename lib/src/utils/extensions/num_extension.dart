part of 'extensions.dart';

extension NumExtension on num {
  ///returns value * (percentage/100)
  double percent(num percentage) => (this * (percentage / 100)).toDouble();

  double get negate => this * -1;

  String toCurrency() {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return "\$${myFormat.format(this)}";
    // ₦
  }

  String toCurrencyWS() {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return myFormat.format(this);
    // ₦
  }

}
