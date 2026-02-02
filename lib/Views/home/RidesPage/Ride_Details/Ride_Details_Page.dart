import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import 'package:moeb_26/widgets/Custom_Back_Button.dart';
import 'package:moeb_26/widgets/Custom_InfoBox.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../widgets/Custom_Driver_Card.dart';

class RideDetailsPage extends StatelessWidget {
  const RideDetailsPage({super.key});

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
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: CustomBackButton(title: "Ride Details"),
            ),
            Divider(color: Colors.white38, thickness: 1.h),
            SizedBox(height: 5.h),
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
                SizedBox(height: 10.h),

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
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomTextgray(text: "Special Instructions"),
                ),
                SizedBox(height: 10.h),
                CustomInfoBox(
                  text: "Bona nit. Flight AA 1234, VIP client, suit required",
                ),
                SizedBox(height: 10.h),

                Divider(color: Colors.white38, thickness: 1.h),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomButton(
                    text: "On My Way",
                    backgroundColor: AppColors.orange100,
                    textColor: Colors.white,
                    onPressed: () {
                      Get.toNamed(Routes.onMyWayDetailsPage);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomButton(
                    text: "Back to Jobs",
                    backgroundColor: Color(0xFF1C1C1C),
                    borderColor: Color(0xFF2A2A2A),
                    textColor: Colors.white,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
