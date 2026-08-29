import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/modules/my_schedule/controllers/my_schedule_controller.dart';
import 'package:moeb_26/modules/my_schedule/models/my_schedule_job_model.dart';
import 'package:moeb_26/modules/my_schedule/views/widgets/add_schedule_job_sheet.dart';
import 'package:moeb_26/modules/my_schedule/views/schedule_job_detail_view.dart';

class MyScheduleView extends GetView<MyScheduleController> {
  const MyScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: const CustomSubAppBar(title: "My Schedule"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddJobSheet(context),
        backgroundColor: AppColors.primaryColor, // Color(0xFFFFDCA1)
        foregroundColor: Colors.black,
        elevation: 6,
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          "Add Booking",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Sub-Header Banner indicating privacy
          _buildPrivacyHeader(),

          // Horizontal Weekly Calendar Strip with Header & Date Picker
          _buildWeeklyCalendarStrip(context),

          SizedBox(height: 10.h),

          // Main Jobs List / Empty State
          Expanded(
            child: Obx(() {
              final jobs = controller.selectedDateJobs;
              if (jobs.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 8.h,
                  bottom: 95
                      .h, // Bottom spacing so scrolling content moves above FAB
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(context, jobs[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Sub-Header Privacy Banner
  Widget _buildPrivacyHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: const Color(0xFF141416),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16.sp, color: AppColors.primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Private Schedule • Jobs are visible only to you until dispatched.",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Calendar Strip with Month Header & Date Picker Icon
  Widget _buildWeeklyCalendarStrip(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141416),
        border: Border(bottom: BorderSide(color: Color(0xFF24242A), width: 1)),
      ),
      child: Obx(() {
        final selected = controller.selectedDate.value;
        final isTodaySelected =
            selected.year == DateTime.now().year &&
            selected.month == DateTime.now().month &&
            selected.day == DateTime.now().day;

        // Show a 30-day window starting 7 days before current selected date
        final startDate = selected.subtract(const Duration(days: 7));

        return Column(
          children: [
            // Month Header & Calendar Action Row
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(selected),
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      DateFormat('EEE, d MMM').format(selected),
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Quick "Today" jump button
                  if (!isTodaySelected)
                    GestureDetector(
                      onTap: () => controller.selectDate(DateTime.now()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Today",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  // Full Calendar Dialog Launcher Icon
                  GestureDetector(
                    onTap: () => _openFullCalendarPicker(context),
                    child: Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E22),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFF2B2B32)),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Date Strip List
            Container(
              height: 75.h,
              padding: EdgeInsets.only(bottom: 8.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: 30,
                itemBuilder: (context, index) {
                  final date = startDate.add(Duration(days: index));
                  final isSelected =
                      date.year == selected.year &&
                      date.month == selected.month &&
                      date.day == selected.day;

                  final isToday =
                      date.year == DateTime.now().year &&
                      date.month == DateTime.now().month &&
                      date.day == DateTime.now().day;

                  final hasJobs = controller.hasJobsOnDate(date);

                  return GestureDetector(
                    onTap: () => controller.selectDate(date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52.w,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color(0xFF1E1E22),
                        borderRadius: BorderRadius.circular(14.r),
                        border: isToday && !isSelected
                            ? Border.all(
                                color: AppColors.primaryColor,
                                width: 1.2,
                              )
                            : Border.all(
                                color: const Color(0xFF2B2B32),
                                width: 1,
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.gray100,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            DateFormat('d').format(date),
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          if (hasJobs)
                            Container(
                              width: 5.r,
                              height: 5.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.primaryColor,
                              ),
                            )
                          else
                            SizedBox(height: 5.r),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _openFullCalendarPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF141416),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  // Job Card Widget
  Widget _buildJobCard(BuildContext context, MyScheduleJobModel job) {
    final isDispatched = job.isDispatchedToNetwork;
    final vehicleStyle = VehicleTypeColors.getVehicleStyle(job.vehicleType);

    return GestureDetector(
      onTap: () => Get.to(() => ScheduleJobDetailView(job: job)),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDispatched
                ? AppColors.primaryColor.withValues(alpha: 0.6)
                : const Color(0xFF24242A),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Time & Vehicle Type & Price
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222228),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 13.sp,
                        color: AppColors.gray100,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        DateFormat('hh:mm a').format(job.pickupDateTime),
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: vehicleStyle is Color ? vehicleStyle : null,
                    gradient: vehicleStyle is Gradient ? vehicleStyle : null,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    job.vehicleType,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                if (job.fare.isNotEmpty)
                  Text(
                    job.fare,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 14.h),

            // Client Name & Contact Actions (SMS & Call)
            Row(
              children: [
                CircleAvatar(
                  radius: 17.r,
                  backgroundColor: const Color(0xFF24242A),
                  child: Icon(Icons.person, size: 18.sp, color: Colors.white70),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.clientName,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        job.clientPhone,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.gray100,
                        ),
                      ),
                    ],
                  ),
                ),
                // Text Message (SMS) Icon Button
                GestureDetector(
                  onTap: () => controller.sendTextMessage(job.clientPhone),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFF24242A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Call Phone Icon Button
                GestureDetector(
                  onTap: () => controller.makePhoneCall(job.clientPhone),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFF24242A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            const Divider(height: 1, color: Color(0xFF24242A)),
            SizedBox(height: 12.h),

            // Route Visualiser: Pickup -> Dropoff
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 9.r,
                      height: 9.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 2),
                        color: Colors.transparent,
                      ),
                    ),
                    Container(
                      width: 1.5.w,
                      height: 24.h,
                      color: const Color(0xFF33333D),
                    ),
                    Container(
                      width: 9.r,
                      height: 9.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.pickupLocation,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        job.dropoffLocation,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            const Divider(height: 1, color: Color(0xFF24242A)),
            SizedBox(height: 10.h),

            // Sleek Footer: Payment Status Pill & "View Details >" link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Paid / Unpaid Status Chip
                GestureDetector(
                  onTap: () => controller.togglePaymentStatus(job.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: job.isPaid
                          ? const Color(0xFF102A1C)
                          : const Color(0xFF2C1618),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: job.isPaid
                            ? const Color(0xFF166534)
                            : const Color(0xFF991B1B),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          job.isPaid
                              ? Icons.check_circle_rounded
                              : Icons.pending_actions_rounded,
                          size: 12.sp,
                          color: job.isPaid
                              ? const Color(0xFF4ADE80)
                              : const Color(0xFFF87171),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          job.isPaid ? "PAID" : "UNPAID",
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: job.isPaid
                                ? const Color(0xFF4ADE80)
                                : const Color(0xFFF87171),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // "View Details >" Prompt
                Row(
                  children: [
                    Text(
                      "View Details",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.sp,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(BuildContext context) {
    final dateStr = DateFormat(
      'EEEE, MMM d',
    ).format(controller.selectedDate.value);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75.r,
              height: 75.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF141416),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 34.sp,
                color: AppColors.gray100,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "No bookings for $dateStr",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              "Your direct schedule is clear for this date. You can add a new private booking anytime.",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.gray100,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openAddJobSheet(BuildContext context) {
    Get.to(() => const AddScheduleJobSheet());
  }
}
