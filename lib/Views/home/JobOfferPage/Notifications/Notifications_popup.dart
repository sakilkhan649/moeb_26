import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Core/routs.dart';

import 'package:moeb_26/Views/home/JobOfferPage/My_jobs/Controller/My_job_controller.dart';

import 'Controller/Notifications_Controller.dart';
import 'Models/Notifications_Model.dart';

class CustomNotificationPopup extends StatelessWidget {
  CustomNotificationPopup({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.6),
                          size: 24.sp,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.unreadCount} unread notifications",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.clearAll(),
                          child: Text(
                            "Clear All",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFFD08700),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white10, height: 1),

            // Notifications List
            Flexible(
              child: Obx(() {
                if (controller.notifications.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Text(
                        "No notifications",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _buildNotificationItem(notification);
                  },
                );
              }),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    Color iconBgColor = Colors.white.withOpacity(0.05);
    Color iconColor = Colors.white;

    // Logic for icon colors based on title/type
    if (notification.title.contains("Job")) {
      iconColor = const Color(0xFFD08700);
      iconBgColor = const Color(0xFFD08700).withOpacity(0.1);
    } else if (notification.title.contains("Message")) {
      iconColor = const Color(0xFF3498DB);
      iconBgColor = const Color(0xFF3498DB).withOpacity(0.1);
    } else if (notification.title.contains("Item")) {
      iconColor = const Color(0xFF2ECC71);
      iconBgColor = const Color(0xFF2ECC71).withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () {
        if (notification.title == "Job Acceptance") {
          final BookingController bookingController = Get.put(
            BookingController(),
          );
          bookingController.setJobAcceptanceView(true);
          Get.back(); // Close the popup
          Get.toNamed(Routes.myJobsScreen);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              height: 48.w,
              width: 48.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12.w),
              child: SvgPicture.asset(
                notification.icon,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 16.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.check,
                        size: 16.sp,
                        color: const Color(0xFFD08700),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12.sp,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        notification.time,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.4),
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
    );
  }
}
