import 'package:youmehungry/src/features/dashboard/models/dashboard_repo.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../global/services/barrel.dart';

class AuthRepo extends GetxController {
  final apiService = Get.find<DioApiService>();
  final prefService = Get.find<MyPrefService>();
  final appService = Get.find<AppService>();
  final dbRepo = Get.find<DashboardRepo>();

  login(String email, String password) async {
    final res = await apiService.post(
      AppUrls.login,
      data: {"email": email, "password": password},
      hasToken: false,
    );
    if (res.statusCode!.isSuccess()) {
      await appService.loginUser(
        res.data["data"]["jwt"],
        res.data["data"]["refresh"],
      );
    } else {
      if (res.data == null) {
        throw "An error occured, please try again later";
      }
      throw res.data["error"];
    }
  }

  loginSocial(ThirdPartyTypes tpt) async {
    String token = "";
    switch (tpt) {
      case ThirdPartyTypes.apple:
        token = await _loginWithApple();
        break;
      case ThirdPartyTypes.google:
        token = await _loginWithGoogle();
        break;
      case ThirdPartyTypes.facebook:
        token = await _loginWithFacebook();
        break;
      default:
    }

    final res = await apiService.post(
      AppUrls.loginSocial,
      data: {"idToken": token},
      hasToken: false,
    );
    if (res.statusCode!.isSuccess()) {
      await appService.loginUser(
        res.data["data"]["jwt"],
        res.data["data"]["refresh"],
      );
    } else {
      if (res.data == null) {
        throw "An error occured, please try again later";
      }
      throw res.data["error"];
    }
  }

  register(
    String fullname,
    String email,
    String password,
    String phone,

    String address,
    String dob,
    String country,
  ) async {
    final res = await apiService.post(
      AppUrls.register,
      data: {
        "fullname": fullname,
        "email": email,
        "password": password,
        "phone": phone.replaceAll(" ", ""),
        "address": address,
        "country": country,
        "dob": dob,
      },
      hasToken: false,
    );
    if (res.statusCode!.isSuccess()) {
      // await appService.loginUser(
      //     res.data["data"]["jwt"], res.data["data"]["refresh"]);
      // dbRepo.registerUserBiometrics().then((_) {
      //   print("saved ub");
      // });
    } else {
      if (res.data == null) {
        throw "An error occured, please try again later";
      }
      throw res.data["error"];
    }
  }

  Future<String> forgotPassword(String email) async {
    final res = await apiService.post(
      AppUrls.forgotPassword,
      data: {"email": email},
      hasToken: false,
    );
    if (res.statusCode!.isSuccess()) {
      return "success";
    }
    return "";
  }

  Future<String> _loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate(scopeHint: ['profile', 'email']);

    final credential = GoogleAuthProvider.credential(
      // accessToken: googleUser.,
      idToken: googleUser?.authentication.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    final token = await user.user?.getIdToken();
    return token ?? "";
  }

  Future<String> _loginWithApple() async {
    final appleProvider = AppleAuthProvider();
    final user = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    final token = await user.user?.getIdToken();
    return token ?? "";
  }

  Future<String> _loginWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    final user = await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    );
    final token = await user.user?.getIdToken();
    return token ?? "";
  }
}
