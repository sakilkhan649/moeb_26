import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Data/models/finish_rides_model.dart';
import 'package:moeb_26/Data/models/upcoming_rides_model.dart';
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
    final dynamic ride = Get.arguments;

    // Format date and time
    String displayDateTime = "N/A";
    String? rideId;
    String? participantId;
    String? driverName;
    String? driverImage;
    String? vehicleType;
    String? pickupLocation;
    String? dropoffLocation;
    String? paymentType;
    String? amount;

    if (ride is Ride) {
      rideId = ride.id;
      participantId = ride.assignedTo?.id ?? ride.applicant?.driver?.id ?? ride.createdBy?.id;
      driverName = ride.applicant?.driver?.name ?? "Unknown";
      driverImage = ride.applicant?.driver?.profilePicture;
      vehicleType = ride.vehicleType;
      pickupLocation = ride.pickupLocation;
      dropoffLocation = ride.dropoffLocation;
      paymentType = ride.paymentType;
      amount = "\$${ride.paymentAmount}";
      if (ride.date != null) {
        displayDateTime = "${DateFormat('MMM dd').format(ride.date!)} · ${ride.time}";
      } else {
        displayDateTime = ride.time;
      }
    } else if (ride is UpcomingRideData || ride is FinishRideData) {
      final dynamic r = ride;
      rideId = r.id;
      participantId = r.createdBy?.id ?? r.assignedTo;
      driverName = r.createdBy?.name ?? "Unknown";
      driverImage = r.createdBy?.profilePicture;
      vehicleType = r.vehicleType;
      pickupLocation = r.pickupLocation;
      dropoffLocation = r.dropoffLocation;
      paymentType = r.paymentType;
      amount = "\$${r.paymentAmount}";
      if (r.date != null) {
        try {
          DateTime parsed = DateTime.parse(r.date!);
          displayDateTime = "${DateFormat('MMM dd').format(parsed)} · ${r.time}";
        } catch (_) {
          displayDateTime = "${r.date} · ${r.time}";
        }
      } else {
        displayDateTime = r.time ?? "N/A";
      }
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
                    profileImage: driverImage ?? AppImages.profile_image,
                    name: driverName ?? "Unknown",
                    rating: "5.0",
                    vehicleNumber: "N/A",
                    vehicleInfo: vehicleType ?? "N/A",
                    buttonText: "Chat with Driver",
                    buttonIcon: Icons.chat_bubble_outline,
                    onButtonPressed: () async {
                      if (participantId != null && rideId != null) {
                        try {
                          final chat = await Get.find<SocketRepository>().createChat(
                            participantId,
                            rideId,
                          );
                          if (chat != null) {
                            Get.toNamed(Routes.chatDetailPage, arguments: chat);
                          }
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Failed to open chat",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
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
                    pickupLocation: pickupLocation ?? "N/A",
                    dropoffLocation: dropoffLocation ?? "N/A",

                    // Job information
                    flightNumber: "N/A",
                    dateTime: displayDateTime,
                    vehicleType: vehicleType ?? "N/A",
                    jobPoster: driverName ?? "Unknown",
                    company: driverName ?? "Unknown",
                    payment: paymentType ?? "N/A",
                    amount: amount ?? "N/A",

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
