import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/data/models/my_rides_model.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';

class RideDetailSheet extends StatelessWidget {
  final RideData ride;
  final bool isPast;
  final String? dateHeader;
  final VoidCallback? onReviewPressed;

  const RideDetailSheet({
    super.key,
    required this.ride,
    required this.isPast,
    this.dateHeader,
    this.onReviewPressed,
  });

  String _formatDateTime(RideData r) {
    if (r.asap) {
      String datePart = "Today";
      if (r.createdAt != null && r.createdAt!.isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(r.createdAt!).toLocal();
          datePart = "Today, ${DateFormat('MMM dd').format(parsedDate)}";
        } catch (_) {}
      }
      return "$datePart • ASAP";
    }

    String datePart = dateHeader ?? "Today";
    if (dateHeader == null || dateHeader!.isEmpty) {
      if (r.date != null && r.date!.isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(r.date!).toLocal();
          datePart = DateFormat("dd MMM, yyyy").format(parsedDate);
        } catch (_) {
          datePart = r.date!;
        }
      }
    }

    String timePart = "";
    if (r.time != null && r.time!.isNotEmpty) {
      try {
        if (r.time!.contains(":")) {
          final parts = r.time!.split(":");
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final dt = DateTime(2026, 1, 1, hour, minute);
          timePart = DateFormat("hh:mm a").format(dt);
        } else {
          timePart = r.time!;
        }
      } catch (_) {
        timePart = r.time!;
      }
    }

    if (timePart.isNotEmpty) {
      return "$datePart • $timePart";
    }
    return datePart;
  }

  String _getPosterName(RideData r) {
    if (r.nickname != null && r.nickname!.isNotEmpty) return r.nickname!;
    if (r.name != null && r.name!.isNotEmpty) return r.name!;
    final driver = r.createdBy ?? r.assignedTo ?? r.applicant?.driver;
    if (driver?.nickname != null && driver!.nickname!.isNotEmpty) {
      return driver.nickname!;
    }
    return driver?.name ?? r.companyName ?? r.company ?? "Job Poster";
  }

  String _getDriverName(RideData r) {
    final driver = r.assignedTo ?? r.applicant?.driver ?? r.createdBy;
    if (driver?.nickname != null && driver!.nickname!.isNotEmpty) {
      return driver.nickname!;
    }
    return driver?.name ?? "Chauffeur";
  }

  String _getVehicleInfo(RideData r) {
    final driver = r.assignedTo ?? r.applicant?.driver ?? r.createdBy;
    if (driver?.vehicles != null && driver!.vehicles!.isNotEmpty) {
      final v = driver.vehicles!.first;
      return "${v.make} ${v.model}, ${v.colorOutside}";
    }
    return r.vehicleType.isNotEmpty ? r.vehicleType : "Sedan";
  }

  void _openChat(RideData r) async {
    final String? participantId =
        r.createdBy?.id ?? r.assignedTo?.id ?? r.applicant?.driver?.id;
    if (participantId != null && participantId.isNotEmpty && r.id.isNotEmpty) {
      try {
        final chat = await Get.find<SocketRepository>()
            .createChat(participantId, r.id);
        if (chat != null) {
          Get.back();
          Get.toNamed(Routes.chatDetailView, arguments: chat);
          return;
        }
      } catch (_) {}
    }

    final posterName = _getPosterName(r);
    final chat = ChatPreview(
      id: "chat_${r.id}",
      participants: [
        ChatParticipant(id: participantId ?? "user_1", name: posterName),
      ],
      lastMessage:
          "Hi, I am assigned to your ride #${r.id.substring(r.id.length > 6 ? r.id.length - 6 : 0)}.",
      lastMessageAt: DateTime.now().toIso8601String(),
      createdBy: "current_user",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    Get.back();
    Get.toNamed(Routes.chatDetailView, arguments: chat);
  }

  @override
  Widget build(BuildContext context) {
    final title = isPast ? "Completed Ride" : "Upcoming Ride Details";
    final bookingNo = ride.id.isNotEmpty
        ? ride.id.substring(ride.id.length > 8 ? ride.id.length - 8 : 0)
        : "";
    final dateTimeStr = _formatDateTime(ride);
    final amountStr =
        ride.paymentAmount != null ? "${ride.paymentAmount}" : "0.00";
    final posterName = _getPosterName(ride);
    final driverName = _getDriverName(ride);
    final vehicleInfo = _getVehicleInfo(ride);
    final paymentTypeStr = ride.paymentType?.isNotEmpty == true
        ? ride.paymentType!
        : "Credit Card on File";
    final flightNumberStr =
        ride.flightNumber?.isNotEmpty == true ? ride.flightNumber! : "N/A";
    final instructions = ride.instruction ?? "";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: const Color(0xFF24242A), width: 1),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle Bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF33333E),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header Row: Title & Close Button
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
                        "Booking #$bookingNo",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.grey[400],
                    size: 22.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Section 1: Route & Timeline Info
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DateTime & Amount Row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        dateTimeStr,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (amountStr.isNotEmpty) ...[
                        Text(
                          "\$$amountStr",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFEDB9B),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Divider(color: const Color(0xFF22222A), height: 1.h),
                  SizedBox(height: 14.h),

                  // Route Timeline
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12.r,
                              height: 12.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
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
                                  SizedBox(height: 2.h),
                                  Text(
                                    ride.pickupLocation,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DROPOFF",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    ride.dropoffLocation,
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
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Section 2: Job Poster & Chauffeur Info
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
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
                                Icons.person_outline,
                                color: Colors.white70,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "JOB POSTER",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    posterName,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isPast) ...[
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => _openChat(ride),
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD08700).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFD08700).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: const Color(0xFFFEDB9B),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Divider(color: const Color(0xFF22222A), height: 1.h),
                  SizedBox(height: 12.h),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CHAUFFEUR & VEHICLE",
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (vehicleInfo.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                vehicleInfo,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

            // Section 3: Extra Info (Payment, Flight & Instructions)
            SizedBox(height: 12.h),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        paymentTypeStr,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                        flightNumberStr,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090B14),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF1B2033)),
                    ),
                    child: Text(
                      instructions.isNotEmpty
                          ? instructions
                          : "No special instructions provided.",
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.sp,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isPast) ...[
              SizedBox(height: 20.h),
              CustomButton(
                text: "Rate & Review Driver",
                backgroundColor: const Color(0xFF22C55E),
                textColor: Colors.black,
                icon: Icon(
                  Icons.star_outline_rounded,
                  size: 18.sp,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                  if (onReviewPressed != null) {
                    onReviewPressed!();
                  } else {
                    Get.toNamed(Routes.ratingsFeedbackView);
                  }
                },
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ] else ...[
              SizedBox(height: 20.h),
              CustomButton(
                text: "View Ride Progress",
                icon: Icon(
                  Icons.navigation_outlined,
                  size: 18.sp,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.rideDetailsView, arguments: ride.id);
                },
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
