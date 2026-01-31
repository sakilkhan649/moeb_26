import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'Controller/Ride_Complete_job.dart';

class RideCompleteJob extends StatelessWidget {
  RideCompleteJob({super.key});

  final RideCompleteJobController controller = Get.put(
    RideCompleteJobController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                    color: Colors.white.withOpacity(0.4),
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
                  color: Color(0xFFE3FCEF), // Light green background
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: const Color(0xFF00A854), // Solid green check
                  size: 50.sp,
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
                "Rate Your Driver",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 40.h),
              // Rating Stars
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    bool isSelected = index < controller.rating.value;
                    return GestureDetector(
                      onTap: () => controller.updateRating(index + 1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          isSelected ? Icons.star : Icons.star_border_outlined,
                          color: isSelected
                              ? AppColors.orange100
                              : Colors.white.withOpacity(0.4),
                          size: 44.sp,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 48.h),
              // Feedback Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Share your experience (optional)",
                  style: GoogleFonts.inter(
                    color: Colors.white,
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
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: controller.feedbackController,
                  maxLines: 5,
                  onChanged: (val) => controller.feedback.value = val,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "What did you like or dislike about working with this driver?",
                    hintStyle: GoogleFonts.inter(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // Character Count
              Obx(
                () => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${controller.feedback.value.length}/500 characters",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.2),
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
                  // Doing nothing as per requested "kichu hobe na"
                },
              ),
              SizedBox(height: 16.h),
              // Skip Button
              CustomButton(
                text: "Skip",
                backgroundColor: Colors.transparent,
                textColor: AppColors.orange100,
                borderColor: Colors.white.withOpacity(0.4),
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
