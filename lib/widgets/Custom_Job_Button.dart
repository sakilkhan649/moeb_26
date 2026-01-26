import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/app_colors.dart';

class CustomJobButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icon; // Added icon parameter

  const CustomJobButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.maxFinite,
    this.style,
    this.padding,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.icon = Icons.add, // Default icon is "+" (add icon)
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppColors.orange100, // Default to orange
          foregroundColor: textColor ?? Colors.white, // Default to white text
          elevation: 0,
          padding:
              padding ??
              EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 24.w,
              ), // Default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align content in the center
          children: [
            Icon(
              icon,
              color: textColor ?? Colors.black, // Icon color
              size: 24.sp, // Set the icon size
            ),
            SizedBox(width: 8.w), // Space between icon and text
            Text(
              text,
              style:
                  style ??
                  GoogleFonts.inter(
                    fontSize:
                        fontSize ?? 16.sp, // Default font size with scaling
                    fontWeight:
                        fontWeight ?? FontWeight.bold, // Default to bold weight
                    color:
                        textColor ??
                        Colors.black, // Default to white text color
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
