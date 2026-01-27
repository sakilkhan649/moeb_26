import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Utils/app_images.dart';
import '../Notifications/Notifications_popup.dart';
import 'Controller/My_job_controller.dart';

class MyJobsScreen extends StatelessWidget {
  MyJobsScreen({super.key});

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
        child: Column(
          children: [
            /// ================= TOP BAR =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppImages.app_logo, height: 60.w, width: 60.w),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomNotificationPopup(),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            size: 30.sp,
                            color: Colors.white,
                          ),
                          Positioned(
                            top: -6.w,
                            right: -5.w,
                            child: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_outline,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// ================= JOB CARD =================
            Obx(() {
              if (controller.isDeleted.value) {
                return Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    "Item Deleted",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                );
              }

              return Container(
                width: 0.9.sw,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tue, Jan 20 · 08:30 AM",
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                            size: 18.sp,
                          ),
                          color: const Color(0xFF2A2A2A),
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.snackbar(
                                "Edit",
                                "Edit clicked",
                                colorText: Colors.white,
                                backgroundColor: Colors.black,
                              );
                            } else {
                              _showDeleteDialog();
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// PU / DO
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 13.sp),
                              children: const [
                                TextSpan(
                                  text: "PU: ",
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: "Dhaka Airport",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            "SEDAN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13.sp),
                        children: const [
                          TextSpan(
                            text: "DO: ",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: "Barisal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _info("Flight Number", "Flight AA 1234"),
                    _info("Payment Method", "Collect"),
                    _info("Special Instructions", "Airport Expert, VIP Client"),
                    _info("Payment", "\$125"),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ================= INFO FIELD =================
  Widget _info(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
          SizedBox(height: 6.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              value,
              style: TextStyle(color: Colors.amber, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DELETE DIALOG =================
  void _showDeleteDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure to delete?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: Get.back,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black, fontSize: 13.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8A032),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.deleteItem();
                        Get.snackbar(
                          "Deleted",
                          "Item deleted successfully",
                          colorText: Colors.white,
                          backgroundColor: Colors.black,
                        );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
