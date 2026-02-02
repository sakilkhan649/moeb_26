import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import 'package:moeb_26/widgets/Custom_Back_Button.dart';
import 'package:moeb_26/widgets/Custom_InfoBox.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_icons.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
import '../../../../widgets/Custom_Card_Ditails.dart';
import '../../../../widgets/Custom_Driver_Card.dart';

class FinishRidePage extends StatefulWidget {
  const FinishRidePage({super.key});

  @override
  State<FinishRidePage> createState() => _FinishRidePageState();
}

class _FinishRidePageState extends State<FinishRidePage> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.white38, thickness: 1.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: CustomBackButton(title: "Ride Details"),
            ),
            Divider(color: Colors.white38, thickness: 1.h),
            SizedBox(height: 5.h),
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomDriverCard(
                    profileImage: AppImages.profile_image,
                    name: "Khaled",
                    rating: "5.0",
                    vehicleNumber: "ECN-1",
                    vehicleInfo: "BMW 7 Series, Black",
                    buttonText: "Chat with Job Poster",
                    buttonIcon: Icons.chat_bubble_outline, // যেকোনো icon
                    onButtonPressed: () {
                      Get.toNamed(Routes.chatPage);
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                // Status Steps Container (You can use this in your widget tree)
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomJobDetailsCard(
                    // Location details
                    pickupLocation: "Dhaka Airport",
                    dropoffLocation: "Barisal",

                    // Job information
                    flightNumber: "Flight AA 1234",
                    dateTime: "Jan 20 · 08:30 AM",
                    vehicleType: "SEDAN",
                    jobPoster: "Khaled",
                    company: "Khaled Transportation",
                    payment: "Collect",
                    amount: "\$125",

                    // Optional: Custom colors
                    backgroundColor: const Color(0xFF1C1C1C),
                    borderColor: const Color(0xFF2A2A2A),
                    labelColor: Colors.grey,
                    valueColor: Colors.white,
                    iconColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: CustomTextgray(text: "Special Instructions"),
                ),
                SizedBox(height: 10.h),
                CustomInfoBox(
                  text: "Bona nit. Flight AA 1234, VIP client, suit required",
                ),
                SizedBox(height: 10.h),


                Divider(color: Colors.white38, thickness: 1.h),
                SizedBox(height: 5.h),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      // Circular Action Button (Draggable)
                      Draggable<String>(
                        data: 'finish',
                        axis: Axis.horizontal,
                        onDragStarted: () {
                          setState(() {
                            _isDragging = true;
                          });
                        },
                        onDragEnd: (details) {
                          setState(() {
                            _isDragging = false;
                          });
                        },
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.orange100,
                              shape: BoxShape.circle,
                              // No shadow
                            ),
                            child: SvgPicture.asset(
                              AppIcons.arre_right_icon,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          width: 60.w,
                          height: 60.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.orange100.withOpacity(0.2),
                            shape: BoxShape.circle,
                            // No shadow
                          ),
                          child: SvgPicture.asset(
                            AppIcons.arre_right_icon,
                            color: Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.rideCompletedPage);
                          },
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.orange100,
                              shape: BoxShape.circle,
                              // No shadow
                            ),
                            child: SvgPicture.asset(
                              AppIcons.arre_right_icon,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Pill-shaped Finish Label (DragTarget)
                      Expanded(
                        child: DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            if (details.data == 'finish') {
                              Get.toNamed(Routes.rideCompletedPage);
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            bool isOver = candidateData.isNotEmpty;
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.rideCompletedPage);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 60.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isOver
                                      ? const Color(0xFFE1C16E)
                                      : const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(30.r),
                                  // No border
                                ),
                                child: CustomText(
                                  text: "Finish ride",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 80.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
