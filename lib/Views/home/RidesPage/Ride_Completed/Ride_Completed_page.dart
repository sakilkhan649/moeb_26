import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'Controller/Ride_Completed_controller.dart';

class RideCompletedPage extends StatelessWidget {
  RideCompletedPage({super.key});

  final RideCompletedController controller = Get.put(RideCompletedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[700],
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Success Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: const Color(0xFF4CAF50),
                  size: 60.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Title
              Text(
                "Ride Completed",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Text(
                "Airport Transfer - JFK to Manhattan",
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 40.h),
              // Rating Stars
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => controller.updateRating(index + 1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          index < controller.rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: index < controller.rating.value
                              ? AppColors.orange100
                              : Colors.white,
                          size: 48.sp,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 40.h),
              // Feedback Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Share your experience (optional)",
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Feedback Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: controller.feedbackController,
                  maxLines: 4,
                  onChanged: (val) => controller.feedback.value = val,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "What did you like or dislike about working with this driver?",
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Character Count
              Obx(
                () => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${controller.feedback.value.length}/500 characters",
                    style: GoogleFonts.inter(
                      color: Colors.grey[800],
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              // Submit Button
              CustomButton(
                text: "Submit Review",
                backgroundColor: AppColors.orange100,
                textColor: Colors.white,
                onPressed: () {
                  controller.submitReview();
                },
              ),
              SizedBox(height: 12.h),
              // Skip Button
              CustomButton(
                text: "Skip",
                backgroundColor: Color(0xFF2A2A2A),
                textColor: Color(0xFFD08700),
                borderColor: Color(0xFF364153),
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
