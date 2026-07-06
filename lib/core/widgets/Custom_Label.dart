import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CustomText.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const CustomLabel({super.key, required this.text, this.isRequired = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(text: text, fontWeight: FontWeight.w500, fontSize: 14.sp),
        if (isRequired)
          Text(
            " *",
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          ),
      ],
    );
  }
}
