import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/Views/home/JobOfferPage/Notifications/Notifications_popup.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/EditProfileBottomSheet.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/LogoutBottomSheet.dart';
import 'package:moeb_26/widgets/Contact_support_popup.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orange100),
            );
          }
          return SingleChildScrollView(
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
                            radius: 35.r,
                            backgroundImage:
                                controller.profilePicture.value.isNotEmpty
                                ? NetworkImage(controller.profilePicture.value)
                                : AssetImage(AppImages.sadat_image)
                                      as ImageProvider,
                          ),
                        ),
                        // Profile Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.fullName.value,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 2.h),

                              Text(
                                controller.ecn.value,
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.orange100,
                                    size: 15.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Flexible(
                                    child: Text(
                                      controller.rating.value.toString(),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
                                    size: 30.sp,
                                  ),
                                  Positioned(
                                    top: -2.w,
                                    right: -1.w,
                                    child: Container(
                                      width: 15.w,
                                      height: 15.w,
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
                            SizedBox(width: 10.w),
                            PopupMenuButton<int>(
                              icon: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                              color: const Color(0xFF1E1E1E), // Dark background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: const BorderSide(
                                  color: Color(0xFF364153),
                                ),
                              ),
                              offset: const Offset(0, 50),
                              onSelected: (item) {
                                switch (item) {
                                  case 0:
                                    Get.offNamed(Routes.profileScreen);
                                    break;
                                  case 1:
                                    Get.toNamed(Routes.myJobsScreen);
                                    break;
                                  case 2:
                                    Get.toNamed(Routes.serviceArea);
                                    break;
                                  case 3:
                                    Get.bottomSheet(
                                      const LogoutBottomSheet(),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                    break;
                                  case 4:
                                    Get.toNamed(Routes.myPropucts);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                // PopupMenuItem<int>(
                                //   value: 0,
                                //   child: Row(
                                //     children: [
                                //       Icon(
                                //         Icons.person_outline,
                                //         color: Colors.white,
                                //         size: 24.sp,
                                //       ),
                                //       SizedBox(width: 12.w),
                                //       Text(
                                //         'Account',
                                //         style: GoogleFonts.inter(
                                //           color: Colors.white,
                                //           fontSize: 14.sp,
                                //           fontWeight: FontWeight.w500,
                                //         ),
                                //       ),
                                //       const Spacer(),
                                //       Icon(
                                //         CupertinoIcons.chevron_forward,
                                //         size: 20.sp,
                                //         color: Colors.white,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.job_offer_icon,
                                        width: 24.sp,
                                        height: 24.sp,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'My Jobs',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        CupertinoIcons.chevron_forward,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Service Area',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        CupertinoIcons.chevron_forward,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'My Items',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        CupertinoIcons.chevron_forward,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                // PopupMenuItem<int>(
                                //   value: 3,
                                //   child: Row(
                                //     children: [
                                //       Icon(
                                //         Icons.logout_outlined,
                                //         color: Colors.white,
                                //         size: 24.sp,
                                //       ),
                                //       SizedBox(width: 12.w),
                                //       Text(
                                //         'Logout',
                                //         style: GoogleFonts.inter(
                                //           color: Colors.white,
                                //           fontSize: 14.sp,
                                //           fontWeight: FontWeight.w500,
                                //         ),
                                //       ),
                                //       const Spacer(),
                                //       Icon(
                                //         CupertinoIcons.chevron_forward,
                                //         size: 20.sp,
                                //         color: Colors.white,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // Action Buttons
                    Wrap(
                      spacing: 10.w,
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
                          Get.toNamed(
                            Routes.vehicleinformation,
                            arguments: {
                              "vehicles":
                                  controller.userProfile.value?.vehicles,
                            },
                          );
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
                  child: Column(
                    children: (controller.userProfile.value?.vehicles ?? [])
                        .where(
                          (vehicle) => vehicle.carType.toUpperCase() != "SUV",
                        )
                        .map((vehicle) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${vehicle.year} ${vehicle.make} ${vehicle.model}",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${vehicle.carType} • ${vehicle.licensePlate}",
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
                                      vehicle.carType.toUpperCase(),
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
                          );
                        })
                        .toList(),
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
                        SvgPicture.asset(
                          AppIcons.ratings_icon,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        "Ratings & Feedback",
                        onTap: () => Get.toNamed(Routes.ratingsFeedback),
                      ),
                      _buildSettingItem(
                        SvgPicture.asset(
                          AppIcons.settings_icon,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        "Terms & Condition",
                        onTap: () => Get.toNamed(Routes.termPolicy),
                      ),
                      _buildSettingItem(
                        SvgPicture.asset(
                          AppIcons.support_icon,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        "Support and Report",
                        onTap: () => showContactSupportBottomSheet(),
                      ),
                      _buildSettingItem(
                        SvgPicture.asset(
                          AppIcons.password_icon,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        "Password Change",
                        onTap: () => Get.toNamed(Routes.changePasswordScreen),
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
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeaderButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
      padding: EdgeInsets.only(left: 20.w, top: 5.h, bottom: 5.h),
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            flex: 3,
            child: Obx(
              () => Text(
                value.value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(Widget icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      onTap: onTap,
    );
  }
}
