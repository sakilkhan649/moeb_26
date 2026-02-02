import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'CustomText.dart';

class RideProgressCard extends StatelessWidget {
  final String title;
  final String statusLabel;
  final String statusValue;
  final String iconPath;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? titleFontSize;
  final double? labelFontSize;
  final double? valueFontSize;
  final double? iconSize;
  final double? borderRadius;
  final double? padding;

  const RideProgressCard({
    Key? key,
    required this.title,
    required this.statusLabel,
    required this.statusValue,
    required this.iconPath,
    this.backgroundColor = const Color(0xFF1C1C1C),
    this.borderColor = const Color(0xFF2A2A2A),
    this.titleFontSize,
    this.labelFontSize,
    this.valueFontSize,
    this.iconSize,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 10.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        border: Border.all(color: borderColor!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: titleFontSize ?? 15.sp,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: iconSize ?? 20.w,
                height: iconSize ?? 20.h,
              ),
              SizedBox(width: 10.w),
              CustomText(
                text: statusLabel,
                fontSize: labelFontSize ?? 13.sp,
              ),
              CustomText(
                text: statusValue,
                fontSize: valueFontSize ?? 15.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}