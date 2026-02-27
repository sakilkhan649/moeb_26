import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';

import '../../../widgets/CustomText.dart';

class SuccessResetpassword extends StatelessWidget {
  const SuccessResetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
                decoration: BoxDecoration(
                  color: Color(0xFF02180F),
                  border: Border.all(color: Color(0xFF14F195)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.check_mark, color: Color(0xFF14F195)),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: "Password reset successful!",
                      fontSize: 13,
                      color: Color(0xFF14F195),
                    ),
                  ],
                ),

              ),
              SizedBox(height: 23.h),
              CustomTextgray(text: "You can now log in using your new password.")
            ],
          ),
        ),
      ),

    );
  }
}
