import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import '../controllers/personal_document_controller.dart';

class PersonalDocumentView extends StatelessWidget {
  PersonalDocumentView({super.key});

  final PersonalDocumentController controller =
      Get.isRegistered<PersonalDocumentController>()
          ? Get.find<PersonalDocumentController>()
          : Get.put(PersonalDocumentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomSubAppBar(title: "Compliance Documents"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFF1A1A1A),
          onRefresh: () => controller.fetchDocuments(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            children: [
              // 1. Info Banner (Clean & Subtle)
              _buildInfoBanner(),
              SizedBox(height: 16.h),

              // 2. Document Cards (Clean, Uncluttered & Neutral Icons)
              _buildDocumentCard(
                context: context,
                documentType: "DRIVING_LICENSE",
                title: "Driving License",
                icon: Icons.badge_outlined,
                statusRx: controller.drivingLicenseStatus,
                urlRx: controller.drivingLicenseUrl,
                expireController: controller.drivingLicenseExpireController,
              ),

              _buildDocumentCard(
                context: context,
                documentType: "HACK_LICENSE",
                title: "Hack License",
                icon: Icons.verified_user_outlined,
                statusRx: controller.hackLicenseStatus,
                urlRx: controller.hackLicenseUrl,
                expireController: controller.hackLicenseExpireController,
              ),

              _buildDocumentCard(
                context: context,
                documentType: "LOCAL_PERMIT",
                title: "Local Permit",
                icon: Icons.location_city_outlined,
                statusRx: controller.localPermitStatus,
                urlRx: controller.localPermitUrl,
                expireController: controller.localPermitExpireController,
              ),

              SizedBox(height: 12.h),

              // 3. Footer Notice
              _buildFooterNotice(),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  /// Informative banner (Minimal & Clean)
  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFF8E8E93),
              size: 17.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Keep your official credentials active to receive chauffeur bookings. Tap any document to view details, replace files, or update expiry dates.",
              style: GoogleFonts.inter(
                color: const Color(0xFF9E9E9E),
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Clean & Minimalist Document Card
  Widget _buildDocumentCard({
    required BuildContext context,
    required String documentType,
    required String title,
    required IconData icon,
    required RxnString statusRx,
    required RxnString urlRx,
    required TextEditingController expireController,
  }) {
    return Obx(() {
      final status = statusRx.value;
      final url = urlRx.value;
      final expiryDate = expireController.text.trim();
      final hasUrl = url != null && url.isNotEmpty;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF242424)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              Get.toNamed(
                Routes.personalDocumentDetailView,
                arguments: {"documentType": documentType},
              )?.then((_) => controller.fetchDocuments());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              child: Row(
                children: [
                  // Leading Neutral Icon Box
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Middle Content: Title, Expiry & Status info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _buildStatusBadge(status),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: const Color(0xFF757575),
                              size: 11.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              expiryDate.isNotEmpty
                                  ? "Expires: $expiryDate"
                                  : "Expiry not set",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF888888),
                                fontSize: 11.5.sp,
                              ),
                            ),
                            if (hasUrl) ...[
                              SizedBox(width: 6.w),
                              Text(
                                "•",
                                style: TextStyle(
                                  color: const Color(0xFF555555),
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "File Attached",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFAAAAAA),
                                  fontSize: 11.5.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF555555),
                    size: 13.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Clean Status Badge
  Widget _buildStatusBadge(String? status) {
    final normalized = (status ?? 'PENDING').toUpperCase();
    Color bg;
    Color border;
    Color textColor;
    String label;

    if (normalized == 'APPROVED') {
      bg = const Color(0xFF10B981).withValues(alpha: 0.12);
      border = const Color(0xFF10B981).withValues(alpha: 0.35);
      textColor = const Color(0xFF34D399);
      label = "Approved";
    } else if (normalized.contains('PENDING') || normalized.contains('SCAN')) {
      bg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
      border = const Color(0xFFF59E0B).withValues(alpha: 0.35);
      textColor = const Color(0xFFFBBF24);
      label = "Pending";
    } else if (normalized == 'REJECTED') {
      bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
      border = const Color(0xFFEF4444).withValues(alpha: 0.35);
      textColor = const Color(0xFFF87171);
      label = "Rejected";
    } else {
      bg = Colors.white10;
      border = Colors.white24;
      textColor = Colors.white70;
      label = normalized;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: border, width: 0.7),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Footer Notice Box (Subtle & Clean)
  Widget _buildFooterNotice() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.shield_outlined,
              color: const Color(0xFF8E8E93),
              size: 16.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Compliance & Verification: Updated documents are automatically submitted for security check. Your bookings remain protected.",
              style: GoogleFonts.inter(
                color: const Color(0xFF757575),
                fontSize: 11.sp,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
