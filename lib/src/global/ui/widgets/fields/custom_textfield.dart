import 'package:youmehungry/src/utils/constants/countries.dart';
import 'package:flutter/material.dart';
import 'package:youmehungry/src/utils/formatters/num_formatters.dart';
import 'package:icons_plus/icons_plus.dart';
import '/src/src_barrel.dart';

import '../../ui_barrel.dart';

class CustomTextField extends StatelessWidget {
  final String hint, label;
  final TextEditingController controller;
  final FPL varl;
  final Color col, iconColor, fillcolor;
  final VoidCallback? onTap, customOnChanged;
  final TextInputAction tia;
  final dynamic suffix;
  final bool autofocus, hasBottomPadding;
  final double fs;
  final FontWeight fw;
  final int? maxLength;
  final bool readOnly, shdValidate;
  final TextAlign textAlign;
  final String? oldPass;
  const CustomTextField(
    this.hint,
    this.controller, {
    this.varl = FPL.text,
    this.label = "",
    this.fs = 14,
    this.hasBottomPadding = true,
    this.fw = FontWeight.w300,
    this.col = AppColors.textColor,
    this.iconColor = AppColors.primaryColor,
    this.fillcolor = AppColors.transparent,
    this.tia = TextInputAction.next,
    this.oldPass,
    this.onTap,
    this.maxLength,
    this.autofocus = false,
    this.customOnChanged,
    this.readOnly = false,
    this.shdValidate = true,
    this.textAlign = TextAlign.start,
    this.suffix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isShow = varl == FPL.password;
    String? vald;
    // Color borderCol =
    //     suffix != null ? AppColors.borderCol : AppColors.primaryColor;
    Color borderCol = AppColors.borderColor;
    // bool hasTouched = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: Ui.width(context) - 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotEmpty)
                Ui.align(child: AppText.medium(label, fontSize: 14)),
              if (label.isNotEmpty) Ui.boxHeight(4),
              TextFormField(
                controller: controller,
                readOnly: readOnly,
                textAlign: textAlign,
                autofocus: autofocus,
                onChanged: (s) async {
                  // if (s.isNotEmpty) {
                  //   setState(() {
                  //     hasTouched = true;
                  //   });
                  // } else {
                  //   setState(() {
                  //     hasTouched = false;
                  //   });
                  // }
                  if (customOnChanged != null) customOnChanged!();
                },
                keyboardType: varl.textType,
                textInputAction: tia,
                maxLines: varl == FPL.multi ? 5 : 1,
                maxLength: maxLength ?? varl.maxLength,
                onTap: onTap,
                inputFormatters: [
                  if (varl == FPL.cardNo) CreditCardFormatter(),
                  if (varl == FPL.money) ThousandsFormatter(),
                  // if (varl == FPL.dateExpiry) DateInputFormatter()
                ],
                validator: shdValidate
                    ? (value) {
                        // setState(() {
                        vald = oldPass == null
                            ? Validators.validate(varl, value)
                            : Validators.confirmPasswordValidator(
                                value,
                                oldPass!,
                              );

                        //   Future.delayed(const Duration(seconds: 1), () {
                        //     vald = null;
                        //   });
                        // });
                        return vald;
                      }
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(
                  fontSize: fs,
                  fontWeight: fw,
                  color: readOnly ? col.withValues(alpha: 0.7) : col,
                ),
                obscureText: varl == FPL.password && isShow,
                textAlignVertical: varl == FPL.multi
                    ? TextAlignVertical.top
                    : null,
                decoration: InputDecoration(
                  fillColor: fillcolor,
                  filled: false,
                  enabledBorder: customBorder(color: borderCol),
                  focusedBorder: customBorder(color: borderCol),
                  border: customBorder(color: borderCol),
                  focusedErrorBorder: customBorder(color: AppColors.red),
                  counter: SizedBox.shrink(),
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.red,
                  ),
                  errorBorder: customBorder(color: borderCol),
                  suffixIconConstraints: suffix != null
                      ? BoxConstraints(minWidth: 24, minHeight: 24)
                      : null,
                  isDense: suffix != null,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16,
                  ),
                  suffixIcon: suffix != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: AppIcon(
                            suffix,
                            color:
                                // hasTouched
                                //     ? AppColors.textColor
                                //     :
                                iconColor,
                          ),
                        )
                      : varl == FPL.password
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                          icon: AppIcon(
                            isShow
                                ? Iconsax.eye_outline
                                : Iconsax.eye_slash_outline,
                            color:
                                // hasTouched
                                //     ? AppColors.textColor
                                //     :
                                AppColors.white,
                          ),
                        )
                      : null,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: fs,
                    fontWeight: FontWeight.w400,
                    color: borderCol,
                  ),
                ),
              ),
              SizedBox(height: hasBottomPadding ? 24 : 0),
              // vald == null
              //     ? const SizedBox(
              //         height: 24,
              //       )
              //     : Align(
              //         alignment: Alignment.centerLeft,
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 8, bottom: 24),
              //           child: AppText.thin("$vald",
              //               fontSize: 12, color: AppColors.red),
              //         ))
            ],
          ),
        );
      },
    );
  }

  static bool isUserVal(String s) {
    return !(s.isEmpty || s.contains(RegExp(r'[^\w.]')) || s.length < 8);
  }

  InputBorder customBorder({Color color = AppColors.textColor}) {
    // return OutlineInputBorder(
    //   borderSide: BorderSide(color: color),
    //   borderRadius: BorderRadius.circular(8),
    //   gapPadding: 8,
    // );

    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(24),
      gapPadding: 8,
    );
    // return InputBorder.none;
  }

  static password(
    String hint,
    TextEditingController controller, {
    String? oldPass,
    String label = "Password",
    TextInputAction tia = TextInputAction.done,
    bool hbp = true,
  }) {
    return CustomTextField(
      hint,
      controller,
      tia: tia,
      varl: FPL.password,
      oldPass: oldPass,
      label: label,
      hasBottomPadding: hbp,
    );
  }

  // static search(String hint, TextEditingController controller,
  //     VoidCallback customOnChanged) {
  //   return CustomTextField(hint, controller,
  //       hasBottomPadding: false,
  //       shdValidate: false,
  //       suffix: Assets.search38,
  //       customOnChanged: customOnChanged);
  // }
}

// class PhoneTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hint;
//   final String label;
//   final Color fillColor;
//   final bool hasBottomPadding, readOnly,shdValidate;
//   final List<Map<String, String>> ct;
//   final String code;

//   const PhoneTextField(
//     this.hint,
//     this.controller,
//     this.label, {
//     this.fillColor = Colors.transparent,
//     this.hasBottomPadding = true,
//     this.readOnly = false,
//     this.ct = const [],
//     this.code = "+234",
//     this.shdValidate=true,
//     super.key,
//   });

//   @override
//   State<PhoneTextField> createState() => _PhoneTextFieldState();
// }

// class _PhoneTextFieldState extends State<PhoneTextField> {
//   Map<String, String> selectedCountry = {
//     'name': 'Nigeria',
//     'code': 'NG',
//     'dial_code': '+234',
//     'flag': '🇳🇬'
//   };

//   @override
//   void initState() {
//     super.initState();
//     selectedCountry = widget.ct.where((element) {
//       return
//       element["dial_code"] == widget.code;
//     }).firstOrNull ?? widget.ct.first;
//     widget.controller.text = widget.controller.text.isEmpty ?  '${selectedCountry['dial_code']!} ' : widget.controller.text;
//   }

//   void _onCountryChanged(Map<String, String> country) {
//     setState(() {
//       selectedCountry = country;
//       widget.controller.text = '${selectedCountry['dial_code']!} ';
//       widget.controller.selection = TextSelection.fromPosition(
//         TextPosition(offset: widget.controller.text.length),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? vald;
//     Color borderCol = AppColors.borderColor;
//     List<Map<String, String>> ct =
//         widget.ct.isNotEmpty ? widget.ct : [selectedCountry];
//     return SizedBox(
//         width: Ui.width(context) - 32,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (widget.label.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: AppText.medium(widget.label, fontSize: 14),
//               ),
//             TextFormField(
//               controller: widget.controller,
//               readOnly: widget.readOnly,
//               keyboardType: TextInputType.phone,
//               validator: widget.shdValidate ? (value) {
//                 // setState(() {
//                 vald = Validators.validate(FPL.phone, value);
//                 return vald;
//               } : null,
//               autovalidateMode: widget.shdValidate ? AutovalidateMode.onUserInteraction : null,
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w300,
//                   color: widget.readOnly ? AppColors.textColor.withValues(alpha:0.7): AppColors.textColor),
//               decoration: InputDecoration(
//                 hintText: widget.hint,
//                 fillColor: widget.fillColor,
//                 filled: widget.fillColor != Colors.transparent,
//                 prefixIcon: DropdownButtonHideUnderline(
//                   child: DropdownButton<Map<String, String>>(
//                     value: selectedCountry,
//                     dropdownColor: AppColors.containerColor,

//                     selectedItemBuilder: (c) {
//                       return ct.map<DropdownMenuItem<Map<String, String>>>(
//                           (country) {
//                         return DropdownMenuItem<Map<String, String>>(
//                           value: country,
//                           child: Row(
//                             children: [
//                               Ui.boxWidth(16),
//                               AppText.medium(country['flag'] ?? "🇳🇬"),
//                               // SizedBox(width: 6),
//                               // Text(country['dial_code'] ?? "+234", style: TextStyle(fontSize: 14)),
//                             ],
//                           ),
//                         );
//                       }).toList();
//                     },
//                     items: ct
//                         .map<DropdownMenuItem<Map<String, String>>>((country) {
//                       return DropdownMenuItem<Map<String, String>>(
//                         value: country,
//                         child: Row(
//                           children: [
//                             AppText.thin(country['name'] ?? "🇳🇬",
//                                 fontSize: 14),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                     menuWidth: Ui.width(context) - 64,
//                     onChanged:widget.readOnly ? null: (country) {
//                       if (country != null) _onCountryChanged(country);
//                     },
//                   ),
//                 ),
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
//                 enabledBorder: customBorder(color: borderCol),
//                 focusedBorder: customBorder(color: borderCol),
//                 border: customBorder(color: borderCol),
//                 focusedErrorBorder: customBorder(color: AppColors.red),
//                 counter: SizedBox.shrink(),
//                 errorStyle: const TextStyle(fontSize: 12, color: AppColors.red),
//                 errorBorder: customBorder(color: borderCol),
//               ),
//             ),
//             SizedBox(height: widget.hasBottomPadding ? 24 : 0),
//           ],
//         ));
//   }

//   InputBorder customBorder({Color color = AppColors.textColor}) {
//     // return OutlineInputBorder(
//     //   borderSide: BorderSide(color: color),
//     //   borderRadius: BorderRadius.circular(8),
//     //   gapPadding: 8,
//     // );

//     return OutlineInputBorder(
//       borderSide: BorderSide(color: color),
//       borderRadius: BorderRadius.circular(24),
//       gapPadding: 8,
//     );
//     // return InputBorder.none;
//   }
// }

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final Color fillColor;
  final bool hasBottomPadding, readOnly, shdValidate;
  final List<Map<String, String>> ct;
  final String code;

  const PhoneTextField(
    this.hint,
    this.controller,
    this.label, {
    this.fillColor = Colors.transparent,
    this.hasBottomPadding = true,
    this.readOnly = false,
    this.ct = const [],
    this.code = "+234",
    this.shdValidate = true,
    super.key,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  Map<String, String> selectedCountry = {
    'name': 'Nigeria',
    'code': 'NG',
    'dial_code': '+234',
    'flag': '🇳🇬',
  };

  @override
  void initState() {
    super.initState();
    selectedCountry =
        widget.ct.where((element) {
          return element["dial_code"] == widget.code;
        }).firstOrNull ??
        widget.ct.first;
    widget.controller.text = widget.controller.text.isEmpty
        ? '${selectedCountry['dial_code']!} '
        : widget.controller.text;
  }

  void _onCountryChanged(Map<String, String> country) {
    setState(() {
      selectedCountry = country;
      widget.controller.text = '${selectedCountry['dial_code']!} ';
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  void _showCountrySearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CountrySearchBottomSheet(
        countries: widget.ct.isEmpty ? countriesData : widget.ct,
        selectedCountry: selectedCountry,
        onChanged: (country) {
          _onCountryChanged(country);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? vald;
    Color borderCol = AppColors.borderColor;
    List<Map<String, String>> ct = widget.ct.isNotEmpty
        ? widget.ct
        : [selectedCountry];

    return SizedBox(
      width: Ui.width(context) - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: AppText.medium(widget.label, fontSize: 14),
            ),
          TextFormField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            keyboardType: TextInputType.phone,
            validator: widget.shdValidate
                ? (value) {
                    vald = Validators.validate(FPL.phone, value);
                    return vald;
                  }
                : null,
            autovalidateMode: widget.shdValidate
                ? AutovalidateMode.onUserInteraction
                : null,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: widget.readOnly
                  ? AppColors.textColor.withValues(alpha: 0.7)
                  : AppColors.textColor,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              fillColor: widget.fillColor,
              filled: widget.fillColor != Colors.transparent,
              prefixIcon: widget.readOnly
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.medium(selectedCountry['flag'] ?? "🇳🇬"),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => _showCountrySearchBottomSheet(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.medium(selectedCountry['flag'] ?? "🇳🇬"),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.borderColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16,
              ),
              enabledBorder: customBorder(color: borderCol),
              focusedBorder: customBorder(color: borderCol),
              border: customBorder(color: borderCol),
              focusedErrorBorder: customBorder(color: AppColors.red),
              counter: SizedBox.shrink(),
              errorStyle: const TextStyle(fontSize: 12, color: AppColors.red),
              errorBorder: customBorder(color: borderCol),
            ),
          ),
          SizedBox(height: widget.hasBottomPadding ? 24 : 0),
        ],
      ),
    );
  }

  InputBorder customBorder({Color color = AppColors.textColor}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(24),
      gapPadding: 8,
    );
  }
}

class _CountrySearchBottomSheet extends StatefulWidget {
  final List<Map<String, String>> countries;
  final Map<String, String> selectedCountry;
  final Function(Map<String, String>) onChanged;

  const _CountrySearchBottomSheet({
    required this.countries,
    required this.selectedCountry,
    required this.onChanged,
  });

  @override
  State<_CountrySearchBottomSheet> createState() =>
      _CountrySearchBottomSheetState();
}

class _CountrySearchBottomSheetState extends State<_CountrySearchBottomSheet> {
  late List<Map<String, String>> filteredCountries;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCountries = widget.countries;
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = widget.countries;
      } else {
        filteredCountries = widget.countries.where((country) {
          final name = (country['name'] ?? '').toLowerCase();
          final code = (country['dial_code'] ?? '').toLowerCase();
          final query_lower = query.toLowerCase();
          return name.contains(query_lower) || code.contains(query_lower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColors.textColor),
                ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: _filterCountries,
              style: TextStyle(fontSize: 14, color: AppColors.textColor),
              decoration: InputDecoration(
                hintText: 'Search by name or code...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.borderColor,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.borderColor),
                filled: true,
                fillColor: AppColors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(48),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(48),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(48),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          // Countries list
          Expanded(
            child: filteredCountries.isEmpty
                ? Center(
                    child: Text(
                      'No countries found',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.borderColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final isSelected =
                          country['dial_code'] ==
                          widget.selectedCountry['dial_code'];

                      return InkWell(
                        onTap: () {
                          widget.onChanged(country);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.borderColor.withOpacity(0.1)
                                : null,
                          ),
                          child: Row(
                            children: [
                              AppText.medium(
                                country['flag'] ?? '🇳🇬',
                                fontSize: 20,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.thin(
                                      country['name'] ?? '',
                                      fontSize: 14,
                                    ),
                                    AppText.thin(
                                      country['dial_code'] ?? '',
                                      fontSize: 12,
                                      color: AppColors.borderColor,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: AppColors.textColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
