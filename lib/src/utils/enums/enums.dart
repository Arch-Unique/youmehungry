import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  fullname(TextInputType.emailAddress),
  number(TextInputType.number),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 256, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.number),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum AuthMode {
  login("Log In", "Login with one following options", "Create Account"),
  register("Create Account", "You can sign up with one following options",
      "Have an Account? Login!");

  final String title, desc, afterAction;
  const AuthMode(this.title, this.desc, this.afterAction);
}

enum SuccessPagesMode {
  password("Password reset link sent",
      "Check your emails for the link sent to reset your Biko account password"),
  register("Confirm your account",
      "Check your emails for the link sent to confirm your Biko account");

  final String title, desc;
  const SuccessPagesMode(this.title, this.desc);
}

enum ThirdPartyTypes {
  facebook(Brands.facebook_2),
  google(Brands.google),
  apple(Brands.apple_logo);

  final String logo;
  const ThirdPartyTypes(this.logo);
}

enum DashboardMode {
  home("Home", Icons.home),
  wallet("Cart", Iconsax.shopping_cart_outline),
  cityguide("Orders", Iconsax.shopping_bag_outline),
  profile("Account", Iconsax.profile_add_outline);

  final String title;
  final dynamic icon;
  const DashboardMode(this.title, this.icon);
}

// enum HomeCategory {
//   esim("eSim Services", Assets.c1),
//   wheretostay("Where To Stay", Assets.c2),
//   concierge("Concierge", Assets.c3),
//   toeat("To Eat", Assets.c4),
//   shopping("Shopping", Assets.c5),
//   events("Events", "Assets.c5");

//   final String title, icon;
//   const HomeCategory(this.title, this.icon);
// }

enum ProfileActions {
  editprofile("Edit Profile", Iconsax.edit_outline),
  account("Account Limits", Iconsax.arrow_swap_outline),
  wallet("Wallet Settings", Iconsax.setting_3_outline),
  biometrics("Biometrics", Iconsax.finger_scan_outline),
  notification("Notifications Settings", Iconsax.notification_outline),
  favourites("Favourites", Icons.favorite_outline),
  bookings("Detty Events", Icons.book_online),
  privacy("Privacy Policy", Icons.newspaper_outlined,isUser: false),
  rating("Rate the App", Icons.star_outline_rounded),
  tandc("Terms and Conditions", Icons.newspaper_outlined,isUser: false),
  delete("Delete Account", Iconsax.trash_outline);

  final String title;
  final dynamic icon;
  final bool isUser;
  const ProfileActions(this.title, this.icon, {this.isUser = true});
}

enum CardColors {
  card1(Color(0xFF202325)),
  card2(Color(0xFF012c4a)),
  card3(Color(0xFFE0F8E7)),
  card4(Color(0xFFE0F8E7)),
  card5(Color(0XFFD4FCFF));

  final Color color;
  const CardColors(this.color);
}

enum FixedAccts {
  usd("USD", Flags.united_states_of_america, "Biko for Mums", "Wema Bank",
      "0123456789"),
  ngn("NGN", Flags.nigeria, "Biko for Mums", "Wema Bank", "0123456789");

  final String name, bankName, bank, bankAcct, flag;
  const FixedAccts(
      this.name, this.flag, this.bankName, this.bank, this.bankAcct);
}

enum CurrencyIcon {
  usd(FontAwesome.dollar_sign_solid),
  ngn(FontAwesome.naira_sign_solid),
  gbp(FontAwesome.sterling_sign_solid),
  eur(FontAwesome.euro_sign_solid),
  jpy(FontAwesome.yen_sign_solid),
  inr(FontAwesome.indian_rupee_sign_solid);

  final FontAwesomeIconData icon;
  const CurrencyIcon(this.icon);
}

enum ErrorTypes {
  noInternet(Icons.wifi_tethering_off_rounded, "No Internet Connection",
      "Please check your internet connection and try again"),

  noPatient(Icons.pregnant_woman_rounded, "No Patient Found",
      "Oops. no patients found. Please contact support for help"),
  noDonation(Iconsax.empty_wallet_outline, "No Donation Found",
      "You haven't made any donations yet. Why not make a difference today? "),
  serverFailure(Icons.power_off_rounded, "Server Failure",
      "Something bad happened. Please try again later");

  final String title, desc;
  final dynamic icon;
  const ErrorTypes(this.icon, this.title, this.desc);
}

