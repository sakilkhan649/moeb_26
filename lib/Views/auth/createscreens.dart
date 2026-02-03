import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomText.dart';
import '../../widgets/CustomTextGary.dart';

class Createscreens extends StatelessWidget {
  const Createscreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                // The logo (use an image asset or network image)
                Container(
                  width: 150.w,
                  height: 70.w,
                  child: Image.asset(
                    AppImages.final_app_logo,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 12.h),
                // Title Text
                CustomText(text: "Elite Chauffeur Network"),
                SizedBox(height: 11.h),
                // Subtitle Text
                CustomTextgray(text: "Where Excellence Connects",fontSize: 16.sp,),
                SizedBox(height: 240.h),
                // Dots for the indicator (if needed)
                CustomButton(
                  text: "Create Account",
                  onPressed: () {
                    Get.toNamed(Routes.createaccountscreen);
                  },
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: "Sign In",
                  onPressed: () {
                    Get.toNamed(Routes.signscreen);
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
