import 'dart:typed_data';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:youmehungry/src/features/auth/controllers/auth_controller.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:youmehungry/src/utils/constants/countries.dart';

import '../../global/ui/widgets/fields/custom_dropdown.dart';
import '../../src_barrel.dart';
import '../dashboard/controllers/dashboard_controller.dart';
import '../dashboard/explorer_page.dart';

final divd = Container(height: 1, color: AppColors.borderColor);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final wt = AppText.thin("text", color: AppColors.lightTextColor);
    final ot = AppText.bold(
      "text",
      fontSize: 14,
      color: AppColors.primaryColor,
    );
    return ConnectivityWidget(
      child: Scaffold(
        appBar: backAppBar(
          titleWidget: UniversalImage(Assets.fulllogo, height: 40),
          ct: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              UniversalImage(Assets.auth, height: 200),
              Ui.boxHeight(16),
              AppText.bold("Let's Get You In", fontSize: 24),
              Ui.boxHeight(16),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return CurvedContainer(
                    onPressed: () async {},
                    width: Ui.width(context) - 32,
                    height: 48,
                    border: Border.all(color: AppColors.borderColor),
                    color: AppColors.transparent,
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Brand(ThirdPartyTypes.values[i].logo),
                          Ui.boxWidth(16),
                          AppText.thin(
                            "Continue with ${ThirdPartyTypes.values[i].name.capitalize!}",
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Ui.boxHeight(8),
              Row(
                children: [
                  Expanded(child: divd),
                  AppText.thin("  or  ", color: AppColors.lightTextColor),
                  Expanded(child: divd),
                ],
              ),
              Ui.boxHeight(24),
              AppButton(
                onPressed: () async {
                  Get.to(CreateNewAccountScreen());
                },
                text: "Sign Up",
              ),
              Ui.boxHeight(16),
              AppButton(
                onPressed: () async {
                  Get.find<DashboardController>().initApp();
                  Get.offAll(ExplorerScreen());
                },
                text: "Continue as Guest",
                color: AppColors.accentColor,
                textColor: AppColors.primaryColor,
              ),
              Ui.boxHeight(16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: wt.style,
                        fontSize: wt.fontSize,
                        color: wt.color,
                      ),
                    ),
                    TextSpan(
                      text: "Sign In",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Get.to(LoginScreen());
                        },
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: ot.style,
                        fontSize: ot.fontSize,
                        color: ot.color,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButtonsIconWidget extends StatelessWidget {
  const SocialButtonsIconWidget({
    this.onTap,
    this.isRegister = true,
    super.key,
  });
  final Function(ThirdPartyTypes)? onTap;
  final bool isRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: divd),
            AppText.thin("    or continue with    "),
            Expanded(child: divd),
          ],
        ),
        Ui.boxHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            return CurvedContainer(
              onPressed: () async {
                await onTap!(ThirdPartyTypes.values[i]);
              },
              border: Border.all(color: AppColors.accentColor),
              color: AppColors.transparent,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Brand(ThirdPartyTypes.values[i].logo),
            );
          }),
        ),
      ],
    );
  }
}

class CreateNewAccountScreen extends StatelessWidget {
  CreateNewAccountScreen({super.key});
  final controller = Get.find<AuthController>();
  final authKey = GlobalKey<FormState>();
  final tecs = List.generate(2, (i) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final wt = AppText.thin("text", color: AppColors.lightTextColor);
    final ot = AppText.bold(
      "text",
      fontSize: 14,
      color: AppColors.primaryColor,
    );
    controller.authMode.value = AuthMode.register;
    return SinglePageScaffold(
      title: "Create New Account",
      safeArea: true,
      child: Ui.padding(
        child: Form(
          key: authKey,
          child: Column(
            children: [
              Ui.boxHeight(8),
              PhoneTextField(
                "+1 (201) 333-4210",
                tecs[0],
                "Phone number",
                ct: countriesData,
                code: "+1",
              ),
              CustomTextField(
                "Email",
                tecs[1],
                label: "Email",
                varl: FPL.email,
                suffix: Icons.mail_outline_rounded,
              ),
              Spacer(),
              AppButton(
                onPressed: () async {
                  if (authKey.currentState!.validate()) {
                    final f = await controller.onSignUp(
                      tecs[0].text,
                      tecs[1].text,
                    );
                    if (f) {
                      Get.to(OTPCodeVerificationScreen());
                    }
                  }
                },
                text: "Sign Up",
              ),
              Ui.boxHeight(24),
              SocialButtonsIconWidget(
                onTap: (tp) async {
                  
                },
              ),
              Ui.boxHeight(24),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: wt.style,
                        fontSize: wt.fontSize,
                        color: wt.color,
                      ),
                    ),
                    TextSpan(
                      text: "Sign In",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Get.to(LoginScreen());
                        },
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: ot.style,
                        fontSize: ot.fontSize,
                        color: ot.color,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPCodeVerificationScreen extends StatelessWidget {
  OTPCodeVerificationScreen({super.key});
  final controller = Get.find<AuthController>();
  final tec = TextEditingController();
  final isTimerFinished = false.obs;

  @override
  Widget build(BuildContext context) {
    final wt = AppText.thin("text", fontSize: 18);
    final ot = AppText.bold(
      "text",
      fontSize: 18,
      color: AppColors.primaryColor,
    );
    return SinglePageScaffold(
      title: "OTP Code Verification",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Ui.boxHeight(8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Code has been sent to ",
                    style: TextStyle(
                      fontFamily: Assets.appFontFamily,
                      fontStyle: wt.style,
                      fontSize: wt.fontSize,
                      color: wt.color,
                    ),
                  ),
                  TextSpan(
                    text: controller.userPhone,

                    style: TextStyle(
                      fontFamily: Assets.appFontFamily,
                      fontStyle: ot.style,
                      fontSize: ot.fontSize,
                      color: ot.color,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Ui.boxHeight(48),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: tec,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(4),
                fieldHeight: 56,
                fieldWidth: 76,
                activeFillColor: Colors.white,
                inactiveColor: AppColors.borderColor,
              ),
            ),
            Ui.boxHeight(48),
            Obx(
               () {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(!isTimerFinished.value)
                    AppText.thin("Resend code in ",fontSize: 18),
                    
                    if(isTimerFinished.value)
                    AppText.thin("Resend code",fontSize: 18),
                    if(!isTimerFinished.value)
                    TimerText(durationInMinutes: 1, onTimerFinished: (){
                isTimerFinished.value = true;
                    })
                  ],
                );
              }
            ),
            
            Ui.boxHeight(48),
            AppButton(
              onPressed: () async {
                if (tec.text.trim().isNotEmpty && tec.text.length == 4) {
                  final f = await controller.onOTPVerification(tec.text);
                  if (f) {
                    if (controller.authMode.value == AuthMode.login) {
                      Get.find<DashboardController>().initApp();
                      Get.offAll(ExplorerScreen());
                    } else {
                      Get.to(FillProfileScreen());
                    }
                  }
                } else {
                  Ui.showError(
                    "Code cannot be empty and must be 4 characters long",
                  );
                }
              },
              text: "Verify",
            ),
          ],
        ),
      ),
    );
  }
}

class FillProfileScreen extends StatelessWidget {
  FillProfileScreen({super.key});
  final controller = AuthController();
  final authKey = GlobalKey<FormState>();
  final tecs = List.generate(6, (i) => TextEditingController());
  final Rx<Uint8List> img = Uint8List(0).obs;

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Fill Your Profile",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: authKey,
          child: Column(
            children: [
              Ui.boxHeight(8),
              CircleAvatar(
                radius: 45,
                child: Obx(() {
                  return img.value.isEmpty
                      ? SizedBox()
                      : ClipOval(
                        
                        child: Image.memory(img.value));
                }),
              ),
              Ui.boxHeight(8),
              InkWell(
                onTap: () async {
                      img.value = await Get.bottomSheet(ChooseCam());
                    },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.thin("Change Profile Picture", fontSize: 14),
                    Ui.boxWidth(24),
                    AppIcon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.accentColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
 Ui.boxHeight(24),
              CustomTextField(
                "Surname",
                tecs[0],
                label: "Surname",
                varl: FPL.text,
              ),
              CustomTextField(
                "Other names",
                tecs[1],
                label: "Other names",
                varl: FPL.text,
              ),
              CustomDropdown.city(
                hint: "Gender",
                selectedValue: "Male",
                onChanged: (v) {
                  tecs[2].text = v!;
                },
                cities: ["Male", "Female"],
                label: "Gender",
              ),
              CustomTextField(
                "Date of Birth",
                tecs[3],
                label: "Date of Birth",
                varl: FPL.text,
                suffix: Iconsax.calendar_1_outline,
                onTap: () async {
                  final dt = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1925),
                    lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                  );
                  if (dt != null) {
                    tecs[3].text = DateFormat("dd/MM/yyyy").format(dt);
                  }
                },
              ),
              CustomDropdown.country(
                hint: "Country",
                selectedValue: "Nigeria",
                onChanged: (v) {
                  tecs[4].text = v!;
                },
                label: "Country",
              ),
              AppButton(
                onPressed: () async {
                  if (authKey.currentState!.validate()) {
                    final f = await controller.onFillProfile(
                      tecs[0].text,
                      tecs[1].text,
                      tecs[2].text,
                      tecs[3].text,
                      tecs[4].text,
                    );
                    if (f) {
                      Get.to(SetLocationScreen());
                    }
                  }
                },
                text: "Continue",
              ),
              Ui.boxHeight(16),
              AppButton(
                onPressed: () {
                  Get.to(SetLocationScreen());
                },
                text: "Skip",
                color: AppColors.accentColor,
                textColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetLocationScreen extends StatelessWidget {
  SetLocationScreen({super.key});
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Set Your Location",
      child: Column(
        children: [
          //Google Maps,
          CurvedContainer(
            radius: 0,
            color: AppColors.white,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ui.padding(
                  child: AppText.bold("Location", fontSize: 18),
                  padding: 24,
                ),
                AppDivider(),
                Row(
                  children: [
                    Ui.boxWidth(24),
                    Expanded(child: AppText.thin("Add Location")),
                    Ui.boxWidth(8),
                    AppIcon(Iconsax.location_bold),
                    Ui.boxWidth(24),
                  ],
                ),
                AppDivider(),
                Ui.boxHeight(24),
                Ui.padding(
                  child: AppButton(
                    onPressed: () {
                      showSuccessDialog(
                        "Congratulations!",
                        "Your account is ready to use. You will be redirected to the Home page in a few seconds.",
                      );
                    },
                    text: "Continue",
                  ),
                  padding: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final controller = Get.put(AuthController());
  final tec = TextEditingController();
  final authKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final wt = AppText.thin("text", color: AppColors.lightTextColor);
    final ot = AppText.bold(
      "text",
      fontSize: 14,
      color: AppColors.primaryColor,
    );
    controller.authMode.value = AuthMode.login;
    return SinglePageScaffold(
      title: "Login to Your Account",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: authKey,
          child: Column(
            children: [
              Ui.boxHeight(8),
              PhoneTextField(
                "+1 (201) 333-4210",
                tec,
                "Phone number",
                ct: countriesData,
                code: "+1",
              ),
          
              AppButton(
                onPressed: () async {
                  if (authKey.currentState!.validate()) {
                    final f = await controller.onLogin(
                      tec.text,
                    );
                    if (f) {
                      Get.to(OTPCodeVerificationScreen());
                    }
                  }
                },
                text: "Sign In",
              ),
              Ui.boxHeight(24),
              SocialButtonsIconWidget(
                onTap: (tp) async {
                  //TODO: implement third party auth
                },
                isRegister: false,
              ),
              Ui.boxHeight(24),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: wt.style,
                        fontSize: wt.fontSize,
                        color: wt.color,
                      ),
                    ),
                    TextSpan(
                      text: "Sign Up",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Get.off(CreateNewAccountScreen());
                        },
                      style: TextStyle(
                        fontFamily: Assets.appFontFamily,
                        fontStyle: ot.style,
                        fontSize: ot.fontSize,
                        color: ot.color,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showSuccessDialog(String title, String message, {bool isLoading = true}) {
  Get.dialog(
    AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Ui.boxHeight(36),
          Image.asset(Assets.success, width: 100),
          AppText.bold(title),
          Ui.boxHeight(16),
          AppText.thin(message),
          Ui.boxHeight(16),
          if (isLoading) LoadingWidget(),
        ],
      ),
      actions: [
        AppButton(
          onPressed: () {
            Get.back();
          },
          text: "OK",
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
