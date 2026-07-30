import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInfoBox extends StatelessWidget {
  final String text;
  final String? title;
  final EdgeInsetsGeometry? padding;

  const CustomInfoBox({
    super.key,
    required this.text,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFF2C2C2C),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "Special Instructions",
              style: GoogleFonts.inter(
                color: const Color(0xFFA1A1A1),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              text,
              style: GoogleFonts.inter(
                color: const Color(0xFFFEDB9B),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}