import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Views/home/JobOfferPage/Notifications/Notifications_popup.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/EditProfileBottomSheet.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/LogoutBottomSheet.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Segment
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundImage: AssetImage(AppImages.sadat_image),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Profile Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Text(
                                    controller.fullName.value,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.shield_outlined,
                                  color: AppColors.orange100,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Obx(
                              () => Text(
                                controller.ecn.value,
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.orange100,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 4.w),
                                Obx(
                                  () => Text(
                                    controller.rating.value.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Header Icons
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomNotificationPopup();
                                },
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                                Positioned(
                                  top: -4.w,
                                  right: -2.w,
                                  child: Container(
                                    width: 16.w,
                                    height: 16.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.orange100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "3",
                                        style: TextStyle(
                                          color: Colors.black,
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
                          SizedBox(width: 16.w),
                          Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(cardColor: Colors.white),
                            child: PopupMenuButton<int>(
                              icon: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                              offset: Offset(0, 40.h),
                              onSelected: (item) {
                                switch (item) {
                                  case 0:
                                    // Refresh current page or navigate to account
                                    Get.offNamed(Routes.profileScreen);
                                    break;
                                  case 1:
                                    Get.toNamed(Routes.myJobsScreen);
                                    break;
                                  case 2:
                                    Get.bottomSheet(
                                      const LogoutBottomSheet(),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: _buildPopupItem(
                                    Icons.person_outline,
                                    'Account',
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: _buildPopupItem(
                                    Icons.work_outline,
                                    'My Jobs',
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: _buildPopupItem(
                                    Icons.logout_outlined,
                                    'Logout',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Action Buttons
                  Wrap(
                    spacing: 15.w,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildHeaderButton("Edit Profile", () {
                        Get.bottomSheet(
                          EditProfileBottomSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      }),
                      _buildHeaderButton("Edit Vehicles", () {
                        Get.toNamed(Routes.vehicleinformation);
                      }),
                      _buildHeaderButton("My Jobs", () {
                        Get.toNamed(Routes.myJobsScreen);
                      }),
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.grey.withOpacity(0.2), thickness: 1.h),

              // Account Details Section
              _buildSectionTitle("Account Details"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _buildDetailRow("Email", controller.email),
                    _buildDetailRow("Phone", controller.phone),
                    _buildDetailRow("Service Area", controller.serviceArea),
                    _buildDetailRow("Nick Name", controller.nickName),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: Colors.grey.withOpacity(0.2), thickness: 1.h),

              // My Vehicles Section
              _buildSectionTitle("My Vehicles"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2024 M S",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Sedan • AV23",
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "SEDAN",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: Colors.grey.withOpacity(0.2), thickness: 1.h),

              // Settings List
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    _buildSettingItem(
                      Icons.chat_bubble_outline,
                      "Ratings & Feedback",
                    ),
                    _buildSettingItem(
                      Icons.settings_outlined,
                      "Terms & Condition",
                    ),
                    _buildSettingItem(
                      Icons.support_agent_outlined,
                      "Support and Report",
                    ),
                  ],
                ),
              ),

              // Log Out Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      LogoutBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Log Out",
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.orange100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 16.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, RxString value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
          ),
          Obx(
            () => Text(
              value.value,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 22.sp),
      title: Text(
        title,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      onTap: () {},
    );
  }

  Widget _buildPopupItem(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 20.sp),
        SizedBox(width: 10.w),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Icon(Icons.arrow_forward_ios, color: Colors.black, size: 14.sp),
      ],
    );
  }
}
