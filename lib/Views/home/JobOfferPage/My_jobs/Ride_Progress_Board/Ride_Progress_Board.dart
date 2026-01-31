import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import '../../../../../Core/routs.dart';
import '../../../../../Utils/app_icons.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/Custom_AppBar.dart';
import '../../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../../widgets/Custom_Driver_Card.dart';
import '../../../../../widgets/RideProgressCard.dart';

class RideProgressBoard extends StatelessWidget {
  RideProgressBoard({super.key});

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
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.rideCompleteJob);
                    },
                    child: RideProgressCard(
                      title: "Ride Progress",
                      statusLabel: "Current Status : ",
                      statusValue: "Passenger On Board",
                      iconPath: AppIcons.current_icon,
                    ),
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

                SizedBox(height: 80.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
