import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';
import 'package:moeb_26/modules/auth/profile/views/personal_information_view.dart';
import 'package:moeb_26/modules/auth/profile/views/payment_information_view.dart';
import 'package:moeb_26/core/widgets/LogoutBottomSheet.dart';
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
        title: 'My Profile',
        showBackButton: false,
        showActions: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserProfile();
          },
          color: const Color(0xFFD08700),
          backgroundColor: Colors.black,
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.userProfile.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFD08700)),
              );
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- HEADER PROFILE CARD ---
                  Stack(
                    children: [
                      Container(
                        width: 105.w,
                        height: 105.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD08700),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD08700).withValues(alpha: 0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(55.w),
                          child: controller.profilePicture.value.isNotEmpty
                              ? Image.network(
                                  controller.profilePicture.value,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  AppImages.sadat_image,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 2.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD08700),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 12.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                controller.rating.value.toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // --- USER NAME ---
                  Text(
                    controller.fullName.value +
                        (controller.nickName.value.isNotEmpty
                            ? ' (${controller.nickName.value})'
                            : ''),
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFEDB9B), // Soft peach-yellow
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // --- VERIFIED BADGE ---
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        color: const Color(0xFFD08700),
                        size: 15.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Verified Professional Chauffeur',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD5C4AB),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // --- CATEGORY 1: ACCOUNT & DRIVER DETAILS ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account & Driver Details',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD5C4AB),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF2C2C2C),
                        width: 0.98,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          icon: Icons.person_outline_rounded,
                          title: "Personal & Driver Information",
                          subtitle: "Manage email, phone, company & languages",
                          onTap: () {
                            Get.to(() => const PersonalInformationView());
                          },
                        ),
                        _buildTileDivider(),
                        _buildSettingTile(
                          icon: Icons.account_balance_wallet_outlined,
                          title: "Payment Methods & Payouts",
                          subtitle: "Manage Zelle, Venmo, Cash App & Card",
                          onTap: () {
                            Get.to(() => const PaymentInformationView());
                          },
                        ),
                        _buildTileDivider(),
                        _buildSettingTile(
                          icon: Icons.directions_car_outlined,
                          title: "My Vehicles",
                          subtitle: "Manage and select active vehicles",
                          onTap: () {
                            Get.toNamed(
                              Routes.allVehicleView,
                              arguments: {
                                "vehicles":
                                    controller.userProfile.value?.vehicles,
                              },
                            );
                          },
                        ),
                        _buildTileDivider(),
                        _buildSettingTile(
                          icon: Icons.document_scanner_outlined,
                          title: "Personal Documents",
                          subtitle: "License and verification documents",
                          onTap: () {
                            Get.toNamed(Routes.personalDocumentView);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // --- CATEGORY 2: PREFERENCES & SUPPORT ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Preferences & Support',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD5C4AB),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF2C2C2C),
                        width: 0.98,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          icon: Icons.star_outline_rounded,
                          title: "Ratings & Feedback",
                          onTap: () => Get.toNamed(Routes.ratingsFeedbackView),
                        ),
                        Obx(
                          () => Column(
                            children: controller.legalPages.map((legal) {
                              return Column(
                                children: [
                                  _buildTileDivider(),
                                  _buildSettingTile(
                                    icon: Icons.description_outlined,
                                    title: legal['title'] ?? "",
                                    onTap: () => Get.toNamed(
                                      Routes.termPolicyView,
                                      arguments: {"slug": legal['slug']},
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        _buildTileDivider(),
                        _buildSettingTile(
                          icon: Icons.headset_mic_outlined,
                          title: "Support and Report",
                          onTap: () => showContactSupportBottomSheet(),
                        ),
                        _buildTileDivider(),
                        _buildSettingTile(
                          icon: Icons.lock_outline_rounded,
                          title: "Password Change",
                          onTap: () => Get.toNamed(Routes.changePasswordView),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // --- ACTIONS: LOG OUT & DELETE ACCOUNT ---
                  Row(
                    children: [
                      // Log Out Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.bottomSheet(
                              LogoutBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: const Color(0xFFEF4444),
                                size: 17.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Log Out",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFEF4444),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Delete Account Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.bottomSheet(
                              DeleteAccountBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: const Color(0xFFEF4444),
                                size: 17.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Delete Account",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFEF4444),
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
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- REUSABLE UI BUILDERS ---

  Widget _buildTileDivider() {
    return const Divider(
      color: Color(0xFF2C2C2C),
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: const Color(0xFF27272A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: const Color(0xFFD5C4AB), size: 19.sp),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(
                color: const Color(0xFF71717A),
                fontSize: 11.sp,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: const Color(0xFF71717A),
        size: 14.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      onTap: onTap,
    );
  }
}
