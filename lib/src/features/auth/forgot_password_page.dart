import 'package:youmehungry/src/features/auth/auth_page.dart';
import 'package:youmehungry/src/features/auth/controllers/auth_controller.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/ui/ui_barrel.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Forgot Password",
      child: Ui.padding(
        child: Form(
          key: controller.fpKey,
          child: Column(
            children: [
              CustomTextField("Email", controller.tecs[1], label: "Email"),
              const Spacer(),
              AppButton(
                onPressed: () async {
                  await controller.onFPPressed();
                },
                text: "Send Password Reset Link",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordSuccess extends StatelessWidget {
  const ForgotPasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Forgot Password",
      child: Ui.padding(
        child: Column(
          children: [
            const Spacer(),
            AppIcon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 120,
            ),
            AppText.bold(
              "Password Reset Link Sent",
              fontSize: 20,
              alignment: TextAlign.center,
            ),
            AppText.thin(
              "A password reset link has been sent to your email. Click the link to reset your password",
              color: AppColors.lightTextColor,
              alignment: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              onPressed: () {
                Get.offAll(AuthScreen(isLogin: true));
              },
              text: "Login",
            ),
          ],
        ),
      ),
    );
  }
}

class VerifiedSuccess extends StatelessWidget {
  const VerifiedSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Forgot Password",
      child: Ui.padding(
        child: Column(
          children: [
            const Spacer(),
            AppIcon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 120,
            ),
            AppText.bold(
              "Account verification link sent",
              fontSize: 20,
              alignment: TextAlign.center,
            ),
            AppText.thin(
              "A verification link has been sent to your email. Click the link to verify your account",
              color: AppColors.lightTextColor,
              alignment: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              onPressed: () {
                Get.offAll(AuthScreen(isLogin: true));
              },
              text: "Login",
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final controller = AuthController();

  @override
  Widget build(BuildContext context) {
    RxString oldPass = "".obs;
    controller.tecs[3].addListener(() {
      oldPass.value = controller.tecs[3].text;
    });
    return SinglePageScaffold(
      title: "Reset Password",
      child: Ui.padding(
        child: Form(
          key: controller.rpKey,
          child: Column(
            children: [
              CustomTextField.password(
                "",
                controller.tecs[3],
                label: "New Password",
              ),
              Obx(
                () => CustomTextField.password(
                  "",
                  controller.tecs[4],
                  label: "Confirm Password",
                  oldPass: oldPass.value,
                ),
              ),
              const Spacer(),
              AppButton(
                onPressed: () async {
                  await controller.onRPPressed();
                },
                text: "Reset Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
