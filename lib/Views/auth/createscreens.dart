import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
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
                Image.asset(AppImages.app_logo, width: 100.w, height: 100.h),
                SizedBox(height: 30.h),
                // Title Text
                CustomText(text: "Elite Chauffeur"),
                CustomText(text: "Network"),
                SizedBox(height: 11.h),
                // Subtitle Text
                CustomTextgray(text: "Where Excellence Connects"),
                SizedBox(height: 200.h),
                // Dots for the indicator (if needed)
                CustomButton(
                  text: "Create Account",
                  onPressed: () {
                    Get.toNamed(Routes.createaccountscreen);
                  },
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: "Sign In",
                  onPressed: () {
                    Get.toNamed(Routes.signscreen);
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  borderColor: Colors.white,
                ),
                SizedBox(height: 15.h),
                // Subtitle Text
                GestureDetector(
                  onTap: () {},
                  child: CustomTextgray(
                    text:
                        "By continuing, you agree to our Terms & Privacy Policy",
                    fontSize: 12,
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
