import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomText.dart';

class AccountSuccessView extends StatelessWidget {
  const AccountSuccessView({super.key});

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
              SizedBox(height: 20.h),
              CustomButton(
                text: "Sign In",
                onPressed: () {
                  Get.toNamed(Routes.signinView);
                },
                backgroundColor: Colors.black,
                textColor: Colors.white,
                borderColor: AppColors.black200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
