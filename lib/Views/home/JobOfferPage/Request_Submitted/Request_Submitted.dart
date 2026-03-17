import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';

import '../../../../Utils/app_icons.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';

/// Review Status Screen
/// Shows application submission status with animated steps
class RequestSubmitted extends StatelessWidget {
  const RequestSubmitted({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the job data from arguments
    final job = Get.arguments;

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
                color: Color(0xFF1C1C1C),
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
                text: "Request Submitted",
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
                  color: Color(0xFFF2F2F2),
                ),
              ),
              SizedBox(height: 30.h),

              // Status Steps Container
              Builder(
                builder: (context) {
                  String displayDateTime = "ASAP";
                  if (job?.asap == true) {
                    displayDateTime = "ASAP";
                  } else {
                    String dateStr = "";
                    if (job?.date != null) {
                      try {
                        DateTime parsed;
                        if (job!.date is DateTime) {
                          parsed = job!.date;
                        } else {
                          parsed = DateTime.parse(job!.date.toString());
                        }
                        dateStr = DateFormat('EEE MMM dd').format(parsed);
                      } catch (_) {
                        dateStr = job!.date.toString();
                      }
                    }

                    String timeStr = job?.time ?? "";
                    if (timeStr.contains(':')) {
                      try {
                        final parts = timeStr.split(':');
                        int hour = int.parse(parts[0]);
                        int minute = int.parse(parts[1].split(' ')[0]);
                        final period = hour >= 12 ? "PM" : "AM";
                        final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                        timeStr = "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
                      } catch (_) {}
                    }
                    displayDateTime = dateStr.isNotEmpty ? "$dateStr . $timeStr" : timeStr;
                  }

                  return CustomJobDetailsCard(
                    // Location details
                    pickupLocation: job?.pickupLocation ?? "Unknown",
                    dropoffLocation: job?.dropoffLocation ?? "N/A",

                    // Job information
                    flightNumber: job?.flightNumber ?? "N/A",
                    dateTime: displayDateTime,
                    vehicleType: job?.vehicleType ?? "Unknown",
                    jobPoster: job?.createdBy?.name ?? "Unknown",
                    company: job?.createdBy?.name ?? "Unknown",
                    payment: job?.paymentType ?? "Unknown",
                    amount: "\$${job?.paymentAmount ?? 0}",

                    // Optional: Custom colors
                    backgroundColor: const Color(0xFF1C1C1C),
                    borderColor: const Color(0xFF2A2A2A),
                    labelColor: Colors.grey,
                    valueColor: Colors.white,
                    iconColor: Colors.grey,
                  );
                },
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
