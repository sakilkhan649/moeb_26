import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import 'package:moeb_26/widgets/Custom_Back_Button.dart';
import 'package:moeb_26/widgets/Custom_InfoBox.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_icons.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../widgets/Custom_Driver_Card.dart';

class FinishRidePage extends StatelessWidget {
  const FinishRidePage({super.key});

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
            Divider(color: Colors.white38, thickness: 1.h),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: CustomBackButton(title: "Ride Details"),
            ),
            SizedBox(height: 10.h),
            Divider(color: Colors.white38, thickness: 1.h),
            SizedBox(height: 10.h),
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
                      // আপনার custom action
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
                  child: CustomTextgray(text: "Special Instructions"),
                ),
                SizedBox(height: 10.h),
                CustomInfoBox(
                  text: "Bona nit. Flight AA 1234, VIP client, suit required",
                ),
                SizedBox(height: 10.h),

                SizedBox(height: 10.h),
                Divider(color: Colors.white38, thickness: 1.h),
                SizedBox(height: 10.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.rideCompletedPage);
                    },
                    child: Row(
                      children: [
                        // Circular Action Button
                        Container(
                          width: 60.w,
                          height: 60.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.orange100,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AppIcons.arre_right_icon,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Pill-shaped Finish Label
                        Expanded(
                          child: Container(
                            height: 60.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: CustomText(
                              text: "Finish ride",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
}
