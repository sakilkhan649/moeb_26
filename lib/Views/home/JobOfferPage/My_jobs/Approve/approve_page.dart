import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import '../../../../../Core/routs.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/Custom_AppBar.dart';
import '../../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../../widgets/Custom_Driver_Card.dart';


class ApprovePage extends StatelessWidget {
  ApprovePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomDriverCard(
                    profileImage: AppImages.profile_image,
                    name: "Khaled",
                    rating: "5.0",
                    vehicleNumber: "ECN-1",
                    vehicleInfo: "BMW 7 Series, Black",
                    buttonText: "Chat with Job Poster",
                    buttonIcon: Icons.chat_bubble_outline, // যেকোনো icon
                    onButtonPressed: () {
                      Get.toNamed(Routes.chatPage);
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                // Status Steps Container (You can use this in your widget tree)
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomJobDetailsCard(
                    // Location details
                    pickupLocation: "Dhaka Airport",
                    dropoffLocation: "Barisal",

                    // Job information
                    flightNumber: "Flight AA 1234",
                    dateTime: "Jan 20 · 08:30 AM",
                    vehicleType: "SEDAN",
                    jobPoster: "Khaled",
                    company: "Khaled Transportation",
                    payment: "Collect",
                    amount: "\$125",

                    // Optional: Custom colors
                    backgroundColor: const Color(0xFF1C1C1C),
                    borderColor: const Color(0xFF2A2A2A),
                    labelColor: Colors.grey,
                    valueColor: Colors.white,
                    iconColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomButton(
                    text: "Cancel Ride",
                    backgroundColor: AppColors.orange100,
                    textColor: Colors.black,
                    onPressed: () {
                      _showDeleteDialog();
                    },
                  ),
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DELETE DIALOG =================
  void _showDeleteDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure to cancel the ride?",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.rideProgressWay);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.orange100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Text(
                            "Yes",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
