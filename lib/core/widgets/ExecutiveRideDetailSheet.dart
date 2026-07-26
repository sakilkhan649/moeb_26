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
        color: const Color(0xFF0D0D0E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(color: const Color(0xFF282830), width: 1.5),
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
                  color: const Color(0xFF33333E),
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
                    if (bookingNo.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        "Booking no: $bookingNo",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
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
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white, size: 22.sp),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: const Color(0xFF22222A), thickness: 1, height: 20.h),

            // Card 1: Time & Date
            _buildSectionCard(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: const Color(0xFF38BDF8),
                      size: 20.sp,
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (status != null && status!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          "Status: ${status!.toUpperCase()}",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD08700),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Card 2: Detailed Route Layout
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pickup Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pickupLocation,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (pickupNotes != null &&
                                pickupNotes!.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                pickupNotes!,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[400],
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Connecting Line with Distance Estimate
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 4.h, bottom: 4.h),
                    child: Row(
                      children: [
                        Container(
                          width: 2.w,
                          height: 24.h,
                          color: const Color(0xFF33333E),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "6.2 mi • 16 min est.",
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dropoff Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dropoffLocation.isNotEmpty
                                  ? dropoffLocation
                                  : "As Directed",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (dropoffNotes != null &&
                                dropoffNotes!.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                dropoffNotes!,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[400],
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Card 3: Passenger Contact Info
            _buildSectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white70,
                        size: 22.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        passengerName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chat_bubble_outline,
                    color: const Color(0xFF38BDF8),
                    size: 20.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Card 4: Driver & Vehicle Info
            _buildSectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.white70,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        driverName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            color: Colors.white70,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            vehicleInfo,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
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
                          borderRadius: BorderRadius.circular(10.r),
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
                            "Total Fare:",
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                          Text(
                            "\$$amount",
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD08700),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                    ],
                    if (paymentType != null && paymentType!.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Method:",
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                          Text(
                            paymentType!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (flightNumber != null && flightNumber!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Flight Number:",
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                          Text(
                            flightNumber!,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF38BDF8),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (specialInstructions != null &&
                        specialInstructions!.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Text(
                        "Special Instructions:",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          specialInstructions!,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12.sp,
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
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD08700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
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
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            // Edit & Delete Action Buttons (if provided)
            if (onEditPressed != null || onDeletePressed != null) ...[
              if (actionButtonText != null) SizedBox(height: 12.h),
              Row(
                children: [
                  if (onEditPressed != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD08700)),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          onEditPressed!();
                        },
                        icon: SvgPicture.asset(
                          AppIcons.edit_icon_myjob,
                          width: 18.sp,
                          height: 18.sp,
                        ),
                        label: Text(
                          "Edit Job",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD08700),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (onEditPressed != null && onDeletePressed != null)
                    SizedBox(width: 12.w),
                  if (onDeletePressed != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          onDeletePressed!();
                        },
                        icon: SvgPicture.asset(
                          AppIcons.deletemyjob_icon,
                          width: 18.sp,
                          height: 18.sp,
                        ),
                        label: Text(
                          "Delete Job",
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF161619),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF24242A)),
      ),
      child: child,
    );
  }
}
