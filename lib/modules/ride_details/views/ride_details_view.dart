import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:moeb_26/core/widgets/CustomTextGary.dart';
import 'package:moeb_26/core/widgets/Custom_Back_Button.dart';
import 'package:moeb_26/core/widgets/Custom_InfoBox.dart';
import '../../../core/widgets/Custom_AppBar.dart';
import '../../../core/widgets/Custom_Card_Ditails.dart';
import '../../../core/widgets/Custom_Driver_Card.dart';
import '../controllers/ride_details_controller.dart';

class RideDetailsView extends StatelessWidget {
  RideDetailsView({super.key});

  final RideDetailsController controller = Get.find<RideDetailsController>();

  @override
  Widget build(BuildContext context) {
    // Get the ride data passed from the previous screen (could be Ride, UpcomingRideData, or FinishRideData)
    final dynamic ride = Get.arguments;

    if (ride == null) {
      return Scaffold(
        appBar: CustomAppBar(
          logoPath: AppImages.app_logo,
          notificationCount: 0,
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
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(color: Colors.white38, thickness: 1.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: const CustomBackButton(title: "Ride Details"),
              ),
              Divider(color: Colors.white38, thickness: 1.h),
              SizedBox(height: 5.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverSection(data),
                  SizedBox(height: 10.h),
                  _buildJobDetailsSection(data),
                  SizedBox(height: 10.h),
                  _buildSpecialInstructionsSection(data),
                  SizedBox(height: 10.h),
                  Divider(color: Colors.white38, thickness: 1.h),
                  SizedBox(height: 10.h),
                  _buildActionButtonsSection(data, ride),
                  SizedBox(height: 20.h),
                  _buildBackToJobsButton(),
                  SizedBox(height: 30.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSection(_RideDetailsData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomDriverCard(
        profileImage: data.posterImage,
        name: data.posterName,
        rating: data.rating,
        vehicleNumber: data.vehicleNumber,
        vehicleInfo: data.vehicleInfo,
        buttonText: "Chat with Job Poster",
        buttonIcon: Icons.chat_bubble_outline,
        onButtonPressed: () async {
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
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildJobDetailsSection(_RideDetailsData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
        backgroundColor: const Color(0xFF1C1C1C),
        borderColor: const Color(0xFF2A2A2A),
        labelColor: Colors.grey,
        valueColor: Colors.white,
        iconColor: Colors.grey,
      ),
    );
  }

  Widget _buildSpecialInstructionsSection(_RideDetailsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomTextgray(text: "Special Instructions"),
        ),
        SizedBox(height: 10.h),
        CustomInfoBox(text: data.instruction),
      ],
    );
  }

  Widget _buildActionButtonsSection(_RideDetailsData data, dynamic ride) {
    return Obx(() {
      String status = controller.currentRideStatus.value;

      if (status == "POB") {
        // --- FINISH RIDE DRAGGABLE SECTION ---
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                              : const Color(0xFF2A2A2A),
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.orange100),
              )
            : CustomButton(
                text: buttonText,
                backgroundColor: AppColors.orange100,
                textColor: Colors.white,
                onPressed: () => controller.updateStatus(data.id, nextStatus),
              ),
      );
    });
  }

  Widget _buildBackToJobsButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomButton(
        text: "Back to Jobs",
        backgroundColor: const Color(0xFF1C1C1C),
        borderColor: const Color(0xFF2A2A2A),
        textColor: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
    );
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
      paymentType = r.paymentType ?? "N/A";
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
      paymentType = r.paymentType;
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
