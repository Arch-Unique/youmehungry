import 'package:youmehungry/src/utils/constants/countries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/src/src_barrel.dart';
import '../../ui_barrel.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint, label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final Color iconColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool hasBottomPadding;
  final bool isEnabled;

  CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.label = "",
    this.iconColor = AppColors.primaryColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w300,
    this.hasBottomPadding = true,
    this.isEnabled = true,
  });
  Rx<DropdownMenuItem<T>> selectedItem = DropdownMenuItem<T>(
    value: null,
    child: SizedBox(),
  ).obs;

  String _getItemText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    }
    if (item.child is AppText) {
      return (item.child as AppText).text;
    }
    if (item.child is Row || item.child is Column) {
      final children = (item.child as Flex).children;
      String txt = "";
      for (var child in children) {
        if (child is Text) {
          txt += child.data ?? '';
        }
        if (child is AppText) {
          txt += child.text;
        }
        txt += " ";
      }
      return txt;
    }
    return item.value.toString();
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) => _SearchBottomSheet<T>(
        items: items,
        value: value,
        onChanged: (i) {
          selectedItem.value = items.firstWhere(
            (item) => item.value == i,
            orElse: () => DropdownMenuItem<T>(value: null, child: SizedBox()),
          );
          onChanged(i);
        },
        hint: hint,
        fontSize: fontSize,
        fontWeight: fontWeight,
        getItemText: _getItemText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.borderColor;
    final useBottomSheet = items.length > 10;
    selectedItem.value = items.firstWhere(
      (item) => item.value == value,
      orElse: () => DropdownMenuItem<T>(value: null, child: SizedBox()),
    );

    return SizedBox(
      width: Ui.width(context) - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Ui.align(child: AppText.medium(label, fontSize: 14)),
          if (label.isNotEmpty) Ui.boxHeight(4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: useBottomSheet
                ? InkWell(
                    onTap: isEnabled
                        ? () => _showSearchBottomSheet(context)
                        : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return selectedItem.value.child;
                            }),

                            // Text(
                            //   value != null
                            //       ? _getItemText(items.firstWhere((item) => item.value == value))
                            //       : hint,
                            //   style: TextStyle(
                            //     fontSize: fontSize,
                            //     fontWeight: value != null ? fontWeight : FontWeight.w400,
                            //     color: value != null ? AppColors.textColor : borderColor,
                            //   ),
                            // ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: AppIcon(
                              Icons.arrow_drop_down,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : DropdownButtonFormField<T>(
                    value: value,
                    isExpanded: true,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AppIcon(
                        Icons.arrow_drop_down,
                        color: iconColor,
                      ),
                    ),
                    decoration: InputDecoration(
                      fillColor: AppColors.transparent,
                      filled: false,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16,
                      ),
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: borderColor,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: AppColors.textColor,
                    ),
                    dropdownColor: AppColors.containerColor,
                    items: isEnabled ? items : [],
                    onChanged: isEnabled ? onChanged : null,
                  ),
          ),
          SizedBox(height: hasBottomPadding ? 24 : 0),
        ],
      ),
    );
  }

  // Factory constructor for country selector dropdown
  static CustomDropdown<String> country({
    required String hint,
    required String? selectedValue,
    required Function(String?) onChanged,
    String label = "Country",
    bool hasBottomPadding = true,
    List<Map<String, String>>? ct,
  }) {
    // You can add more countries as needed
    final countries = ct ?? countriesData;

    return CustomDropdown<String>(
      hint: hint.isEmpty ? "Select Country" : hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: countries.map((country) {
        return DropdownMenuItem<String>(
          value: country['code'],
          child: Row(
            children: [
              AppText.thin(country['flag']!, fontSize: 14),
              SizedBox(width: 8),
              AppText.thin(country['name']!, fontSize: 14),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for number of days dropdown
  static CustomDropdown<int> days({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    String label = "Number of Days",
    bool hasBottomPadding = true,
    int maxDays = 90,
  }) {
    // Generate days from 1 to 90 (can be adjusted as needed)
    final List<int> days = List.generate(maxDays, (index) => index + 1);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: AppText.thin(day.toString(), fontSize: 14),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for number of days dropdown
  static CustomDropdown<int> rows({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = [10, 20, 50, 100];

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      hasBottomPadding: false,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: AppText.thin(day.toString(), fontSize: 14),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  static CustomDropdown<int> months({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = List.generate(12, (index) => index + 1);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: AppText.thin(
            DateFormat("MMMM").format(DateTime(2025, day)),
            fontSize: 14,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  static CustomDropdown<int> years({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = List.generate(50, (index) => index + 2025);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: AppText.thin(day.toString(), fontSize: 14),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for city dropdown
  static CustomDropdown<String> city({
    required String hint,
    required String? selectedValue,
    required Function(String?) onChanged,
    required List<String> cities,
    String label = "Number of Days",
    bool hasBottomPadding = true,
  }) {
    return CustomDropdown<String>(
      hint: hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: cities.map((day) {
        return DropdownMenuItem<String>(
          value: day,
          child: AppText.thin(day.toString(), fontSize: 14),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for phone country code dropdown
  static CustomDropdown<String> phoneCountryCode({
    required String? selectedValue,
    required Function(String?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // You can add more country codes as needed
    final countryCodes = [
      {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
      {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
      {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
      {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
      {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    ];

    return CustomDropdown<String>(
      hint: "+1",
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: countryCodes.map((country) {
        return DropdownMenuItem<String>(
          value: country['code'],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country['flag']!),
              SizedBox(width: 4),
              Text(country['code']!, style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _SearchBottomSheet<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T?) onChanged;
  final String hint;
  final double fontSize;
  final FontWeight fontWeight;
  final String Function(DropdownMenuItem<T>) getItemText;

  const _SearchBottomSheet({
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hint,
    required this.fontSize,
    required this.fontWeight,
    required this.getItemText,
  });

  @override
  State<_SearchBottomSheet<T>> createState() => _SearchBottomSheetState<T>();
}

class _SearchBottomSheetState<T> extends State<_SearchBottomSheet<T>> {
  late List<DropdownMenuItem<T>> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items.where((item) {
          final text = widget.getItemText(item).toLowerCase();
          return text.contains(query.toLowerCase());
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
                  widget.hint,
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
              onChanged: _filterItems,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: AppColors.textColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: widget.fontSize,
                  color: AppColors.borderColor,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.borderColor),
                filled: true,
                fillColor: AppColors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          // Items list
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: AppColors.borderColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = item.value == widget.value;

                      return InkWell(
                        onTap: () {
                          widget.onChanged(item.value);
                          Navigator.pop(context);
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
                              Expanded(child: item.child),
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

class RawDropdown<T> extends StatelessWidget {
  RawDropdown(this.value, this.onChanged, {this.items = const [], super.key});
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T?) onChanged;
  Rx<DropdownMenuItem<T>> selectedItem = DropdownMenuItem<T>(
    value: null,
    child: SizedBox(),
  ).obs;

  String _getItemText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    }
    if (item.child is AppText) {
      return (item.child as AppText).text;
    }
    if (item.child is Row || item.child is Column) {
      final children = (item.child as Flex).children;
      String txt = "";
      for (var child in children) {
        if (child is Text) {
          txt += child.data ?? '';
        }
        if (child is AppText) {
          txt += child.text;
        }
        txt += " ";
      }
      return txt;
    }
    return item.value.toString();
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) => _SearchBottomSheet<T>(
        items: items,
        value: value,
        onChanged: (i) {
          selectedItem.value = items.firstWhere(
            (item) => item.value == i,
            orElse: () => DropdownMenuItem<T>(value: null, child: SizedBox()),
          );
          onChanged(i);
        },
        hint: "Select Bank",
        fontSize: 14,
        fontWeight: FontWeight.w400,
        getItemText: _getItemText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useBottomSheet = items.length > 10;
    selectedItem.value = items.firstWhere(
      (item) => item.value == value,
      orElse: () => DropdownMenuItem<T>(value: null, child: SizedBox()),
    );
    return useBottomSheet
        ? InkWell(
            onTap: () => _showSearchBottomSheet(context),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return selectedItem.value.child;
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppIcon(
                      Icons.arrow_drop_down,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        : DropdownButton<T>(
            dropdownColor: AppColors.containerColor,
            isExpanded: true,
            icon: AppIcon(Icons.arrow_drop_down),
            items: items,
            value: value,
            onChanged: (v) {
              onChanged(v);
            },
            underline: SizedBox(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          );
  }
}
