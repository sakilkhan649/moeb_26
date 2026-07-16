import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';
import 'package:moeb_26/core/widgets/EditProfileBottomSheet.dart';
import 'package:moeb_26/core/widgets/LogoutBottomSheet.dart';
import 'package:moeb_26/modules/jobs_offers/views/Job_offer_view.dart';
import 'package:moeb_26/core/widgets/Contact_support_popup.dart';
import 'package:moeb_26/core/widgets/DeleteAccountBottomSheet.dart';
import 'package:moeb_26/core/widgets/Custom_AppBar.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Profile',
        subtitle: 'CHAUFFEUR PROFILE DETAILS',
        showBackButton: false,
        showActions: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserProfile();
          },
          color: AppColors.orange100,
          backgroundColor: Colors.black,
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.userProfile.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange100),
              );
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),

                  // Profile Info Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 42.r,
                          backgroundImage:
                              controller.profilePicture.value.isNotEmpty
                              ? NetworkImage(controller.profilePicture.value)
                              : AssetImage(AppImages.sadat_image)
                                    as ImageProvider,
                        ),
                        SizedBox(width: 14.w),
                        // Profile Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Obx(
                                () => Text(
                                  controller.fullName.value,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Rating
                              Obx(
                                () => Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.orange100,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      controller.rating.value.toString(),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit Button — styled as orange background button with text and edit icon on the far right
                        PopupMenuButton<int>(
                          padding: EdgeInsets.zero,
                          color: const Color(0xFF000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            side: const BorderSide(
                              color: Color(0xFF364153),
                              width: 1,
                            ),
                          ),
                          offset: const Offset(0, 50),
                          onSelected: (item) {
                            switch (item) {
                              case 0:
                                Get.bottomSheet(
                                  EditProfileBottomSheet(),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                );
                                break;
                              case 1:
                                Get.toNamed(
                                  Routes.allVehicleView,
                                  arguments: {
                                    "vehicles":
                                        controller.userProfile.value?.vehicles,
                                  },
                                );
                                break;
                              case 2:
                                Get.toNamed(Routes.serviceAreaView);
                                break;
                              case 3:
                                Get.toNamed(Routes.personalDocumentView);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            _buildPopupItem(0, Icons.person_outline, "Profile"),
                            _buildPopupItem(
                              1,
                              Icons.directions_car_outlined,
                              "Vehicle",
                            ),
                            _buildPopupItem(
                              2,
                              Icons.location_on_outlined,
                              "Service Area",
                            ),
                            _buildPopupItem(
                              3,
                              Icons.document_scanner_outlined,
                              "Personal doc",
                            ),
                          ],
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orange100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.edit_icon_myjob,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  width: 18.sp,
                                  height: 18.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Edit",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Divider(
                    color: Colors.grey.withValues(alpha: 0.15),
                    thickness: 0.8.h,
                  ),

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
                  Divider(
                    color: Colors.grey.withValues(alpha: 0.2),
                    thickness: 1.h,
                  ),

                  // My Vehicles Section
                  _buildSectionTitle("My Vehicles"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Obx(() {
                      final vehicles =
                          controller.userProfile.value?.vehicles ?? [];
                      if (vehicles.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: Text(
                              "No vehicles added",
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: vehicles.map((vehicle) {
                          final vehicleStyle =
                              VehicleTypeColors.getVehicleStyle(
                                vehicle.carType,
                              );
                          final isSelected =
                              controller.userProfile.value?.selectedVehicle ==
                              vehicle.id;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: GestureDetector(
                              onTap: () {
                                if (!isSelected) {
                                  controller.updateSelectedVehicle(vehicle.id);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: isSelected ? 1.5.w : 1.w,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.directions_car,
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.grey,
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                    if (isSelected)
                                      Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 20.sp,
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: vehicleStyle is Color
                                            ? vehicleStyle
                                            : null,
                                        gradient: vehicleStyle is Gradient
                                            ? vehicleStyle
                                            : null,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
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
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: Colors.grey.withValues(alpha: 0.2),
                    thickness: 1.h,
                  ),

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
                          onTap: () => Get.toNamed(Routes.ratingsFeedbackView),
                        ),

                        Obx(
                          () => Column(
                            children: controller.legalPages.map((legal) {
                              return _buildSettingItem(
                                SvgPicture.asset(
                                  AppIcons.settings_icon,
                                  height: 24.sp,
                                  width: 24.sp,
                                ),
                                legal['title'] ?? "",
                                onTap: () => Get.toNamed(
                                  Routes.termPolicyView,
                                  arguments: {"slug": legal['slug']},
                                ),
                              );
                            }).toList(),
                          ),
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
                          onTap: () => Get.toNamed(Routes.changePasswordView),
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
                  // Delete Account Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          DeleteAccountBottomSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.5),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Delete Account",
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
      ),
    );
  }

  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String title) {
    return PopupMenuItem<int>(
      value: value,
      height: 45.h,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_forward,
            size: 18.sp,
            color: Colors.white,
          ),
        ],
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
