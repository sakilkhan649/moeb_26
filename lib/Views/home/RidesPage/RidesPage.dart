import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Data/models/finish_rides_model.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Data/models/upcoming_rides_model.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../Core/routs.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/Custom_AppBar.dart';
import '../JobOfferPage/Job_Bottom_sheet/Job_Bottom_sheet_Tabbar.dart';
import 'Controller/Rides_controller.dart';

class Ridespage extends StatelessWidget {
  Ridespage({super.key});

  final RidesController controller = Get.find<RidesController>();
  final List<String> _tabs = ["Upcoming", "Past", "Pending"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomText(text: "MY Jobs", fontSize: 22.sp),
                ),
                Expanded(
                  child: CustomJobButton(
                    text: "New Job",
                    onPressed: () {
                      Get.bottomSheet(
                        PostJobBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            /// CUSTOM TAB BAR
            _buildTabBar(),
            SizedBox(height: 15.h),

            /// RIDES LIST (Based on selected tab)
            Expanded(
              child: RefreshIndicator(
                color: AppColors.orange100,
                onRefresh: controller.refreshCurrentTab,
                child: Obx(() {
                  if (controller.isLoadingList.value) {
                    return _buildLoading();
                  }

                  switch (controller.selectedTab.value) {
                    case 0:
                      return _buildUpcomingList();
                    case 1:
                      return _buildPastList();
                    case 2:
                      return _buildPendingList();
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            bool isSelected = controller.selectedTab.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.orange100
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: const CircularProgressIndicator(color: AppColors.orange100),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Text(
          "No rides found",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }

  // --- UPCOMING LIST ---
  Widget _buildUpcomingList() {
    if (controller.upcomingRides.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.upcomingRides.length + 1,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
          if (index == controller.upcomingRides.length) {
            return Obx(
              () => controller.isLoadMore.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange100,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }
          final UpcomingRideData ride = controller.upcomingRides[index];
          return _buildRideCard(
            ride: ride,
            onTap: () => Get.toNamed(Routes.rideDetailsPage, arguments: ride),
            date: ride.date,
            time: ride.time,
            pickup: ride.pickupLocation,
            dropoff: ride.dropoffLocation,
            vehicle: ride.vehicleType,
            payment: ride.paymentType,
            amount: ride.paymentAmount?.toString(),
            name: ride.createdBy?.name,
            company: ride.createdBy?.company,
          );
        },
      );
  }

  // --- PAST LIST ---
  Widget _buildPastList() {
    if (controller.pastRides.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.pastRides.length + 1,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
          if (index == controller.pastRides.length) {
            return Obx(
              () => controller.isLoadMore.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange100,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }
          final FinishRideData ride = controller.pastRides[index];
          return _buildRideCard(
            ride: ride,
            onTap: null, // No action for past rides
            date: ride.date,
            time: ride.time,
            pickup: ride.pickupLocation,
            dropoff: ride.dropoffLocation,
            vehicle: ride.vehicleType,
            payment: ride.paymentType,
            amount: ride.paymentAmount?.toString(),
            name: ride.createdBy?.name,
            company: ride.createdBy?.company,
          );
        },
      
    );
  }

  // --- PENDING LIST ---
  Widget _buildPendingList() {
    if (controller.pendingRides.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.pendingRides.length + 1,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
          if (index == controller.pendingRides.length) {
            return Obx(
              () => controller.isLoadMore.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange100,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }
          final Ride ride = controller.pendingRides[index];
          return _buildRideCard(
            ride: ride,
            onTap: () =>
                Get.toNamed(Routes.requestUnderReview, arguments: ride),
            date: ride.date?.toString(),
            time: ride.time,
            pickup: ride.pickupLocation,
            dropoff: ride.dropoffLocation,
            vehicle: ride.vehicleType,
            payment: ride.paymentType,
            amount: ride.paymentAmount.toString(),
            name: ride.applicant?.driver?.name,
            company: ride.applicant?.driver?.company,
          );
        },
    );
  }

  // --- COMMON CARD BUILDER ---
  Widget _buildRideCard({
    required dynamic ride,
    required VoidCallback? onTap,
    String? date,
    String? time,
    String? pickup,
    String? dropoff,
    String? vehicle,
    String? payment,
    String? amount,
    String? name,
    String? company,
  }) {
    // Format Date and Time
    String displayDateTime = "";
    String dateStr = "";
    if (date != null && date.isNotEmpty) {
      try {
        DateTime parsed = DateTime.parse(date);
        dateStr = DateFormat('EEE, MMM dd').format(parsed);
      } catch (_) {
        dateStr = date;
      }
    }

    String timeStr = time ?? "";
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
    displayDateTime = dateStr.isNotEmpty ? "$dateStr · $timeStr" : timeStr;

    final vehicleType = vehicle ?? 'N/A';

    return GestureDetector(
      onTap: onTap,
      child: CustomJobCard(
        pickupPaymentType: payment?.replaceAll('_', ' ') ?? 'N/A',
        dateTime: displayDateTime,
        vehicleType: vehicleType.toUpperCase(),
        pickupLocation: pickup ?? 'N/A',
        dropoffLocation: dropoff ?? 'N/A',
        pickupAmount: amount ?? '0',
        driverName: name ?? 'Unknown',
        companyName: company ?? 'N/A',
        vehicleStyle: VehicleTypeColors.getVehicleStyle(vehicleType),
      ),
    );
  }
}

/// ================= VEHICLE TYPE COLORS =================
class VehicleTypeColors {
  static const Color sedan = Color(0xFFDC2626);
  static const Color suv = Color(0xFF0A1F44);
  static const Color bus = Color(0xFF3B2F2F);
  static const Color gray = Color.fromARGB(255, 65, 63, 63);

  static final LinearGradient sedanSuvGradient = LinearGradient(
    colors: [
      const Color(0xFFB11226),
      const Color(0xFFB11226).withOpacity(0.90),
      const Color(0xFF0A1F44).withOpacity(0.95),
      const Color(0xFF0A1F44).withOpacity(0.9),
    ],

    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static dynamic getVehicleStyle(String? type) {
    if (type == null) return gray;
    final t = type.toUpperCase();
    if (t == 'SUV') return suv;
    if (t == 'SEDAN') return sedan;
    if (t == 'BUS') return bus;
    if (t == 'SEDAN/SUV') return sedanSuvGradient;
    return gray;
  }
}

/// ================= CUSTOM VEHICLE TYPE BADGE =================
class VehicleTypeBadge extends StatelessWidget {
  final String vehicleType;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const VehicleTypeBadge({
    Key? key,
    required this.vehicleType,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.red) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        vehicleType,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: fontSize ?? 11.sp,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}

/// ================= CUSTOM JOB CARD WIDGET =================
class CustomJobCard extends StatelessWidget {
  final String dateTime;
  final String vehicleType;
  final String pickupLocation;
  final String dropoffLocation;
  // final String pickupPayment;
  final String pickupAmount;
  final String driverName;
  final String companyName;
  final String pickupPaymentType;
  final dynamic vehicleStyle;

  const CustomJobCard({
    required this.pickupPaymentType,
    Key? key,
    required this.dateTime,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAmount,
    required this.driverName,
    required this.companyName,
    required this.vehicleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER - Date & Vehicle Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        dateTime,
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              VehicleTypeBadge(
                vehicleType: vehicleType,
                backgroundColor: vehicleStyle is Color ? vehicleStyle : null,
                gradient: vehicleStyle is Gradient ? vehicleStyle : null,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          /// PICKUP LOCATION
          _buildRichInfo("PU: ", pickupLocation),
          SizedBox(height: 8.h),

          /// DROPOFF LOCATION
          _buildRichInfo("DO: ", dropoffLocation),
          SizedBox(height: 8.h),

          /// PAYMENT METHOD
          _buildRichInfo("Payment: ", pickupPaymentType),
          SizedBox(height: 8.h),

          /// AMOUNT
          _buildRichInfo("Amount: ", "\$$pickupAmount"),
          SizedBox(height: 15.h),

          /// DRIVER NAME
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey, size: 18.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  driverName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// COMPANY NAME
          Row(
            children: [
              Icon(Icons.business_center, color: Colors.grey, size: 18.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  companyName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(fontSize: 14.sp),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.grey),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
