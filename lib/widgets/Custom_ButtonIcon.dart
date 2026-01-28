import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonIcon extends StatelessWidget {
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
  final IconData? icon; // For regular icons
  final Widget? iconWidget; // For SVG or custom widgets
  final double? iconSize;
  final Color? iconColor;
  final bool iconOnRight;
  final double? iconSpacing;

  const CustomButtonIcon({
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
    this.icon,
    this.iconWidget, // New parameter for SVG
    this.iconSize,
    this.iconColor,
    this.iconOnRight = false,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which icon to use
    Widget? displayIcon;
    if (iconWidget != null) {
      displayIcon = iconWidget;
    } else if (icon != null) {
      displayIcon = Icon(
        icon,
        size: iconSize ?? 20.sp,
        color: iconColor ?? textColor ?? Colors.black,
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? Colors.black,
          elevation: 0,
          padding: padding ?? EdgeInsets.symmetric(vertical: 17.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: displayIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconOnRight
                    ? [
                        // Text first, then icon
                        Text(
                          text,
                          style:
                              style ??
                              GoogleFonts.inter(
                                fontSize: fontSize ?? 16.sp,
                                fontWeight: fontWeight ?? FontWeight.bold,
                                color: textColor ?? Colors.black,
                              ),
                        ),
                        SizedBox(width: iconSpacing ?? 8.w),
                        displayIcon,
                      ]
                    : [
                        // Icon first, then text
                        displayIcon,
                        SizedBox(width: iconSpacing ?? 8.w),
                        Text(
                          text,
                          style:
                              style ??
                              GoogleFonts.inter(
                                fontSize: fontSize ?? 16.sp,
                                fontWeight: fontWeight ?? FontWeight.bold,
                                color: textColor ?? Colors.black,
                              ),
                        ),
                      ],
              )
            : Text(
                text,
                style:
                    style ??
                    GoogleFonts.inter(
                      fontSize: fontSize ?? 16.sp,
                      fontWeight: fontWeight ?? FontWeight.bold,
                      color: textColor ?? Colors.black,
                    ),
              ),
      ),
    );
  }
}
