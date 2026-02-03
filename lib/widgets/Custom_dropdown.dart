import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: GoogleFonts.inter(
            color: AppColors.gray100,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        value: (value == null || value!.isEmpty) ? null : value,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.black200),
            color: Colors.transparent,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 24.sp,
            color: AppColors.gray100,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(40.r),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
        ),
        selectedItemBuilder: (context) {
          return items.map((String item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
