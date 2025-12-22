import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/global/controller/connection_controller.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_dropdown.dart';
import 'package:youmehungry/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../global/ui/widgets/others/containers.dart';
import '../plugin/countries_states.dart';
import '../utils/constants/countries.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.onPressed,
    this.text = "",
    this.isDisabled = false,
    super.key,
  });
  final Function? onPressed;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Ui.width(context),
        height: 86,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.black,
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 0),
              blurRadius: 50,
              spreadRadius: 3,
              color: Color(0xFFF2F2F2).withOpacity(0.1),
            ),
          ],
        ),
        child: AppButton(
          onPressed: onPressed,
          text: text,
          disabled: isDisabled,
        ),
      ),
    );
  }
}

class CategoryItemHeader extends StatelessWidget {
  const CategoryItemHeader(
    this.cit, {
    this.fs1 = 16,
    this.fs2 = 12,
    this.fs3 = 12,
    this.ml = 2,
    super.key,
  });
  final CategoryItem cit;
  final double fs1, fs2, fs3;
  final int? ml;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          cit.name,
          maxLines: 1,
          fontSize: fs1,
          alignment: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        if (cit.startDate != null) Ui.boxHeight(8),
        if (cit.startDate != null)
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                Iconsax.clock_outline,
                color: AppColors.lightTextColor,
                size: fs2,
              ),
              Ui.boxWidth(4),
              Expanded(
                child: AppText.medium(
                  cit.dateTimeRaw,
                  fontSize: fs2,
                  color: AppColors.accentColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  alignment: TextAlign.start,
                ),
              ),
            ],
          ),
        if (cit.address?.isNotEmpty ?? false) Ui.boxHeight(8),
        if (cit.address?.isNotEmpty ?? false)
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                Iconsax.location_outline,
                color: AppColors.lightTextColor,
                size: fs3,
              ),
              Ui.boxWidth(4),
              Expanded(
                child: AppText.thin(
                  cit.address!,
                  fontSize: fs3,
                  alignment: TextAlign.start,
                  maxLines: cit.startDate == null ? ml : 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.lightTextColor,
                ),
              ),
            ],
          ),
        if (cit.categoryId == 8)
          AppText.thin(
            cit.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            color: AppColors.lightTextColor,
          ),
      ],
    );
  }
}

class DettyCard extends StatelessWidget {
  const DettyCard(
    this.title,
    this.desc, {
    this.url = Assets.bg2,
    this.onTap,
    this.height = 160,
    this.btnText = "",
    super.key,
  });
  final String title, desc, url, btnText;
  final double height;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Ui.padding(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CurvedImage(
            url,
            w: Ui.width(context) - 32,
            h: height,
            fit: BoxFit.cover,
          ),
          Ui.padding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: Ui.width(context) - 32, height: 24),
                AppText.medium(title),
                Ui.boxHeight(12),
                AppText.thin(desc, fontSize: 14, alignment: TextAlign.center),
                if (onTap != null)
                  Ui.padding(
                    child: AppButton(
                      onPressed: onTap,
                      text: btnText,
                      color: AppColors.black,
                    ),
                  ),
                Ui.boxHeight(24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItemWidget extends StatelessWidget {
  SettingsItemWidget(
    this.title,
    this.desc, {
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    super.key,
  });
  final String title, desc;
  final Function()? onTap;
  final Function(bool)? onSwitchChanged;
  final bool switchValue;
  final RxBool curSwitchValue = false.obs;

  @override
  Widget build(BuildContext context) {
    curSwitchValue.value = switchValue;
    final pp = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.thin(title),
                if (desc.isNotEmpty) Ui.boxHeight(8),
                if (desc.isNotEmpty)
                  AppText.thin(
                    desc,
                    fontSize: 14,
                    color: AppColors.lightTextColor,
                  ),
              ],
            ),
          ),
          Ui.boxWidth(24),
          if (onTap != null) AppIcon(Icons.chevron_right_rounded),
          if (onSwitchChanged != null)
            Obx(() {
              return Switch(
                activeTrackColor: AppColors.primaryColor,
                inactiveTrackColor: AppColors.disabledColor,
                inactiveThumbColor: AppColors.white,
                value: curSwitchValue.value,
                onChanged: (v) {
                  curSwitchValue.value = v;
                  onSwitchChanged!(v);
                },
              );
            }),
        ],
      ),
    );
    return InkWell(onTap: onTap, child: pp);
  }
}

class CustomKeyPad extends StatelessWidget {
  const CustomKeyPad(this.tec, {this.maxPin = 6, this.onNext, super.key});
  final TextEditingController tec;
  final Function()? onNext;
  final int maxPin;
  static const List<dynamic> keypads = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    Icons.close_rounded,
    "0",
    Icons.chevron_right_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ui.boxHeight(24),
        PinCodeTextField(
          appContext: context,
          length: maxPin,
          controller: tec,
          // validator: (s) {
          //   if ((s ?? "").isEmpty) {
          //     return "error";
          //   }
          //   return null;
          // },
          cursorColor: AppColors.primaryColor,
          textStyle: TextStyle(color: AppColors.white),
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            fieldHeight: 64,
            fieldWidth: 48,
            borderWidth: 1,
            selectedColor: AppColors.primaryColor,
            shape: PinCodeFieldShape.underline,
            inactiveColor: AppColors.borderColor,
            activeColor: AppColors.borderColor,
          ),
          autoDisposeControllers: false,
        ),
        Ui.boxHeight(24),
        SizedBox(
          width: 278,
          height: 328,
          child: Wrap(
            spacing: 34,
            runSpacing: 16,
            children: List.generate(keypads.length, (i) {
              if (i == 9) {
                return CircleIcon(
                  keypads[i],
                  color: Color(0xFF404040),
                  radius: 35,
                  onTap: () {
                    if (tec.text.isEmpty) return;
                    tec.text = tec.text.substring(0, tec.text.length - 1);
                  },
                );
              }
              if (i == 11) {
                return CircleIcon(
                  keypads[i],
                  color: AppColors.primaryColor,
                  radius: 35,
                  onTap: onNext,
                );
              }
              return InkWell(
                onTap: () {
                  if (tec.text.length >= maxPin) return;
                  tec.text = tec.text + keypads[i].toString();
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFF767680).withOpacity(0.12),
                  child: Center(child: AppText.thin(keypads[i], fontSize: 24)),
                ),
              );
            }),
          ),
        ),
        Ui.boxHeight(24),
      ],
    );
  }
}

class PaginatorFooter extends StatelessWidget {
  PaginatorFooter({super.key});
  static const icons = [
    Icons.fast_rewind_rounded,
    Icons.chevron_left_rounded,
    Icons.chevron_right_rounded,
    Icons.fast_forward_rounded,
  ];
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        AppText.thin("Rows per page"),
        Ui.boxWidth(16),
        SizedBox(
          width: 100,
          child: CustomDropdown.rows(
            hint: "10",
            selectedValue: 10,
            onChanged: (v) {},
          ),
        ),
        Ui.boxWidth(36),
        Obx(() {
          return AppText.thin(
            "Page ${controller.curPaginatorPage.value} of ${controller.curPaginatorTotalPages.value} ",
          );
        }),
        Ui.boxWidth(36),
        ...List.generate(4, (i) => paginatorButton(i)),
      ],
    );
  }

  paginatorButton(int i) {
    return Obx(() {
      bool isActive = true;
      if (i < 2) {
        isActive = controller.curPaginatorPage.value > 1;
      } else {
        isActive =
            controller.curPaginatorPage.value <
            controller.curPaginatorTotalPages.value;
      }
      final color = isActive ? AppColors.white : AppColors.borderColor;
      return CurvedContainer(
        border: Border.all(color: color),
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(horizontal: 8),
        onPressed: isActive
            ? () {
                if (i == 0) {
                  controller.gotoFirstPage();
                } else if (i == 1) {
                  controller.gotoPreviousPage();
                } else if (i == 2) {
                  controller.gotoNextPage();
                } else if (i == 3) {
                  controller.gotoLastPage();
                }
              }
            : null,
        child: AppIcon(icons[i], color: color, size: 24),
      );
    });
  }
}

loadAsyncFunction(Function onLoad) async {
  await Get.showOverlay(
    asyncFunction: () async {
      await onLoad();
      return true;
    },
    loadingWidget: Center(
      child: SizedBox(height: 56, child: CircularProgress(56)),
    ),
  );
}

class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectionController>();
    return Obx(() {
      if (Get.find<DashboardController>().needsUpdate.value) {
        return Material(
          color: AppColors.black,
          child: Center(
            child: CurvedContainer(
              color: AppColors.containerColor,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(Icons.sync, color: AppColors.white, size: 48),
                  Ui.boxHeight(16),
                  AppText.thin(
                    "A new version of the app is available. Please update from the ${GetPlatform.isAndroid ? "Play Store" : "App Store"} to access the latest features and improvements.",
                    color: AppColors.white,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (!controller.isConnected.value) {
        return Material(
          color: AppColors.black,
          child: Center(
            child: CurvedContainer(
              color: AppColors.containerColor,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    Icons.wifi_off_rounded,
                    color: AppColors.white,
                    size: 48,
                  ),
                  Ui.boxHeight(16),
                  AppText.thin(
                    "No internet connection",
                    color: AppColors.white,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return child;
    });
  }
}

class AddressFieldWidget extends StatefulWidget {
  const AddressFieldWidget(this.afc, {super.key});
  final AddressFieldController afc;

  @override
  State<AddressFieldWidget> createState() => _AddressFieldWidgetState();
}

class _AddressFieldWidgetState extends State<AddressFieldWidget> {
  List<String> currentStates = [];
  List<Map<String, String>> curCountries = [];
  List<TextEditingController> tecs = List.generate(
    3,
    (i) => TextEditingController(),
  );

  @override
  void initState() {
    curCountries = widget.afc.hasZipCode
        ? countriesData
        : Get.find<DashboardController>().allAvailableCountries;
    currentStates =
        cmaps[curCountries
                .where((test) => test["name"] == widget.afc.country)
                .first["code"] ??
            "NG"]!;
    widget.afc.state = currentStates[0];
    tecs[0].text = widget.afc.street;
    tecs[1].text = widget.afc.city;
    tecs[2].text = widget.afc.zipCode ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      radius: 0,
      color: AppColors.containerColor,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.medium("Add Address", fontSize: 20),
            Ui.boxHeight(24),
            CustomDropdown.country(
              hint: "",
              selectedValue:
                  curCountries
                      .where((test) => test["name"] == widget.afc.country)
                      .first["code"] ??
                  "NG",
              ct: curCountries,
              onChanged: (v) {
                widget.afc.country = curCountries
                    .where((test) => test["code"] == v)
                    .first["name"]!;

                currentStates =
                    cmaps[curCountries
                            .where((test) => test["name"] == widget.afc.country)
                            .first["code"] ??
                        "NG"]!;
                widget.afc.state = currentStates.elementAtOrNull(0) ?? "";
                setState(() {});
              },
            ),
            // selectedValue: widget.afc.country.isEmpty ? "NG" : widget.afc.country,
            // onChanged: (v) {
            //   widget.afc.country = v ?? "NG";
            //   currentStates = cmaps[widget.afc.country]!;
            //   setState(() {});
            // }),
            CustomDropdown.city(
              hint: "Select State",
              selectedValue: widget.afc.state.isEmpty
                  ? currentStates[0]
                  : widget.afc.state,
              label: "State",
              cities: currentStates,
              onChanged: (v) {
                widget.afc.state = v ?? "";
                setState(() {});
              },
            ),
            CustomTextField(
              "123 Test Street",
              tecs[0],
              label: "Street",
              customOnChanged: () {
                widget.afc.street = tecs[0].text;
              },
            ),
            CustomTextField(
              "City",
              tecs[1],
              label: "City",
              varl: FPL.text,
              customOnChanged: () {
                widget.afc.city = tecs[1].text;
              },
            ),
            if (widget.afc.hasZipCode)
              CustomTextField(
                "ZipCode",
                tecs[2],
                label: "ZipCode",
                varl: FPL.number,
                customOnChanged: () {
                  widget.afc.zipCode = tecs[2].text;
                },
              ),
            SafeArea(
              child: AppButton(
                onPressed: () {
                  final b = widget.afc.onSubmit();
                  if (b) {
                    Get.back();
                  }
                },
                text: "Save",
              ),
            ),
            Ui.boxHeight(24),
          ],
        ),
      ),
    );
  }
}

class CountryCityWidget extends StatefulWidget {
  const CountryCityWidget(this.tec, {super.key});
  final TextEditingController tec;

  @override
  State<CountryCityWidget> createState() => _CountryCityWidgetState();
}

class _CountryCityWidgetState extends State<CountryCityWidget> {
  List<String> currentStates = [];
  List<TextEditingController> tecs = List.generate(
    3,
    (i) => TextEditingController(),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    tecs[0].text = "Nigeria";
    currentStates =
        cmaps[countriesData
                .where((test) => test["name"] == "Nigeria")
                .first["code"] ??
            "NG"]!;
    tecs[1].text = currentStates[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      radius: 0,
      color: AppColors.containerColor,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.medium("Add Address", fontSize: 20),
              Ui.boxHeight(24),
              CustomDropdown.country(
                hint: "",
                selectedValue:
                    countriesData
                        .where((test) => test["name"] == tecs[0].text)
                        .first["code"] ??
                    "NG",
                ct: countriesData,
                onChanged: (v) {
                  tecs[0].text = countriesData
                      .where((test) => test["code"] == v)
                      .first["name"]!;

                  currentStates =
                      cmaps[countriesData
                              .where((test) => test["name"] == tecs[0].text)
                              .first["code"] ??
                          "NG"]!;
                  setState(() {});
                },
              ),
              CustomDropdown.city(
                hint: "Select State",
                selectedValue: tecs[1].text.isEmpty
                    ? currentStates[0]
                    : tecs[1].text,
                label: "State",
                cities: currentStates,
                onChanged: (v) {
                  tecs[1].text = v ?? "";
                  setState(() {});
                },
              ),
              SafeArea(
                child: AppButton(
                  onPressed: () {
                    final b = formKey.currentState!.validate();
                    if (b) {
                      widget.tec.text = "${tecs[1].text}, ${tecs[0].text}";
                      Get.back();
                    }
                  },
                  text: "Save",
                ),
              ),
              Ui.boxHeight(24),
            ],
          ),
        ),
      ),
    );
  }
}

class FullNameWidget extends StatefulWidget {
  const FullNameWidget(this.afc, {super.key});
  final TextEditingController afc;

  @override
  State<FullNameWidget> createState() => _FullNameWidgetState();
}

class _FullNameWidgetState extends State<FullNameWidget> {
  List<TextEditingController> tecs = List.generate(
    3,
    (i) => TextEditingController(),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.afc.text.split(" ").length < 2) {
      tecs[0].text = widget.afc.text;
      tecs[1].text = "";
    } else {
      tecs[0].text = widget.afc.text.split(" ")[0];
      tecs[1].text = widget.afc.text.split(" ").sublist(1).join(" ");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      radius: 0,
      color: AppColors.containerColor,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.medium("Add Full Name", fontSize: 20),
              Ui.boxHeight(24),
              CustomTextField(
                "John",
                tecs[0],
                label: "First Name",
                customOnChanged: () {
                  widget.afc.text = "${tecs[0].text} ${tecs[1].text}";
                },
              ),
              CustomTextField(
                "Doe",
                tecs[1],
                label: "Other Names",
                customOnChanged: () {
                  widget.afc.text = "${tecs[0].text} ${tecs[1].text}";
                },
              ),
              SafeArea(
                child: AppButton(
                  onPressed: () {
                    final b = formKey.currentState!.validate();
                    if (b) {
                      Get.back();
                    }
                  },
                  text: "Save",
                ),
              ),
              Ui.boxHeight(24),
            ],
          ),
        ),
      ),
    );
  }
}

class CardAddressWidget extends StatelessWidget {
  CardAddressWidget({super.key});
  List<String> currentStates = [];
  RxList<String> currentLGAs = <String>[].obs;
  List<TextEditingController> tecs = List.generate(
    7,
    (i) => TextEditingController(),
  );
  final controller = Get.find<DashboardController>();
  final cardKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.initWalletTecs();
    tecs[1].text = "Male";
    currentStates =
        cmaps[controller.allAvailableCountries
                .where((test) => test["name"] == "Nigeria")
                .first["code"] ??
            "NG"]!;
    currentLGAs.value = nigeriaLGAS
        .where((test) => test["state"] == currentStates[0])
        .first["lgas"];
    return CurvedContainer(
      radius: 0,
      color: AppColors.containerColor,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: cardKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppText.medium("Add Card Details", fontSize: 20),
                  Spacer(),
                  CircleIcon(
                    Icons.close_rounded,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
              Ui.boxHeight(24),
              CustomTextField(
                "John Doe",
                controller.walletTecs[0],
                label: "Card Holder Name",
                readOnly: controller.walletTecs[0].text.isNotEmpty,
              ),
              CustomTextField(
                "johndoe@gmail.com",
                controller.walletTecs[1],
                label: "Email",
                varl: FPL.email,
                readOnly: true,
              ),
              PhoneTextField(
                "+234 704 847 848",
                tecs[0],
                "Phone Number",
                ct: countriesData,
              ),
              CustomDropdown.city(
                hint: "Gender",
                selectedValue: tecs[1].text,
                label: "Gender",
                cities: ["Male", "Female"],
                onChanged: (v) {
                  tecs[1].text = v ?? "Male";
                },
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: CustomTextField(
                      "23",
                      tecs[2],
                      varl: FPL.number,
                      label: "Street No",
                    ),
                  ),
                  Ui.boxWidth(16),
                  Expanded(
                    child: CustomTextField(
                      "Test Street",
                      tecs[3],
                      label: "Street Name",
                    ),
                  ),
                ],
              ),
              CustomTextField("Near ABC Mall", tecs[4], label: "Landmark"),
              CustomDropdown.city(
                hint: "Select State",
                selectedValue: currentStates[0],
                label: "State",
                cities: currentStates,
                onChanged: (v) {
                  tecs[6].text = v ?? "";
                  currentLGAs.value = nigeriaLGAS
                      .where((test) => test["state"] == v)
                      .first["lgas"];
                },
              ),
              Obx(() {
                return CustomDropdown.city(
                  hint: "Select LGA",
                  selectedValue: currentLGAs[0],
                  label: "Local Government Area",
                  cities: currentLGAs,
                  onChanged: (v) {
                    tecs[5].text = v ?? "";
                  },
                );
              }),

              // CustomTextField(
              //   "Ikeja LGA",
              //   tecs[5],
              //   label: "LGA",
              // ),
              SafeArea(
                child: AppButton(
                  onPressed: () {
                    if (cardKey.currentState!.validate()) {
                      // controller.currentCardItem.value.address =
                      //     "${tecs[2].text} ${tecs[3].text}, ${tecs[4].text}, ${tecs[5].text}, ${tecs[6].text}";
                      controller.currentCardItem.value.userData = {
                        "email": controller.walletTecs[1].text,
                        "fullname": controller.walletTecs[0].text,
                        "gender": tecs[1].text,
                        "phone": tecs[0].text.removeAllWhitespace.replaceAll(
                          "+",
                          "",
                        ),
                        "houseNumber": tecs[2].text,
                        "streetName": tecs[3].text,
                        "landMark": tecs[4].text,
                        "lga": tecs[5].text,
                        "state": tecs[6].text,
                      };
                      Get.to(CreateCardPINScreen());
                    }
                  },
                  text: "Continue",
                ),
              ),
              Ui.boxHeight(24),
            ],
          ),
        ),
      ),
    );
  }
}
