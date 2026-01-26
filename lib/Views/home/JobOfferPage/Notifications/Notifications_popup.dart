import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';

import 'Controller/Notifications_Controller.dart';
import 'Models/Notifications_Model.dart';

// Notification Controller - notification manage করার জন্য

class CustomNotificationPopup extends StatelessWidget {
  CustomNotificationPopup({super.key});

  // Controller initialize
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              // Header - Notifications title এবং close button
              _buildHeader(context),

              // Body - Notifications list
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Unread count এবং Clear All button
                    _buildTopSection(),
                    CustomTextgray(text: "notifications"),

                    SizedBox(height: 10.h),

                    // Notifications list - Obx দিয়ে reactive করা
                    Obx(() {
                      // যদি কোনো notification না থাকে
                      if (controller.notifications.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: CustomTextgray(
                              text: "No notifications",
                              fontSize: 15.sp,
                            ),
                          ),
                        );
                      }

                      // Notifications list দেখানো
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.notifications.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final notification = controller.notifications[index];
                          return _buildNotificationCard(notification, index);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header Widget - Title এবং Close button
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: "Notifications", fontSize: 20.sp, color: Colors.white),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  // Top Section - Unread count এবং Clear All
  Widget _buildTopSection() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextgray(
            text: "${controller.unreadCount} unread ",
            fontSize: 15.sp,
          ),
          TextButton(
            onPressed: () {
              // Clear All button click করলে সব notifications clear হবে
              controller.clearAll();
            },
            child: CustomTextgray(
              text: "Clear All",
              color: const Color(0xFFD08700),
            ),
          ),
        ],
      ),
    );
  }

  // Single Notification Card Widget
  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification header - Icon, Title, Check mark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    notification.icon,
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: notification.title,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ],
              ),
              const Icon(Icons.check, size: 15, color: Color(0xFFD08700)),
            ],
          ),

          SizedBox(height: 10.h),

          // Notification message
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: CustomTextgray(text: notification.message),
          ),

          // Time এবং date icon
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: const Icon(
                  Icons.date_range,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 5.w),
              CustomTextgray(text: notification.time),
            ],
          ),
        ],
      ),
    );
  }
}
