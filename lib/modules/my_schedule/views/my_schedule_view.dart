import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/modules/my_schedule/controllers/my_schedule_controller.dart';
import 'package:moeb_26/modules/my_schedule/models/my_schedule_job_model.dart';
import 'package:moeb_26/modules/my_schedule/views/widgets/add_schedule_job_sheet.dart';

class MyScheduleView extends GetView<MyScheduleController> {
  const MyScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: const CustomSubAppBar(
        title: "My Schedule",
      ),
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

          // Horizontal Weekly Calendar Strip
          _buildWeeklyCalendarStrip(),

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
                  bottom: 95.h, // Bottom spacing so scrolling content moves above FAB
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
          Icon(
            Icons.lock_outline,
            size: 16.sp,
            color: AppColors.primaryColor,
          ),
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

  // Horizontal Weekly Calendar Strip
  Widget _buildWeeklyCalendarStrip() {
    return Container(
      height: 85.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: const BoxDecoration(
        color: Color(0xFF141416),
        border: Border(
          bottom: BorderSide(color: Color(0xFF24242A), width: 1),
        ),
      ),
      child: Obx(() {
        final selected = controller.selectedDate.value;
        final startDate = DateTime.now().subtract(const Duration(days: 3));

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: 14,
          itemBuilder: (context, index) {
            final date = startDate.add(Duration(days: index));
            final isSelected = date.year == selected.year &&
                date.month == selected.month &&
                date.day == selected.day;

            final isToday = date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;

            final hasJobs = controller.hasJobsOnDate(date);

            return GestureDetector(
              onTap: () => controller.selectDate(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 56.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFF1E1E22),
                  borderRadius: BorderRadius.circular(14.r),
                  border: isToday && !isSelected
                      ? Border.all(color: AppColors.primaryColor, width: 1.2)
                      : Border.all(color: const Color(0xFF2B2B32), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date).toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : AppColors.gray100,
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
                    SizedBox(height: 4.h),
                    if (hasJobs)
                      Container(
                        width: 5.r,
                        height: 5.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.black : AppColors.primaryColor,
                        ),
                      )
                    else
                      SizedBox(height: 5.r),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Job Card Widget
  Widget _buildJobCard(BuildContext context, MyScheduleJobModel job) {
    final isDispatched = job.isDispatchedToNetwork;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141416),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDispatched
              ? AppColors.primaryColor.withOpacity(0.6)
              : const Color(0xFF24242A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF222228),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 13.sp, color: AppColors.gray100),
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
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF222228),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  job.vehicleType,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray100,
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

          // Client Name & Phone Call Action
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
              GestureDetector(
                onTap: () => controller.makePhoneCall(job.clientPhone),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: Color(0xFF24242A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, size: 16.sp, color: AppColors.primaryColor),
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

          if (job.notes.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C20),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "Notes: ${job.notes}",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontStyle: FontStyle.italic,
                  color: AppColors.gray100,
                ),
              ),
            ),
          ],

          SizedBox(height: 14.h),
          const Divider(height: 1, color: Color(0xFF24242A)),
          SizedBox(height: 12.h),

          // Card Action Buttons (Edit, Cancel, Dispatch to Network)
          Row(
            children: [
              GestureDetector(
                onTap: () => _openEditJobSheet(context, job),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.edit_icon,
                        width: 16.sp,
                        height: 16.sp,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray100,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Edit",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.gray100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => _confirmDeleteJob(context, job.id),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.delete_icon,
                        width: 16.sp,
                        height: 16.sp,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray100,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Delete",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.gray100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (isDispatched)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF24242A),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 14.sp, color: AppColors.primaryColor),
                      SizedBox(width: 4.w),
                      Text(
                        "Dispatched",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: 145.w,
                  child: CustomButton(
                    text: "Dispatch to Network",
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    onPressed: () => _confirmDispatchToNetwork(context, job),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(BuildContext context) {
    final dateStr = DateFormat('EEEE, MMM d').format(controller.selectedDate.value);

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
            SizedBox(height: 24.h),
            CustomButton(
              text: "Add New Booking",
              onPressed: () => _openAddJobSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddJobSheet(BuildContext context) {
    Get.to(() => const AddScheduleJobSheet());
  }

  void _openEditJobSheet(BuildContext context, MyScheduleJobModel job) {
    Get.to(() => AddScheduleJobSheet(existingJob: job));
  }

  void _confirmDeleteJob(BuildContext context, String jobId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E22),
        title: Text("Cancel Booking?", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to remove this booking from your private schedule?",
          style: GoogleFonts.inter(color: AppColors.gray100),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("No", style: GoogleFonts.inter(color: AppColors.gray100)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF24242A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              controller.deleteJob(jobId);
            },
            child: Text("Yes, Remove", style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDispatchToNetwork(BuildContext context, MyScheduleJobModel job) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E22),
        title: Row(
          children: [
            Icon(Icons.share, color: AppColors.primaryColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text("Pass Job to Network?", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
          ],
        ),
        content: Text(
          "Do you want to dispatch ${job.clientName}'s trip (${job.pickupLocation} -> ${job.dropoffLocation}) to the public chauffeur network?",
          style: GoogleFonts.inter(color: AppColors.gray100, fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.inter(color: AppColors.gray100)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Get.back();
              controller.dispatchToNetwork(job);
            },
            child: Text("Dispatch Now", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
