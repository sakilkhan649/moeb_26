import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/ImagePreviewPopup.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/personal_document_controller.dart';

class PersonalDocumentDetailView extends StatefulWidget {
  final String? documentType;

  const PersonalDocumentDetailView({super.key, this.documentType});

  @override
  State<PersonalDocumentDetailView> createState() =>
      _PersonalDocumentDetailViewState();
}

class _PersonalDocumentDetailViewState
    extends State<PersonalDocumentDetailView> {
  late final PersonalDocumentController controller;
  late final String docType;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<PersonalDocumentController>()
        ? Get.find<PersonalDocumentController>()
        : Get.put(PersonalDocumentController());

    final args = Get.arguments;
    if (widget.documentType != null && widget.documentType!.isNotEmpty) {
      docType = widget.documentType!;
    } else if (args is Map && args['documentType'] != null) {
      docType = args['documentType'].toString();
    } else if (args is String && args.isNotEmpty) {
      docType = args;
    } else {
      docType = 'DRIVING_LICENSE';
    }
  }

  bool get isDL => docType == 'DRIVING_LICENSE';
  bool get isHL => docType == 'HACK_LICENSE';
  bool get isLP => docType == 'LOCAL_PERMIT';

  String get docTitle => isDL
      ? "Driving License"
      : isHL
      ? "Hack License"
      : "Local Permit";

  IconData get docIcon => isDL
      ? Icons.badge_outlined
      : isHL
      ? Icons.verified_user_outlined
      : Icons.location_city_outlined;

  RxnString get docIdRx => isDL
      ? controller.drivingLicenseId
      : isHL
      ? controller.hackLicenseId
      : controller.localPermitId;

  RxnString get statusRx => isDL
      ? controller.drivingLicenseStatus
      : isHL
      ? controller.hackLicenseStatus
      : controller.localPermitStatus;

  RxnString get urlRx => isDL
      ? controller.drivingLicenseUrl
      : isHL
      ? controller.hackLicenseUrl
      : controller.localPermitUrl;

  Rx<File?> get fileRx => isDL
      ? controller.drivingLicenseFile
      : isHL
      ? controller.hackLicenseFile
      : controller.localPermitFile;

  TextEditingController get expireController => isDL
      ? controller.drivingLicenseExpireController
      : isHL
      ? controller.hackLicenseExpireController
      : controller.localPermitExpireController;

  RxBool get isUpdatingRx => isDL
      ? controller.isUpdatingDrivingLicense
      : isHL
      ? controller.isUpdatingHackLicense
      : controller.isUpdatingLocalPermit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomSubAppBar(title: "$docTitle Details"),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: const Color(0xFF1A1A1A),
        onRefresh: () => controller.fetchDocuments(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Obx(() {
            final currentStatus = statusRx.value;
            final currentDocId = docIdRx.value;
            final currentUrl = urlRx.value;
            final currentFile = fileRx.value;
            final isUpdating = isUpdatingRx.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Status Notice Banner (Clean)
                _buildStatusNotice(currentStatus),
                SizedBox(height: 14.h),

                // 2. Hero Header Card (Neutral Icon)
                _buildHeroHeader(
                  docTitle: docTitle,
                  docType: docType,
                  docId: currentDocId,
                  status: currentStatus,
                ),
                SizedBox(height: 14.h),

                // 3. Document File / Preview Card
                _buildDocumentPreviewCard(
                  context: context,
                  file: currentFile,
                  url: currentUrl,
                ),
                SizedBox(height: 14.h),

                // 4. Expiration Date Card
                _buildExpiryDateCard(context),
                SizedBox(height: 24.h),

                // 5. Update Action Button
                CustomButton(
                  text: isUpdating ? "Updating..." : "Save & Update Document",
                  loading: isUpdating,
                  onPressed: () async {
                    await controller.updateSingleDocument(docType);
                  },
                ),
                SizedBox(height: 14.h),

                // Helper Note
                Center(
                  child: Text(
                    "All document updates are verified for transport compliance.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF707070),
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Status Notice Banner
  Widget _buildStatusNotice(String? status) {
    final normalized = (status ?? '').toUpperCase();
    final isApproved = normalized == 'APPROVED';
    final isPending =
        normalized.contains('PENDING') ||
        normalized.contains('SCAN') ||
        normalized == 'UNDER_REVIEW';
    final isRejected =
        normalized.contains('REJECT') || normalized.contains('DECLIN');

    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData icon;
    String title;
    String subtitle;

    if (isApproved) {
      bgColor = const Color(0xFF0F2417);
      borderColor = const Color(0xFF1B4D2E);
      textColor = const Color(0xFF34D399);
      icon = Icons.check_circle_outline_rounded;
      title = "Document Verified & Active";
      subtitle = "Your $docTitle is currently approved and active.";
    } else if (isPending) {
      bgColor = const Color(0xFF261D0A);
      borderColor = const Color(0xFF4D3A14);
      textColor = const Color(0xFFFBBF24);
      icon = Icons.hourglass_top_rounded;
      title = "Verification Under Review";
      subtitle =
          "Your $docTitle has been submitted and is currently being verified.";
    } else if (isRejected) {
      bgColor = const Color(0xFF261010);
      borderColor = const Color(0xFF4D2020);
      textColor = const Color(0xFFF87171);
      icon = Icons.error_outline_rounded;
      title = "Update Required / Rejected";
      subtitle =
          "Your document could not be verified. Please upload a clear replacement.";
    } else {
      bgColor = const Color(0xFF141414);
      borderColor = const Color(0xFF242424);
      textColor = const Color(0xFF9E9E9E);
      icon = Icons.info_outline_rounded;
      title = "Compliance Document";
      subtitle =
          "Ensure your $docTitle details and expiration date remain up-to-date.";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(icon, color: textColor, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: textColor.withValues(alpha: 0.85),
                    fontSize: 11.5.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hero Header Card
  Widget _buildHeroHeader({
    required String docTitle,
    required String docType,
    required String? docId,
    required String? status,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Row(
        children: [
          // Neutral Icon Box
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Icon(docIcon, color: Colors.white, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docTitle,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // if (docId != null && docId.isNotEmpty) ...[
                //   SizedBox(height: 2.h),
                //   Text(
                //     "Doc ID: $docId",
                //     style: GoogleFonts.inter(
                //       color: const Color(0xFF757575),
                //       fontSize: 11.sp,
                //     ),
                //   ),
                // ],
              ],
            ),
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  /// Document Preview & File Selection Card
  Widget _buildDocumentPreviewCard({
    required BuildContext context,
    required File? file,
    required String? url,
  }) {
    final hasFile = file != null;
    final hasUrl = url != null && url.isNotEmpty;
    final isPdf =
        (hasFile && file.path.toLowerCase().endsWith('.pdf')) ||
        (hasUrl && url.toLowerCase().contains('.pdf'));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Document Attachment",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasFile || hasUrl)
                GestureDetector(
                  onTap: () {
                    controller.previewImage(
                      context,
                      fileRx,
                      urlRx,
                      title: "$docTitle Preview",
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        color: const Color(0xFFCCCCCC),
                        size: 15.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Preview",
                        style: GoogleFonts.inter(
                          color: const Color(0xFFCCCCCC),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),

          // Preview Area
          if (hasFile || hasUrl) ...[
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF262626)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isPdf)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            color: Colors.redAccent,
                            size: 38.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            hasFile
                                ? controller.getFileName(fileRx)
                                : "PDF Document Attached",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Tap 'Preview' to view full PDF",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF757575),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      )
                    else if (hasFile)
                      Image.file(
                        file,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      Image.network(
                        url!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: const Color(0xFF666666),
                            size: 32.sp,
                          ),
                        ),
                      ),

                    // Tap to zoom overlay
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.previewImage(
                              context,
                              fileRx,
                              urlRx,
                              title: "$docTitle Preview",
                            );
                          },
                        ),
                      ),
                    ),

                    if (hasFile)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () => fileRx.value = null,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF222222)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: const Color(0xFF555555),
                    size: 32.sp,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "No document attached yet",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF757575),
                      fontSize: 11.5.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],

          // Pick / Replace Document Action
          OutlinedButton(
            onPressed: () => _showPickerBottomSheet(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 42.h),
              backgroundColor: const Color(0xFF1E1E1E),
              side: const BorderSide(color: Color(0xFF2E2E2E)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  hasFile || hasUrl
                      ? "Replace Document File"
                      : "Upload Document File",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expiry Date Selection Card
  Widget _buildExpiryDateCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Expiration Date",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Set the official expiration date as printed on your credential.",
            style: GoogleFonts.inter(
              color: const Color(0xFF757575),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 10.h),

          GestureDetector(
            onTap: () => controller.selectDate(context, expireController),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFF262626)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expireController.text.isNotEmpty
                        ? expireController.text
                        : "Select Expiry Date (YYYY-MM-DD)",
                    style: GoogleFonts.inter(
                      color: expireController.text.isNotEmpty
                          ? Colors.white
                          : const Color(0xFF555555),
                      fontSize: 12.5.sp,
                      fontWeight: expireController.text.isNotEmpty
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: const Color(0xFF9E9E9E),
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Status Badge Helper
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

  /// Bottom sheet to choose image/camera/pdf
  void _showPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                "Upload $docTitle",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                title: Text(
                  "Take Photo (Camera)",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickFromCamera(fileRx);
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                title: Text(
                  "Choose from Gallery",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickFromGallery(context, fileRx);
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                title: Text(
                  "Select PDF / Document File",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickFromFile(context, fileRx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
