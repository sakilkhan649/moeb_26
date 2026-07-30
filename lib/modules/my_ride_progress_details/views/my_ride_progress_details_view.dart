import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/models/finish_rides_model.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Data/models/upcoming_rides_model.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomText.dart';
import 'package:moeb_26/core/widgets/Custom_InfoBox.dart';
import '../../../core/widgets/Custom_Card_Ditails.dart';
import '../controllers/my_ride_progress_details_controller.dart';

class MyRideProgressDetailsView extends StatelessWidget {
  MyRideProgressDetailsView({super.key});

  final MyRideProgressDetailsController controller = Get.put(
    MyRideProgressDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    // Get the ride data passed from the previous screen (could be Ride, UpcomingRideData, or FinishRideData)
    final dynamic ride = Get.arguments;

    if (ride == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'Ride Details',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: const Center(
          child: Text(
            "No ride details found",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Extract all ride properties cleanly using helper class
    final data = _RideDetailsData.fromRide(ride);

    // Set initial status to controller (with ID to prevent stale overwrites)
    String initialRideStatus = "PENDING";
    if (ride is UpcomingRideData || ride is FinishRideData) {
      initialRideStatus = ride.rideStatus ?? "PENDING";
    } else if (ride is Ride) {
      initialRideStatus = ride.rideStatus ?? "PENDING";
    }
    controller.setInitialStatus(data.id, initialRideStatus);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Ride Details',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRideProgressTracker(),
                  SizedBox(height: 6.h),
                  _buildDriverSection(data),
                  SizedBox(height: 12.h),
                  _buildJobDetailsSection(data),
                  SizedBox(height: 12.h),
                  _buildSpecialInstructionsSection(data),
                  SizedBox(height: 12.h),
                  _buildActionButtonsSection(data, ride),
                  SizedBox(height: 20.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSection(_RideDetailsData data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: data.posterImage.startsWith('http')
                ? NetworkImage(data.posterImage)
                : AssetImage(data.posterImage) as ImageProvider,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.posterName,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Job Poster",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFFA1A1A1),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              if (data.participantId.isNotEmpty && data.id.isNotEmpty) {
                try {
                  final chat = await Get.find<SocketRepository>().createChat(
                    data.participantId,
                    data.id,
                  );
                  if (chat != null) {
                    Get.toNamed(Routes.chatDetailView, arguments: chat);
                  }
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to open chat",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFEF4444),
                    colorText: Colors.white,
                  );
                }
              }
            },
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.orange100.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orange100),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.orange100,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsSection(_RideDetailsData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: CustomJobDetailsCard(
        pickupLocation: data.pickupLocation,
        dropoffLocation: data.dropoffLocation,
        flightNumber: data.flightNumber,
        dateTime: data.displayDateTime,
        vehicleType: data.vehicleType,
        jobPoster: data.posterName,
        company: data.posterCompany,
        payment: data.paymentType,
        amount: data.amount,
        backgroundColor: const Color(0xFF1A1A1A),
        borderColor: const Color(0xFF2C2C2C),
        labelColor: const Color(0xFFA1A1A1),
        valueColor: Colors.white,
        iconColor: Colors.white70,
        amountColor: const Color(0xFFFEDB9B),
      ),
    );
  }

  Widget _buildSpecialInstructionsSection(_RideDetailsData data) {
    if (data.instruction.trim().isEmpty) return const SizedBox.shrink();
    return CustomInfoBox(
      text: data.instruction,
      title: "Special Instructions",
      padding: EdgeInsets.symmetric(horizontal: 14.w),
    );
  }

  Widget _buildActionButtonsSection(_RideDetailsData data, dynamic ride) {
    return Obx(() {
      String status = controller.currentRideStatus.value;

      if (status == "POB") {
        // --- FINISH RIDE DRAGGABLE SECTION ---
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Draggable<String>(
                data: 'finish',
                axis: Axis.horizontal,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: const BoxDecoration(
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
                ),
                childWhenDragging: SvgPicture.asset(
                  AppIcons.arre_right_icon,
                  // ignore: deprecated_member_use
                  color: Colors.transparent,
                ),
                child: GestureDetector(
                  onTap: () {
                    controller.updateStatus(
                      data.id,
                      "FINISHED",
                      rideData: ride,
                    );
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: const BoxDecoration(
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
                ),
              ),
              SizedBox(width: 12.w),
              Row(
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                  Transform.translate(
                    offset: Offset(-8.w, 0),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFF6B6B6B),
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    if (details.data == 'finish') {
                      controller.updateStatus(
                        data.id,
                        "FINISHED",
                        rideData: ride,
                      );
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    bool isOver = candidateData.isNotEmpty;
                    return GestureDetector(
                      onTap: () {
                        controller.updateStatus(
                          data.id,
                          "FINISHED",
                          rideData: ride,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 60.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isOver
                              ? const Color(0xFFE1C16E)
                              : const Color(0xFF2A2A32),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: CustomText(
                          text: "Finish ride",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }

      // --- STEP BUTTONS (On My Way, At Location, POB) ---
      String buttonText = "On My Way";
      String nextStatus = "ON THE WAY";
      bool isVisible = true;

      if (status == "ON THE WAY") {
        buttonText = "At the Location";
        nextStatus = "AT THE LOCATION";
      } else if (status == "AT THE LOCATION") {
        buttonText = "POB";
        nextStatus = "POB";
      } else if (status != "PENDING" && status != "") {
        isVisible = false;
      }

      if (!isVisible) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.orange100),
              )
            : CustomButton(
                text: buttonText,
                backgroundColor: AppColors.orange100,
                textColor: Colors.black,
                onPressed: () => controller.updateStatus(data.id, nextStatus),
              ),
      );
    });
  }

  Widget _buildRideProgressTracker() {
    return Obx(() {
      String currentStatus = controller.currentRideStatus.value.toUpperCase();

      int activeStep = 0;
      if (currentStatus == "ON THE WAY") {
        activeStep = 1;
      } else if (currentStatus == "AT THE LOCATION") {
        activeStep = 2;
      } else if (currentStatus == "POB") {
        activeStep = 3;
      } else if (currentStatus == "FINISHED" || currentStatus == "COMPLETED") {
        activeStep = 4;
      }

      final steps = [
        {"label": "Assigned", "icon": Icons.assignment_turned_in_outlined},
        {"label": "On The Way", "icon": Icons.directions_car_outlined},
        {"label": "At Location", "icon": Icons.location_on_outlined},
        {"label": "POB", "icon": Icons.person_pin_circle_outlined},
        {"label": "Finished", "icon": Icons.task_alt},
      ];

      final isFinished = activeStep == 4;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF2C2C2C)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ride Status Flow",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isFinished
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : AppColors.orange100.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isFinished
                          ? const Color(0xFF10B981)
                          : AppColors.orange100,
                    ),
                  ),
                  child: Text(
                    currentStatus.isEmpty ? "ASSIGNED" : currentStatus,
                    style: GoogleFonts.inter(
                      color: isFinished
                          ? const Color(0xFF10B981)
                          : AppColors.orange100,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: List.generate(steps.length, (index) {
                final isCompletedStep = index < activeStep;
                final isCurrentStep = index == activeStep;
                final isLastStep = index == steps.length - 1;

                final Color color = isCompletedStep
                    ? const Color(0xFF10B981)
                    : (isCurrentStep
                          ? AppColors.orange100
                          : const Color(0xFF52525B));

                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompletedStep
                                    ? const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.15)
                                    : (isCurrentStep
                                          ? AppColors.orange100.withValues(
                                              alpha: 0.15,
                                            )
                                          : Colors.white.withValues(
                                              alpha: 0.05,
                                            )),
                                border: Border.all(
                                  color: color,
                                  width: isCurrentStep ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                isCompletedStep
                                    ? Icons.check
                                    : (steps[index]["icon"] as IconData),
                                color: color,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              steps[index]["label"] as String,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: isCurrentStep
                                    ? Colors.white
                                    : (isCompletedStep
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFA1A1A1)),
                                fontSize: 10.sp,
                                fontWeight: isCurrentStep
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLastStep)
                        Container(
                          width: 10.w,
                          height: 2.h,
                          margin: EdgeInsets.only(bottom: 20.h),
                          color: index < activeStep
                              ? const Color(0xFF10B981)
                              : Colors.white12,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

/// Helper model for cleanly extracting and parsing Ride data.
class _RideDetailsData {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final String vehicleType;
  final String paymentType;
  final String amount;
  final String rating;
  final String posterName;
  final String posterCompany;
  final String participantId;
  final String posterImage;
  final String vehicleInfo;
  final String vehicleNumber;
  final String flightNumber;
  final String instruction;
  final String displayDateTime;

  _RideDetailsData({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.vehicleType,
    required this.paymentType,
    required this.amount,
    required this.rating,
    required this.posterName,
    required this.posterCompany,
    required this.participantId,
    required this.posterImage,
    required this.vehicleInfo,
    required this.vehicleNumber,
    required this.flightNumber,
    required this.instruction,
    required this.displayDateTime,
  });

  factory _RideDetailsData.fromRide(dynamic ride) {
    String id = "";
    String pickupLocation = "N/A";
    String dropoffLocation = "N/A";
    String vehicleType = "N/A";
    String paymentType = "N/A";
    String amount = "N/A";
    String rating = "0.0";
    String posterName = "Unknown";
    String posterCompany = "Unknown";
    String participantId = "";
    String posterImage = AppImages.profile_image;
    String vehicleInfo = "N/A";
    String vehicleNumber = "N/A";
    String flightNumber = "N/A";
    String instruction = "N/A";
    String dateRaw = "";
    String timeRaw = "";

    if (ride is UpcomingRideData || ride is FinishRideData) {
      final dynamic r = ride;
      id = r.id ?? "";
      pickupLocation = r.pickupLocation ?? "N/A";
      dropoffLocation = r.dropoffLocation ?? "N/A";
      vehicleType = r.vehicleType ?? "N/A";
      paymentType =
          (r.paymentType == 'NO_COLLECT' || r.paymentType == 'NO COLLECT')
          ? 'Credit Card on File'
          : (r.paymentType == 'COLLECT'
                ? 'Collect Payment'
                : r.paymentType?.replaceAll('_', ' ') ?? 'N/A');
      amount = r.paymentAmount != null ? "\$${r.paymentAmount}" : "N/A";
      flightNumber = r.flightNumber ?? "N/A";

      final driver = r.createdBy;
      posterName = (driver?.nickname != null && driver!.nickname!.isNotEmpty)
          ? driver.nickname!
          : (driver?.name ?? "Unknown");
      posterCompany = driver?.company ?? "Unknown";
      participantId = driver?.id ?? "";
      posterImage = driver?.profilePicture ?? AppImages.profile_image;
      rating = driver?.averageRating?.toString() ?? "0.0";

      if (driver?.vehicles != null && driver!.vehicles!.isNotEmpty) {
        final v = driver.vehicles!.first;
        vehicleInfo = "${v.make} ${v.model}, ${v.colorOutside}";
        vehicleNumber = v.licensePlate ?? "N/A";
      } else {
        vehicleInfo = vehicleType;
      }

      dateRaw = r.date ?? "";
      timeRaw = r.time ?? "";
    } else if (ride is Ride) {
      final r = ride;
      id = r.id;
      pickupLocation = r.pickupLocation;
      dropoffLocation = r.dropoffLocation;
      vehicleType = r.vehicleType;
      paymentType =
          (r.paymentType == 'NO_COLLECT' || r.paymentType == 'NO COLLECT')
          ? 'Credit Card on File'
          : (r.paymentType == 'COLLECT'
                ? 'Collect Payment'
                : r.paymentType.replaceAll('_', ' '));
      amount = "\$${r.paymentAmount}";

      final driver = r.createdBy ?? r.assignedTo ?? r.applicant?.driver;
      posterName = (driver?.nickname != null && driver!.nickname!.isNotEmpty)
          ? driver.nickname!
          : (driver?.name ?? "Unknown");
      participantId = driver?.id ?? "";
      posterImage =
          (driver?.profilePicture != null && driver!.profilePicture.isNotEmpty)
          ? driver.profilePicture
          : AppImages.profile_image;

      vehicleInfo = vehicleType;
      dateRaw = r.date?.toString() ?? "";
      timeRaw = r.time;
    } else if (ride is Map<String, dynamic>) {
      id = ride['bookingNo']?.toString() ?? ride['id']?.toString() ?? '';
      pickupLocation = ride['pickup'] ?? ride['pickupLocation'] ?? 'N/A';
      dropoffLocation = ride['dropoff'] ?? ride['dropoffLocation'] ?? 'N/A';
      vehicleType = ride['type'] ?? ride['vehicleType'] ?? 'N/A';
      paymentType =
          ride['payment'] ?? ride['paymentType'] ?? 'Credit Card on File';
      amount = ride['price'] != null ? "\$${ride['price']}" : "N/A";
      flightNumber = ride['flight'] ?? ride['flightNumber'] ?? 'N/A';
      instruction =
          ride['instructions'] ?? ride['specialInstructions'] ?? 'N/A';
      posterName =
          ride['jobPoster'] ??
          ride['passenger'] ??
          ride['driver'] ??
          'Mohamed El Bakkali';
      vehicleInfo = ride['vehicle'] ?? vehicleType;
      vehicleNumber = ride['vehicle'] ?? 'N/A';
      dateRaw = ride['dateHeader'] ?? ride['date'] ?? '';
      timeRaw = ride['time'] ?? '';
    }

    // --- DATE & TIME FORMATTING (12h AM/PM) ---
    String displayDateTime = "N/A";

    bool isAsap = false;
    if (ride is UpcomingRideData || ride is FinishRideData) {
      isAsap = ride.asap == true;
    } else if (ride is Ride) {
      isAsap = ride.asap == true;
    }

    if (isAsap) {
      displayDateTime = "ASAP";
    } else {
      String dateStr = "";
      if (dateRaw.isNotEmpty) {
        try {
          DateTime parsed = DateTime.parse(dateRaw);
          dateStr = DateFormat('EEE MMM dd').format(parsed);
        } catch (_) {
          dateStr = dateRaw;
        }
      }

      String formattedTime = timeRaw;
      if (timeRaw.contains(':')) {
        try {
          final parts = timeRaw.split(':');
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1].split(' ')[0]);
          final period = hour >= 12 ? "PM" : "AM";
          final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          formattedTime =
              "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
        } catch (_) {}
      }
      displayDateTime = dateStr.isNotEmpty
          ? "$dateStr . $formattedTime"
          : formattedTime;
    }

    return _RideDetailsData(
      id: id,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      vehicleType: vehicleType,
      paymentType: paymentType,
      amount: amount,
      rating: rating,
      posterName: posterName,
      posterCompany: posterCompany,
      participantId: participantId,
      posterImage: posterImage,
      vehicleInfo: vehicleInfo,
      vehicleNumber: vehicleNumber,
      flightNumber: flightNumber,
      instruction: instruction,
      displayDateTime: displayDateTime,
    );
  }
}
