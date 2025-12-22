import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:flutter/material.dart';

class Loading {
  bool isLoading;
  bool hasError;

  Loading({this.isLoading = false, this.hasError = false});

  bool get loadedWithError => hasError && !isLoading;
}

class AddressFieldController {
  final TextEditingController tec;
  final bool hasZipCode;
  String country, state, city, street;
  String? zipCode;

  AddressFieldController(
    this.tec,
    this.hasZipCode, {
    this.country = "Nigeria",
    this.state = "",
    this.city = "",
    this.street = "",
    this.zipCode = "",
  });

  bool onSubmit() {
    if ([
      country,
      state,
      city,
      street,
      if (hasZipCode) zipCode!,
    ].any((e) => e.isEmpty)) {
      Ui.showError("All fields are mandatory");
      return false;
    }
    tec.text =
        "$street, $city, $state, ${hasZipCode ? "$zipCode," : ""} $country";
    return true;
  }
}
