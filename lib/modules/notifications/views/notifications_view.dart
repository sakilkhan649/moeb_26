import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/data/models/Notifications_Model.dart';
import 'package:moeb_26/modules/my_jobs/controllers/my_jobs_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Notifications',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          // Sub-header displaying unread count and Read All action
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${controller.unreadCount} unread notifications",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.markAllAsRead(),
                    child: Text(
                      "Read All",
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
          ),
          const Divider(color: Colors.white10, height: 1),

          // Notifications List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchNotifications();
              },
              color: const Color(0xFFD08700),
              backgroundColor: const Color(0xFF1A1A1A),
              child: Obx(() {
                if (controller.notifications.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 200.h),
                        child: Center(
                          child: Text(
                            "No notifications",
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
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
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    Color iconBgColor = Colors.white.withValues(alpha: 0.05);
    Color iconColor = Colors.white;

    // Logic for icon colors based on type
    if (notification.type == "GENERAL") {
      iconColor = const Color(0xFFD08700);
      iconBgColor = const Color(0xFFD08700).withValues(alpha: 0.1);
    } else if (notification.type == "TASK") {
      iconColor = const Color(0xFF3498DB);
      iconBgColor = const Color(0xFF3498DB).withValues(alpha: 0.1);
    } else if (notification.type == "REMINDER") {
      iconColor = const Color(0xFF2ECC71);
      iconBgColor = const Color(0xFF2ECC71).withValues(alpha: 0.1);
    } else if (notification.type == "MESSAGE") {
      iconColor = const Color(0xFF9B59B6);
      iconBgColor = const Color(0xFF9B59B6).withValues(alpha: 0.1);
    }

    return Obx(() {
      final currentNoti = controller.notifications.firstWhere(
        (n) => n.id == notification.id,
        orElse: () => notification,
      );
      final isMuted = controller.isMuted(currentNoti.id);

      return Dismissible(
        key: Key(currentNoti.id),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Swipe Left -> Delete
            await controller.deleteNotification(currentNoti.id);
            Get.snackbar(
              'Deleted',
              'Notification deleted successfully.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withValues(alpha: 0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            return true;
          } else {
            // Swipe Right -> Mute/Unmute
            await controller.toggleMuteNotification(currentNoti.id);
            final mutedState = controller.isMuted(currentNoti.id);
            Get.snackbar(
              mutedState ? 'Muted' : 'Unmuted',
              mutedState ? 'Notification muted.' : 'Notification unmuted.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: (mutedState ? Colors.blue : Colors.green).withValues(alpha: 0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            return false;
          }
        },
        background: Container(
          color: isMuted ? Colors.green.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.15),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Icon(
                isMuted ? Icons.notifications_active : Icons.notifications_off,
                color: isMuted ? Colors.green : Colors.blue,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                isMuted ? "Unmute" : "Mute",
                style: GoogleFonts.inter(
                  color: isMuted ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red.withValues(alpha: 0.15),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Delete",
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.delete,
                color: Colors.red,
                size: 24.sp,
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            // Mark as read when clicked
            if (!currentNoti.isRead) {
              controller.markAsRead(currentNoti.id);
            }

            // Close notification overlay dialog
            Get.back();

            // Direct route navigation based on type & content keywords
            final type = currentNoti.type.toUpperCase();
            final title = currentNoti.title.toLowerCase();
            final subtitle = currentNoti.subtitle.toLowerCase();

            if (type == 'MESSAGE' || title.contains('message') || title.contains('chat') || subtitle.contains('message') || subtitle.contains('chat')) {
              Get.toNamed(Routes.chatView);
            } else if (type == 'TASK' || title.contains('job') || subtitle.contains('job') || title.contains('acceptance')) {
              final BookingController bookingController =
                  Get.isRegistered<BookingController>()
                  ? Get.find<BookingController>()
                  : Get.put(BookingController());
              bookingController.isJobAcceptanceView.value = true;
              Get.toNamed(Routes.myJobsView);
            } else if (type == 'REMINDER' || title.contains('deal') || subtitle.contains('deal') || title.contains('offer') || title.contains('saving')) {
              Get.toNamed(Routes.dealsView);
            } else if (title.contains('invoice') || title.contains('payment') || subtitle.contains('invoice') || subtitle.contains('payment')) {
              Get.toNamed(Routes.invoiceHistoryView);
            } else if (title.contains('item') || title.contains('market') || subtitle.contains('item') || subtitle.contains('market')) {
              Get.toNamed(Routes.myItemsView);
            } else {
              Get.toNamed(Routes.bottomNabbarView);
            }
          },
          child: Opacity(
            opacity: isMuted ? 0.4 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: currentNoti.isRead
                    ? Colors.transparent
                    : const Color(0xFFD08700).withValues(alpha: 0.05),
                border: Border(
                  left: BorderSide(
                    color: currentNoti.isRead ? Colors.transparent : const Color(0xFFD08700),
                    width: 3.5.w,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: 16.5.w,
                right: 20.w,
                top: 16.h,
                bottom: 16.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container
                  Container(
                    height: 48.w,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: currentNoti.isRead
                          ? iconBgColor.withValues(alpha: 0.04)
                          : iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      currentNoti.icon,
                      colorFilter: ColorFilter.mode(
                        currentNoti.isRead ? iconColor.withValues(alpha: 0.5) : iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentNoti.title,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: currentNoti.isRead
                                      ? FontWeight.w400
                                      : FontWeight.bold,
                                  color: currentNoti.isRead
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (isMuted) ...[
                              Icon(
                                Icons.notifications_off,
                                size: 14.sp,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            if (!currentNoti.isRead)
                              Container(
                                width: 8.w,
                                height: 8.w,
                                margin: EdgeInsets.only(top: 4.h),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD08700),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFD08700),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              )
                            else
                              Icon(
                                Icons.done_all_rounded,
                                size: 16.sp,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          currentNoti.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: currentNoti.isRead
                                ? FontWeight.w300
                                : FontWeight.w500,
                            color: currentNoti.isRead
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.85),
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12.sp,
                              color: currentNoti.isRead
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.55),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                currentNoti.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: currentNoti.isRead ? FontWeight.w300 : FontWeight.w400,
                                  color: currentNoti.isRead
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.55),
                                ),
                                overflow: TextOverflow.ellipsis,
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
        ),
      );
    });
  }
}
