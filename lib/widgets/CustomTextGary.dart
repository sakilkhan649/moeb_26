
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/app_colors.dart';


class CustomTextgray extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  const CustomTextgray({
    super.key,
    required this.text,
    this.textAlign,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = GoogleFonts.inter(
      color: color ?? AppColors.gray100,
      fontSize: fontSize ?? 13,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: textStyle ?? baseStyle.copyWith(
        fontFamily: fontFamily ?? 'Inter',  // Default to 'Inter', or use custom font
      ),
    );
  }
}
