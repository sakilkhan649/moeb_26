import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/my_jobs_model.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import '../../../../../Core/routs.dart';
import '../../../../../Ripositoryes/socket_repository.dart';
import '../../../../../Utils/app_icons.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/Custom_AppBar.dart';
import '../../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../../widgets/Custom_Driver_Card.dart';
import '../../../../../widgets/RideProgressCard.dart';
import '../Controller/My_job_controller.dart';

class RideProgressWayLocation extends StatefulWidget {
  const RideProgressWayLocation({super.key});

  @override
  State<RideProgressWayLocation> createState() =>
      _RideProgressWayLocationState();
}

class _RideProgressWayLocationState extends State<RideProgressWayLocation> {
  final BookingController controller = Get.find<BookingController>();
  JobData? initialJob;
  String? jobId;

  @override
  void initState() {
    super.initState();
    initialJob = Get.arguments as JobData?;
    jobId = initialJob?.id;
    // Initialize with the job data we already have
    controller.myJobView.value = initialJob;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshJob();
    });
  }

  Future<void> _refreshJob() async {
    if (jobId == null) {
      debugPrint("⚠️ RideProgressWayLocation: jobId is null, cannot refresh");
      return;
    }
    debugPrint("🔄 RideProgressWayLocation: Refreshing job details for jobId: $jobId");
    try {
      await controller.fetchJobDetails(jobId: jobId!);
      debugPrint("✨ RideProgressWayLocation: Refresh completed");
    } catch (e) {
      debugPrint("❌ RideProgressWayLocation: Refresh failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: RefreshIndicator(
        color: AppColors.orange100,
        onRefresh: () async {
          await _refreshJob();
        },
        child: Obx(() {
          final job = controller.myJobView.value;

          if (job == null && (controller.viewLoading[jobId ?? ""] ?? false)) {
            return const Center(child: CircularProgressIndicator());
          }

          // Format date and time
          String displayDateTime = "N/A";
          if (job?.asap == true) {
            displayDateTime = "ASAP";
          } else {
            String dateStr = "";
            if (job?.date != null && job?.date != "null" && job!.date!.isNotEmpty) {
              try {
                DateTime parsedDate = DateTime.parse(job!.date!);
                dateStr = DateFormat('EEE MMM dd').format(parsedDate);
              } catch (_) {
                dateStr = job!.date!;
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
                timeStr =
                    "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
              } catch (_) {}
            }
            displayDateTime = dateStr.isNotEmpty ? "$dateStr . $timeStr" : timeStr;
          }

          final driver = job?.assignedTo;
          final vehicle =
              (driver?.vehicles != null && driver!.vehicles!.isNotEmpty)
              ? driver.vehicles!.first
              : null;
          final vehicleInfo = vehicle != null
              ? "${vehicle.make} ${vehicle.model}, ${vehicle.colorOutside}"
              : job?.vehicleType ?? "N/A";

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomDriverCard(
                        profileImage:
                            driver?.profilePicture ?? AppImages.profile_image,
                        name: driver?.name ?? "No Driver",
                        rating: "${driver?.averageRating ?? 0.0}",
                        vehicleNumber: vehicle?.licensePlate ?? "N/A",
                        vehicleInfo: vehicleInfo,
                        buttonText: "Chat with Driver",
                        buttonIcon: Icons.chat_bubble_outline,
                        onButtonPressed: () async {
                          final String? participantId =
                              job?.assignedTo?.id ?? job?.applicant?.driver?.id;
                          if (participantId != null && job?.id != null) {
                            try {
                              final chat = await Get.find<SocketRepository>()
                                  .createChat(participantId, job!.id!);
                              if (chat != null) {
                                Get.toNamed(
                                  Routes.chatDetailPage,
                                  arguments: chat,
                                );
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: RideProgressCard(
                        title: "Ride Progress",
                        statusLabel: "Current Status : ",
                        statusValue: (job?.rideStatus ?? "N/A").toUpperCase(),
                        iconPath: AppIcons.current_icon,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Status Steps Container
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    SizedBox(height: 16.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Builder(
                        builder: (context) {
                          final status = job?.status?.toUpperCase() ?? "";
                          final rideStatus =
                              job?.rideStatus?.toUpperCase() ?? "";

                          if (rideStatus == "FINISHED" ||
                              status == "COMPLETED") {
                            // Ride is either in final stage or finished, show Review button
                            return CustomButton(
                              text: "Review Driver",
                              backgroundColor: AppColors.orange100,
                              textColor: Colors.black,
                              onPressed: () {
                                Get.toNamed(
                                  Routes.rideCompletedPage,
                                  arguments: job,
                                );
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
          );
        }),
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
