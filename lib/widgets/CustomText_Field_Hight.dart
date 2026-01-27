import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_colors.dart';

class CustomtextFieldHight extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final String? Function(String?)? validator;

  const CustomtextFieldHight({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,  // Fixed height of 80px
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        validator: validator,
        style: TextStyle(color: Colors.white),
        maxLines: 5,  // Max lines the field can expand to
        minLines: 1,  // Min lines
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray100),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h, // Adjust padding to match the height
            horizontal: 10.w,
          ), // Vertical padding for adjusting text field height
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.black200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.black200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.black200),
          ),
        ),
      ),
    );
  }
}
