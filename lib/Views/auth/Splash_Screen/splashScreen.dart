import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/app_images.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import 'controller/splashcontroller.dart';

class Splashscreen extends StatelessWidget {
  Splashscreen({super.key});
  // Initialize the GetX Controller
  final SplashScreenController controller = Get.put(SplashScreenController());

  // Start the timer as soon as the splash screen is loaded

  @override
  Widget build(BuildContext context) {
    controller.startTimer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The logo (use an image asset or network image)
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5.w,
                  ),
                ),
                width: 100.w,
                height: 100.w,
                child: Image.asset(
                  AppImages.final_app_logo,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Title Text
            CustomText(text: "Elite Chauffeur Network"),
            SizedBox(height: 10.h),
            // Subtitle Text
            CustomTextgray(text: "Where Excellence Connects"),
            SizedBox(height: 20.h),
            // Dots for the indicator (if needed)
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3, // number of dots
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 15.w,
                    height: 15.h,
                    decoration: BoxDecoration(
                      color: index == controller.currentIndex.value
                          ? Colors.white
                          : AppColors
                                .gray100, // Change color based on current index
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
