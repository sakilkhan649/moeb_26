import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/my_jobs_model.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import '../../../../../Core/routs.dart';
import '../../../../../Utils/app_icons.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/Custom_AppBar.dart';
import '../../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../../widgets/Custom_Driver_Card.dart';
import '../../../../../widgets/RideProgressCard.dart';
import '../Controller/My_job_controller.dart';

class RideProgressWayLocation extends StatelessWidget {
  RideProgressWayLocation({super.key});

  final BookingController controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    // Get the job data passed from the previous screen
    final JobData? job = Get.arguments as JobData?;

    // Format date and time
    String displayDateTime = "N/A";
    if (job?.date != null) {
      try {
        DateTime parsedDate = DateTime.parse(job!.date!);
        displayDateTime = "${DateFormat('MMM dd').format(parsedDate)} · ${job.time}";
      } catch (_) {
        displayDateTime = "${job!.date} · ${job.time}";
      }
    } else if (job != null) {
      displayDateTime = job.time ?? "N/A";
    }

    final driver = job?.assignedTo;
    final vehicle = (driver?.vehicles != null && driver!.vehicles!.isNotEmpty)
        ? driver.vehicles!.first
        : null;
    final vehicleInfo = vehicle != null
        ? "${vehicle.make} ${vehicle.model}, ${vehicle.colorOutside}"
        : job?.vehicleType ?? "N/A";

    return Scaffold(
      appBar: const CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomDriverCard(
                    profileImage: driver?.profilePicture ?? AppImages.profile_image,
                    name: driver?.name ?? "No Driver",
                    rating: "${driver?.averageRating ?? 0.0}",
                    vehicleNumber: vehicle?.licensePlate ?? "N/A",
                    vehicleInfo: vehicleInfo,
                    buttonText: "Chat with Job Poster",
                    buttonIcon: Icons.chat_bubble_outline,
                    onButtonPressed: () {
                      Get.toNamed(Routes.chatPage, arguments: job);
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: RideProgressCard(
                    title: "Ride Progress",
                    statusLabel: "Current Status : ",
                    statusValue: job?.rideStatus ?? "N/A",
                    iconPath: AppIcons.current_icon,
                  ),
                ),
                SizedBox(height: 10.h),

                // Status Steps Container
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomJobDetailsCard(
                    // Location details
                    pickupLocation: job?.pickupLocation ?? "N/A",
                    dropoffLocation: job?.dropoffLocation ?? "N/A",

                    // Job information
                    flightNumber: job?.flightNumber ?? "N/A",
                    dateTime: displayDateTime,
                    vehicleType: job?.vehicleType ?? "N/A",
                    jobPoster: job?.assignedTo?.name ?? "Unknown",
                    company: "N/A",
                    payment: job?.paymentType ?? "N/A",
                    amount: job != null ? "\$${job.paymentAmount}" : "N/A",

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
                  child: Builder(
                    builder: (context) {
                      final status = job?.rideStatus?.toUpperCase() ?? "";
                      
                      if (status == "POB" || status == "FINISHED") {
                        // Ride is either in final stage or finished, show Review button
                        return CustomButton(
                          text: "Review Driver",
                          backgroundColor: AppColors.orange100,
                          textColor: Colors.black,
                          onPressed: () {
                            Get.toNamed(Routes.rideCompletedPage, arguments: job);
                          },
                        );
                      } else {
                        // Ride can still be cancelled
                        return CustomButton(
                          text: "Cancel Ride",
                          backgroundColor: AppColors.orange100,
                          textColor: Colors.black,
                          onPressed: () {
                            if (job?.id != null) {
                              _showDeleteDialog(job!.id!);
                            }
                          },
                        );
                      }
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

  /// ================= DELETE DIALOG =================
  void _showDeleteDialog(String jobId) {
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
                      onTap: () async {
                        Get.back(); // Close dialog
                        await controller.cancelJobOffer(jobId: jobId);
                        Get.back(); // Return to My Jobs page
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
