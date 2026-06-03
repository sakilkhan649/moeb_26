import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import '../../../../core/widgets/CustomButton.dart';
import '../../../../core/widgets/CustomText.dart';
import '../../../../core/widgets/CustomTextGary.dart';

class AuthSelectionView extends StatelessWidget {
  const AuthSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The logo (use an image asset or network image)
                SizedBox(
                  width: 150.w,
                  height: 70.w,
                  child: Image.asset(AppImages.app_logo, fit: BoxFit.fill),
                ),
                SizedBox(height: 12.h),
                // Title Text
                CustomText(text: "Elite Chauffeur Network"),
                SizedBox(height: 11.h),
                // Subtitle Text
                CustomTextgray(
                  text: "Where Excellence Connects",
                  fontSize: 16.sp,
                ),
                SizedBox(height: 240.h),
                // Dots for the indicator (if needed)
                CustomButton(
                  text: "Create Account",
                  onPressed: () {
                    Get.toNamed(Routes.createaccountview);
                  },
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: "Sign In",
                  onPressed: () {
                    Get.toNamed(Routes.signinView);
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  borderColor: AppColors.black200,
                ),
                SizedBox(height: 20.h),
                // Subtitle Text
                GestureDetector(
                  onTap: () {},
                  child: CustomTextgray(
                    text:
                        "By continuing, you agree to our Terms & Privacy Policy",
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
