import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final double? buttonSize;
  final FontWeight? fontWeight;

  const CustomBackButton({
    Key? key,
    required this.title,
    this.onTap,
    this.buttonColor,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    this.buttonSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: Row(
        children: [
          Container(
            width: buttonSize ?? 40.w,
            height: buttonSize ?? 40.w,
            decoration: BoxDecoration(
              color: buttonColor ?? Color(0xFF1C1C1C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_outlined,
              color: iconColor ?? Colors.white,
              size: iconSize ?? 24.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize ?? 22.sp,
              color: textColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}