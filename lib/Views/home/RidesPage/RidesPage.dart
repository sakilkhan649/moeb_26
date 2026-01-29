import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../Core/routs.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/Custom_AppBar.dart';
import '../JobOfferPage/Job_Bottom_sheet/Job_Bottom_sheet_Tabbar.dart';
import 'Controller/Rides_controller.dart';

class Ridespage extends StatelessWidget {
  Ridespage({super.key});

  final RidesController controller = Get.put(RidesController());
  final List<String> _tabs = ["Upcoming", "Past", "Pending"];

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomText(text: "My Rides", fontSize: 20.sp),
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
            SizedBox(height: 20.h),

            /// CUSTOM TAB BAR
            Obx(
              () => Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    bool isSelected = controller.selectedTab.value == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
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
            ),
            SizedBox(height: 25.h),

            /// RIDES LIST (Based on selected tab)
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.currentRides.length,
                  itemBuilder: (context, index) {
                    final ride = controller.currentRides[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.requestUnderReview);
                      },
                      child: CustomJobCard(
                        dateTime: ride.dateTime,
                        vehicleType: ride.vehicleType,
                        pickupLocation: ride.pickupLocation,
                        dropoffLocation: ride.dropoffLocation,
                        pickupPayment: ride.pickupPayment,
                        pickupAmount: ride.pickupAmount,
                        driverName: ride.driverName,
                        companyName: ride.companyName,
                        flightNumberHint: "N/A",
                        paymentMethodHint: ride.pickupPayment,
                        specialInstructionsHint: "N/A",
                        price: ride.pickupAmount,
                        vehicleTypeColor: ride.vehicleTypeColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= VEHICLE TYPE COLORS =================
class VehicleTypeColors {
  static const Color sedan = Colors.red;
  static const Color suv = Colors.blue;
  static const Color van = Colors.green;
  static const Color luxury = Color(0xFFD4AF37); // Gold
  static const Color truck = Colors.orange;
  static const Color mini = Colors.purple;
}

/// ================= CUSTOM VEHICLE TYPE BADGE =================
class VehicleTypeBadge extends StatelessWidget {
  final String vehicleType;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const VehicleTypeBadge({
    Key? key,
    required this.vehicleType,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
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
  final String pickupPayment;
  final String pickupAmount;
  final String driverName;
  final String companyName;
  final String flightNumberHint;
  final String paymentMethodHint;
  final String specialInstructionsHint;
  final String price;
  final Color vehicleTypeColor;

  const CustomJobCard({
    Key? key,
    required this.dateTime,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupPayment,
    required this.pickupAmount,
    required this.driverName,
    required this.companyName,
    required this.flightNumberHint,
    required this.paymentMethodHint,
    required this.specialInstructionsHint,
    required this.price,

    this.vehicleTypeColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
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
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    dateTime,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              VehicleTypeBadge(
                vehicleType: vehicleType,
                backgroundColor: vehicleTypeColor,
              ),
            ],
          ),
          SizedBox(height: 15.h),

          /// PICKUP LOCATION
          _buildRichInfo("PU: ", pickupLocation),
          SizedBox(height: 8.h),

          /// DROPOFF LOCATION
          _buildRichInfo("DO: ", dropoffLocation),
          SizedBox(height: 8.h),

          /// PAYMENT METHOD
          _buildRichInfo("Payment: ", pickupPayment),
          SizedBox(height: 8.h),

          /// AMOUNT
          _buildRichInfo("Amount: ", pickupAmount),
          SizedBox(height: 15.h),

          /// DRIVER NAME
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey, size: 18.sp),
              SizedBox(width: 10.w),
              Text(
                driverName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// COMPANY NAME
          Row(
            children: [
              Icon(Icons.business_center, color: Colors.grey, size: 18.sp),
              SizedBox(width: 10.w),
              Text(
                companyName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
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
