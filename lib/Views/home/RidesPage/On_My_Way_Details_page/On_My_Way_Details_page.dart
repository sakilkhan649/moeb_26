import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import 'package:moeb_26/widgets/Custom_Back_Button.dart';
import 'package:moeb_26/widgets/Custom_InfoBox.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_images.dart';
import '../../../../Ripositoryes/socket_repository.dart';
import '../../../../widgets/Custom_AppBar.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../widgets/Custom_Driver_Card.dart';

class OnMyWayDetailsPage extends StatelessWidget {
  const OnMyWayDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the ride data passed from the previous screen
    final Ride? ride = Get.arguments as Ride?;

    // Format date and time
    String displayDateTime = "N/A";
    if (ride?.date != null) {
      displayDateTime = "${DateFormat('MMM dd').format(ride!.date!)} · ${ride.time}";
    } else if (ride != null) {
      displayDateTime = ride.time;
    }

    return Scaffold(
      appBar: const CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomDriverCard(
                    profileImage: ride?.applicant?.driver?.profilePicture ?? AppImages.profile_image,
                    name: ride?.applicant?.driver?.name ?? "Unknown",
                    rating: "5.0",
                    vehicleNumber: "N/A",
                    vehicleInfo: ride?.vehicleType ?? "N/A",
                    buttonText: "Chat with Driver",
                    buttonIcon: Icons.chat_bubble_outline,
                    onButtonPressed: () async {
                      if (ride?.applicant?.driver?.id != null && ride?.id != null) {
                        final chat = await Get.find<SocketRepository>().createChat(
                          ride!.applicant!.driver!.id,
                          ride.id,
                        );
                        if (chat != null) {
                          Get.toNamed(Routes.chatDetailPage, arguments: chat);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                // Status Steps Container
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomJobDetailsCard(
                    // Location details
                    pickupLocation: ride?.pickupLocation ?? "N/A",
                    dropoffLocation: ride?.dropoffLocation ?? "N/A",

                    // Job information
                    flightNumber: "N/A",
                    dateTime: displayDateTime,
                    vehicleType: ride?.vehicleType ?? "N/A",
                    jobPoster: ride?.applicant?.driver?.name ?? "Unknown",
                    company: ride?.applicant?.driver?.name ?? "Unknown",
                    payment: ride?.paymentType ?? "N/A",
                    amount: ride != null ? "\$${ride.paymentAmount}" : "N/A",

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
                  text: "N/A",
                ),
                SizedBox(height: 10.h),

                Divider(color: Colors.white38, thickness: 1.h),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomButton(
                    text: "At the Location",
                    backgroundColor: AppColors.orange100,
                    textColor: Colors.white,
                    onPressed: () {
                      Get.toNamed(Routes.pobDetailsPage, arguments: ride);
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
