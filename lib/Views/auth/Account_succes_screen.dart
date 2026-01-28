import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/widgets/CustomText.dart';

class AccountSuccesScreen extends StatelessWidget {
  const AccountSuccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppIcons.succes_icon, width: 200.w, height: 200.w),
              CustomText(
                text: "“Your account has been\n  created successfully.”",
                fontSize: 26.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
