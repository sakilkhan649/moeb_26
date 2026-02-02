import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ================= CUSTOM JOB DETAILS CARD WIDGET =================
/// This widget displays a comprehensive job details card with all job information
/// in a clean, organized layout. It's fully reusable and customizable.
class CustomJobDetailsCard extends StatelessWidget {
  // Job location details
  final String pickupLocation;
  final String dropoffLocation;

  // Job information
  final String flightNumber;
  final String dateTime;
  final String vehicleType;
  final String jobPoster;
  final String company;
  final String payment;
  final String amount;

  // Styling options
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? labelColor;
  final Color? valueColor;
  final Color? iconColor;

  // Optional callback for card tap
  final VoidCallback? onTap;

  const CustomJobDetailsCard({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.flightNumber,
    required this.dateTime,
    required this.vehicleType,
    required this.jobPoster,
    required this.company,
    required this.payment,
    required this.amount,
    this.backgroundColor,
    this.borderColor,
    this.labelColor,
    this.valueColor,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor ?? const Color(0xFF2A2A2A),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ============== CARD TITLE ==============
            Text(
              "Job Details",
              style: GoogleFonts.inter(
                color: valueColor ?? Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),

            /// ============== PICKUP LOCATION ==============
            _buildJobDetailRow(
              icon: Icons.location_on_outlined,
              label: "PU",
              value: pickupLocation,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== DROPOFF LOCATION ==============
            _buildJobDetailRow(
              icon: Icons.location_on_outlined,
              label: "DO",
              value: dropoffLocation,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== FLIGHT NUMBER ==============
            _buildJobDetailRow(
              icon: Icons.flight,
              label: "Flight Number",
              value: flightNumber,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== DATE & TIME ==============
            _buildJobDetailRow(
              icon: Icons.calendar_today_outlined,
              label: "Date & Time",
              value: dateTime,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== VEHICLE TYPE ==============
            _buildJobDetailRow(
              icon: Icons.directions_car_outlined,
              label: "Vehicle Type",
              value: vehicleType,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== JOB POSTER ==============
            _buildJobDetailRow(
              icon: Icons.person_outline,
              label: "Job Poster",
              value: jobPoster,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== COMPANY ==============
            _buildJobDetailRow(
              icon: Icons.work,
              label: "Company",
              value: company,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== PAYMENT METHOD ==============
            _buildJobDetailRow(
              icon: Icons.attach_money,
              label: "Payment",
              value: payment,
            ),
            Divider(color: Colors.grey[700], thickness: 1.h),

            /// ============== AMOUNT ==============
            _buildJobDetailRow(
              icon: Icons.attach_money,
              label: "Amount",
              value: amount,
            ),
          ],
        ),
      ),
    );
  }

  /// ============== HELPER METHOD TO BUILD EACH ROW ==============
  /// This method creates a consistent row layout for each job detail
  /// with an icon, label, and value
  Widget _buildJobDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        /// Icon on the left
        Icon(
          icon,
          color: iconColor ?? Colors.grey,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),

        /// Label text (e.g., "PU", "DO", "Flight Number")
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: labelColor ?? Colors.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        /// Value text (e.g., "Dhaka Airport", "Barisal")
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              color: valueColor ?? Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

