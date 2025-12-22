import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/countries.dart';
import '/src/utils/utils_barrel.dart';

///file for all #resusable functions
///Guideline: strongly type all variables and functions

abstract class UtilFunctions {
  static const pideg = 180 / pi;
  static const successCodes = [
    200,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    226
  ];

  static PasswordStrength passwordStrengthChecker(String value) {
    value = value.trim();
    final bool passwordHasLetters = Regex.letterReg.hasMatch(value);
    final bool passwordHasNum = Regex.numReg.hasMatch(value);
    final bool passwordHasSpecialChar = Regex.specialCharReg.hasMatch(value);
    if (value.isEmpty) {
      return PasswordStrength.normal;
    } else if (passwordHasLetters && passwordHasNum && passwordHasSpecialChar) {
      return PasswordStrength.strong;
    } else if ((passwordHasLetters && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasLetters)) {
      return PasswordStrength.okay;
    } else if (passwordHasLetters ^ passwordHasSpecialChar ^ passwordHasNum) {
      return PasswordStrength.weak;
    } else {
      return PasswordStrength.strong;
    }
  }

  static double deg(double a) => a / pideg;

  static clearTextEditingControllers(List<TextEditingController> conts) {
    for (var i = 0; i < conts.length; i++) {
      conts[i].clear();
    }
  }

  static String moneyRange(num a, num b) {
    return "${a.toCurrency()} - ${b.toCurrency()}";
  }

  static String formatPhone(String phone) {
    switch (phone[0]) {
      case '0':
        return '+234${phone.substring(1)}';
      case '+':
        return phone;
      default:
        return '+234${phone.substring(1)}';
    }
  }

  static String formatFullName(String s) {
    return s.maxLength();
  }

  static bool nullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  static returnNullEmpty(dynamic k, dynamic v) {
    if (k is String || k is List) {
      if (k == null || k.isEmpty) {
        return v;
      }
      return k;
    }
    return k ?? v;
  }

  static bool isSuccess(int? a) {
    return successCodes.contains(a);
  }
}

class PhoneUtils {
  /// Extracts the dial code from a phone number string
  /// Returns the dial code if found, otherwise returns the default "+234" (Nigeria)
  static String extractDialCode(String phoneNumber) {
    if (phoneNumber.isEmpty) return "+234";
    
    // Trim and normalize the phone number
    final normalized = phoneNumber.trim();
    
    // Sort countries by dial code length (longest first) to match correctly
    // e.g., "+1" should match after "+1876" if both exist
    final sortedCountries = List<Map<String, String>>.from(countriesData)
      ..sort((a, b) => 
        (b['dial_code']?.length ?? 0).compareTo(a['dial_code']?.length ?? 0)
      );
    
    // Find the matching dial code
    for (var country in sortedCountries) {
      final dialCode = country['dial_code'] ?? '';
      if (normalized.startsWith(dialCode)) {
        return dialCode;
      }
    }
    
    // Default to Nigeria if no match found
    return "+234";
  }

  /// Extracts the phone number without the dial code
  static String extractPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return "";
    
    final dialCode = extractDialCode(phoneNumber);
    final normalized = phoneNumber.trim();
    
    // Remove dial code and any spaces
    final withoutCode = normalized.replaceFirst(dialCode, '').trim();
    return withoutCode;
  }

  /// Formats a phone number with dial code and phone number
  static String formatPhoneNumber(String dialCode, String phoneNumber) {
    if (dialCode.isEmpty || phoneNumber.isEmpty) return "";
    return "$dialCode ${phoneNumber.trim()}";
  }
}