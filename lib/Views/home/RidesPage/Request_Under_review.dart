import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';

import '../../../../Utils/app_icons.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';
import '../../../Core/routs.dart';

/// Review Status Screen
/// Shows application submission status with animated steps
class RequestUnderReview extends StatelessWidget {
  const RequestUnderReview({super.key});

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.cross_icon,
                height: 20.w,
                width: 20.w,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // Clock Icon with pulse animation
              _buildClockIcon(),

              SizedBox(height: 30.h),

              // Title
              CustomText(
                text: "Request Under review",
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 16.h),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomTextgray(
                  text:
                      "Your application is currently under review by the job poster. Once they approve it, you will receive a notification and will be able to proceed with this ride.",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              SizedBox(height: 30.h),

              // Status Steps Container
              if (ride != null)
                GestureDetector(
                  onTap: () {
                    // Handle tap on the card
                    Get.toNamed(Routes.rideDetailsPage, arguments: ride);
                  },
                  child: CustomJobDetailsCard(
                    // Location details
                    pickupLocation: ride.pickupLocation,
                    dropoffLocation: ride.dropoffLocation,

                    // Job information
                    flightNumber: "N/A", // Not available in Ride model
                    dateTime: displayDateTime,
                    vehicleType: ride.vehicleType,
                    jobPoster: ride.applicant?.driver?.name ?? "Unknown",
                    company: ride.applicant?.driver?.name ?? "Unknown", // Assuming company name is driver name for now
                    payment: ride.paymentType,
                    amount: "\$${ride.paymentAmount}",

                    // Optional: Custom colors
                    backgroundColor: const Color(0xFF1C1C1C),
                    borderColor: const Color(0xFF2A2A2A),
                    labelColor: Colors.grey,
                    valueColor: Colors.white,
                    iconColor: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds clock icon with circular background
  Widget _buildClockIcon() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: Color(0xFF413A3A),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.access_time_rounded, color: Colors.white, size: 50.sp),
    );
  }
}
