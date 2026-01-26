import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import 'Job_Bottom_sheet/Job_Bottom_sheet.dart';
import 'Notifications/Notifications_popup.dart';

class Jobofferpage extends StatelessWidget {
  const Jobofferpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppImages.app_logo, // Replace with your logo asset
                    height: 60.w, // Make the logo responsive
                    width: 60.w,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: Stack(
                          clipBehavior: Clip.none, // Allow badge to overflow
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: 30.sp, // Icon size responsive
                              color: Colors.white,
                            ),
                            Positioned(
                              top: -6.w, // Adjust the badge position
                              right: -5.w, // Adjust the badge position
                              child: Container(
                                width: 20.w, // Badge size responsive
                                height: 20.w,
                                decoration: BoxDecoration(
                                  color: Colors.orange, // Badge color
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '3', // Notification count
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp, // Font size responsive
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Show the custom notification dialog on button press
                          showDialog(
                            context: context, // Required for showing the dialog
                            builder: (BuildContext context) {
                              return CustomNotificationPopup(); // Display the notification dialog
                            },
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person_outline,
                          size: 30.sp, // Icon size responsive
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomJobButton(text: "New Job", onPressed: () {
              Get.bottomSheet(
                PostJobBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            }),
          ],
        ),
      ),
    );
  }
}
