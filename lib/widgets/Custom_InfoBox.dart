import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInfoBox extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;

  const CustomInfoBox({
    Key? key,
    required this.text,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Color(0xFF2A2A2A)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.orange,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}