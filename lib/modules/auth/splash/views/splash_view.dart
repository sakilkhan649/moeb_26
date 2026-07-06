import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  // Initialize the GetX controller
  final controller = Get.find<SplashScreenController>();
  // Start the timer as soon as the splash screen is loaded

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The logo (use an image asset or network image)
            SizedBox(
              width: 320.w,
              height: 320.w,
              child: Image.asset(
                "assets/images/auth_select_page_logo.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.h),
            // Dots for the indicator (if needed)
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3, // number of dots
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 8.w,
                    height: 8.w,
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
