import 'package:youmehungry/src/features/auth/controllers/auth_controller.dart';
import 'package:youmehungry/src/features/auth/forgot_password_page.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/model/loading.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:youmehungry/src/utils/constants/countries.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/ui/widgets/fields/custom_dropdown.dart';
import '../../src_barrel.dart';
import '../dashboard/controllers/dashboard_controller.dart';
import '../dashboard/explorer_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({this.isLogin = false, super.key});
  final bool isLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = AuthController();

  @override
  void initState() {
    if (widget.isLogin) {
      controller.authMode.value = AuthMode.login;
    }
    Get.find<DashboardController>().initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wt = AppText.thin("text", color: AppColors.lightTextColor);
    final ot = AppText.thin("text", color: AppColors.accentColor);
    return ConnectivityWidget(
      child: Obx(() {
        return SinglePageScaffold(
          title: controller.authMode.value.title,
          safeArea: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: controller.authKey,
              child: Column(
                children: [
                  if (controller.isRegister)
                    CustomTextField(
                      "John Doe",
                      controller.tecs[0],
                      label: "Full Name",
                      varl: FPL.fullname,
                      readOnly: true,
                      onTap: () {
                        Get.bottomSheet(
                          FullNameWidget(controller.tecs[0]),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  CustomTextField(
                    "johndoe@gmail.com",
                    controller.tecs[1],
                    label: "Email",
                    varl: FPL.email,
                  ),
                  if (controller.isRegister)
                    PhoneTextField(
                      "+2347012345678",
                      controller.tecs[3],
                      "Phone",
                      ct: countriesData,
                    ),

                  if (controller.isRegister)
                    CustomTextField(
                      "YYYY-MM-DD",
                      controller.tecs[6],
                      label: "Date Of Birth",
                      readOnly: true,
                      onTap: () async {
                        final dt = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1925),
                          lastDate: DateTime.now().subtract(
                            Duration(days: 365 * 18),
                          ),
                        );
                        if (dt != null) {
                          controller.tecs[6].text = DateFormat(
                            "yyyy-MM-dd",
                          ).format(dt);
                        }
                      },
                    ),
                  if (controller.isRegister)
                    CustomTextField(
                      "John Doe Street",
                      controller.afcController.tec,
                      readOnly: true,
                      label: "Address",
                      onTap: () {
                        Get.bottomSheet(
                          AddressFieldWidget(controller.afcController),
                          isScrollControlled: true,
                        );
                      },
                    ),

                  //  Obx(
                  //     () {
                  //       if(Get.find<DashboardController>().allAvailableCountries.isEmpty){
                  //         return AppText.thin("Loading countries...");
                  //       }
                  //      return PhoneTextField(
                  //       "+2347012345678",
                  //       controller.tecs[3],
                  //        "Phone",
                  //        ct: Get.find<DashboardController>().allAvailableCountries.value,
                  //                        );
                  //    }
                  //  ),
                  CustomTextField.password(
                    "* * * * * * * *",
                    controller.tecs[2],
                    label: "Password",
                    hbp: controller.isRegister,
                  ),
                  if (!controller.isRegister)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgotPasswordScreen());
                        },
                        child: Ui.padding(
                          child: AppText.thin("Forgot Password"),
                        ),
                      ),
                    ),
                  if (controller.isRegister)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "By clicking “Create Account” you agree to the ",
                            style: TextStyle(
                              fontFamily: Assets.appFontFamily,
                              fontStyle: wt.style,
                              fontSize: wt.fontSize,
                              color: wt.color,
                            ),
                          ),
                          TextSpan(
                            text: "Terms of Use ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(
                                  Uri.parse("https://detty.io/terms"),
                                );
                              },
                            style: TextStyle(
                              fontFamily: Assets.appFontFamily,
                              fontStyle: ot.style,
                              fontSize: ot.fontSize,
                              color: ot.color,
                            ),
                          ),
                          TextSpan(
                            text: "and ",
                            style: TextStyle(
                              fontFamily: Assets.appFontFamily,
                              fontStyle: wt.style,
                              color: wt.color,
                              fontSize: wt.fontSize,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(
                                  Uri.parse("https://detty.io/privacy-policy"),
                                );
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
                  actionButtons(),
                  // socialButtons(),
                  Ui.boxHeight(24),
                  GestureDetector(
                    onTap: () async {
                      Get.find<DashboardController>().initApp();
                      Get.offAll(ExplorerScreen());
                    },
                    child: Ui.padding(
                      padding: 12,
                      child: AppText.medium("Continue as Guest", fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  actionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: Ui.width(context) - 32, height: 40),
        AppButton(
          onPressed: () async {
            await controller.onAuthPressed();
          },
          text: controller.authMode.value.title,
        ),
        Ui.boxHeight(4),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: InkWell(
            onTap: () {
              controller.authMode.value = controller.isRegister
                  ? AuthMode.login
                  : AuthMode.register;
            },
            child: Ui.padding(
              child: AppText.thin(controller.authMode.value.afterAction),
            ),
          ),
        ),
        Ui.boxHeight(4),
      ],
    );
  }

  socialButtons() {
    final divd = Container(height: 1, color: AppColors.textBorderColor);
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
          children: List.generate(1, (i) {
            return CurvedContainer(
              onPressed: () async {
                await controller.onSocialPressed(ThirdPartyTypes.google);
              },
              border: Border.all(color: AppColors.textBorderColor),
              color: AppColors.transparent,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: Brand(ThirdPartyTypes.google.logo),
            );
          }),
        ),
      ],
    );
  }
}

class WebAuthPage extends StatefulWidget {
  const WebAuthPage({super.key});

  @override
  State<WebAuthPage> createState() => _WebAuthPageState();
}

class _WebAuthPageState extends State<WebAuthPage> {
  final controller = AuthController();

  @override
  void initState() {
    FlutterNativeSplash.remove();
    controller.authMode.value = AuthMode.login;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: UniversalImage(
              Assets.onb,
              height: Ui.height(context),
              width: Ui.width(context) / 2,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500, minWidth: 480),
                child: Form(
                  key: controller.authKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UniversalImage(Assets.blogo, width: 180),
                      Ui.boxHeight(32),
                      AppText.bold("Login", fontSize: 64),
                      Ui.boxHeight(24),
                      CustomTextField(
                        "Email",
                        controller.tecs[1],
                        label: "Email",
                        varl: FPL.email,
                      ),
                      CustomTextField.password(
                        "* * * * * * * *",
                        controller.tecs[2],
                        label: "Password",
                      ),
                      // Row(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ForgotPasswordScreen());
                          },
                          child: Ui.padding(
                            child: AppText.thin("Forgot Password"),
                          ),
                        ),
                      ),
                      AppButton(
                        onPressed: () async {
                          await controller.onAuthPressed();
                        },
                        text: controller.authMode.value.title,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
