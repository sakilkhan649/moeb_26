import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/themes/app_theme.dart';

class ExecutiveRideDetailSheet extends StatelessWidget {
  final String title; // e.g. "Booking Details" or "Job Offer"
  final String bookingNo;
  final String dateTimeStr;
  final String pickupLocation;
  final String? pickupNotes;
  final String dropoffLocation;
  final String? dropoffNotes;
  final String passengerName;
  final String driverName;
  final String vehicleInfo;
  final String vehicleType;
  final String? paymentType;
  final String? amount;
  final String? flightNumber;
  final String? specialInstructions;
  final String? status;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const ExecutiveRideDetailSheet({
    super.key,
    required this.title,
    required this.bookingNo,
    required this.dateTimeStr,
    required this.pickupLocation,
    this.pickupNotes,
    required this.dropoffLocation,
    this.dropoffNotes,
    required this.passengerName,
    required this.driverName,
    required this.vehicleInfo,
    required this.vehicleType,
    this.paymentType,
    this.amount,
    this.flightNumber,
    this.specialInstructions,
    this.status,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleStyle = VehicleTypeColors.getVehicleStyle(vehicleType);
    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        border: Border.all(color: const Color(0xFF24242A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 50.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A32),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Top Header: Title & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (onEditPressed != null)
                      IconButton(
                        onPressed: () {
                          Get.back();
                          onEditPressed!();
                        },
                        icon: SvgPicture.asset(
                          AppIcons.edit_icon_myjob,
                          width: 20.sp,
                          height: 20.sp,
                        ),
                        tooltip: "Edit Job",
                      ),
                    if (onDeletePressed != null)
                      IconButton(
                        onPressed: () {
                          Get.back();
                          onDeletePressed!();
                        },
                        icon: SvgPicture.asset(
                          AppIcons.deletemyjob_icon,
                          width: 20.sp,
                          height: 20.sp,
                        ),
                        tooltip: "Delete Job",
                      ),
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: const Color(0xFF22222A), thickness: 1, height: 20.h),

            // Card 1: Time & Date
            _buildSectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141416),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF24242A),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white70,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateTimeStr,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (status != null && status!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD08700).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xFFD08700).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status!.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD08700),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Card 2: Detailed Route Layout
            _buildSectionCard(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 4.h),
                        Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2.w,
                            color: const Color(0xFF2E2E38),
                          ),
                        ),
                        Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFEDB9B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PICKUP",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                pickupLocation,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DROP-OFF",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                dropoffLocation.isNotEmpty
                                    ? dropoffLocation
                                    : "As Directed",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Card 4: Driver & Vehicle Info
            _buildSectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1F),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFF2A2A32),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white70,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CHAUFFEUR",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            driverName,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Divider(
                      color: const Color(0xFF22222A),
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1F),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xFF2A2A32),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.directions_car_outlined,
                              color: Colors.white70,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VEHICLE",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                vehicleInfo,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: vehicleStyle is Color ? vehicleStyle : null,
                          gradient: vehicleStyle is Gradient
                              ? vehicleStyle
                              : null,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          vehicleType,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 5: Payment & Special Instructions
            if ((paymentType != null && paymentType!.isNotEmpty) ||
                (amount != null && amount!.isNotEmpty) ||
                (flightNumber != null && flightNumber!.isNotEmpty) ||
                (specialInstructions != null &&
                    specialInstructions!.isNotEmpty)) ...[
              SizedBox(height: 12.h),
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (amount != null && amount!.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Fare",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$$amount",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFFEDB9B),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (paymentType != null && paymentType!.isNotEmpty) ...[
                      if (amount != null && amount!.isNotEmpty)
                        SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Method",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            paymentType!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (flightNumber != null && flightNumber!.isNotEmpty) ...[
                      if ((amount != null && amount!.isNotEmpty) ||
                          (paymentType != null && paymentType!.isNotEmpty))
                        SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Flight Number",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            flightNumber!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (specialInstructions != null &&
                        specialInstructions!.isNotEmpty) ...[
                      if ((amount != null && amount!.isNotEmpty) ||
                          (paymentType != null && paymentType!.isNotEmpty) ||
                          (flightNumber != null && flightNumber!.isNotEmpty))
                        SizedBox(height: 14.h),
                      Text(
                        "SPECIAL INSTRUCTIONS",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F11),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xFF22222A)),
                        ),
                        child: Text(
                          specialInstructions!,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            SizedBox(height: 20.h),

            // Action Button (if provided)
            if (actionButtonText != null) ...[
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD08700),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shadowColor: const Color(0xFFD08700).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    if (onActionButtonPressed != null) {
                      onActionButtonPressed!();
                    }
                  },
                  child: Text(
                    actionButtonText!,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF141416),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF24242A), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
