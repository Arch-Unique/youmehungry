import 'package:youmehungry/src/features/auth/repository/auth_repo.dart';
import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<AuthMode> authMode = AuthMode.register.obs;
  bool get isRegister => authMode.value == AuthMode.register;
  String userPhone = "";
  final authRepo = Get.find<AuthRepo>();
  final dbController = Get.find<DashboardController>();

  Future<bool> onSignUp(String phone, String email) async {
    try {
      // await authRepo.register(phone,email);
      userPhone = phone;
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

    Future<bool> onLogin(String phone) async {
    try {
      // await authRepo.register(phone,email);
      userPhone = phone;
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  Future<bool> onOTPVerification(String code) async {
    try {
      // await authRepo.verifyOTP(phone,email);
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  Future<bool> onFillProfile(
    String surname,
    String othernames,
    String gender,
    String dob,
    String country,
  ) async {
    try {
      // await authRepo.onFillProfile();
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  Future<bool> onAddAddress(
    String address,
    String aptsuite,
    String city,
    String state,
    String crossstreet,
    String phone,
    String zipcode,
    String notes,
    String label,
  ) async {
    try {
      // await authRepo.onFillProfile();
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  onSocialPressed(ThirdPartyTypes tpt) async {
    try {
      await authRepo.loginSocial(tpt);
      dbController.initApp();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Ui.showError(e.toString());
    }
  }
}
