import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import '../../../../core/widgets/CustomButton.dart';
import '../../../../core/widgets/CustomText.dart';
import '../../../../core/widgets/CustomTextGary.dart';
import '../controllers/personal_document_controller.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';

class PersonalDocumentView extends GetView<PersonalDocumentController> {
  const PersonalDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomSubAppBar(title: "My Personal Documents"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              CustomTextgray(
                text:
                    "View, update or replace your professional documents and expiration dates.",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 24.h),

              // 1. Driving License Card
              _buildUnifiedDocumentCard(
                context: context,
                title: "Driving License",
                fileRx: controller.drivingLicenseFile,
                urlRx: controller.drivingLicenseUrl,
                expireController: controller.drivingLicenseExpireController,
              ),

              // 2. Hack License Card
              _buildUnifiedDocumentCard(
                context: context,
                title: "Hack License",
                fileRx: controller.hackLicenseFile,
                urlRx: controller.hackLicenseUrl,
                expireController: controller.hackLicenseExpireController,
              ),

              // 3. Local Permit Card
              _buildUnifiedDocumentCard(
                context: context,
                title: "Local Permit",
                fileRx: controller.localPermitFile,
                urlRx: controller.localPermitUrl,
                expireController: controller.localPermitExpireController,
              ),

              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF262626)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: const Color(0xFF9EA3AE),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomTextgray(
                        text:
                            "Updates to your documents may take up to 24-48 hours to be reviewed and approved by our admin team.",
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : CustomButton(
                        text: "Update Documents",
                        onPressed: () {
                          controller.submitDocuments();
                        },
                      ),
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- Unified Card Container ---
  Widget _buildUnifiedDocumentCard({
    required BuildContext context,
    required String title,
    required Rx<File?> fileRx,
    required RxnString urlRx,
    required TextEditingController expireController,
    bool onlyCamera = false,
  }) {
    return Obx(() {
      final hasLocalFile = fileRx.value != null;
      final hasServerUrl = urlRx.value != null && urlRx.value!.isNotEmpty;
      final canPreview = hasLocalFile || hasServerUrl;

      return Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasLocalFile
                ? const Color(0xFFD08700).withValues(alpha: 0.6)
                : const Color(0xFF262626),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Icon + Title & File Status + Action Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIcon(Icons.badge_outlined),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: CustomText(
                              text: title,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(" *", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      if (hasLocalFile)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.greenAccent,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                controller.getFileName(fileRx),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (hasServerUrl)
                        Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: const Color(0xFF9EA3AE),
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Current file on record",
                              style: TextStyle(
                                color: const Color(0xFF9EA3AE),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else
                        CustomTextgray(
                          text: "No file attached",
                          fontSize: 11.sp,
                        ),
                    ],
                  ),
                ),

                // Action Buttons Group (Preview, Camera, Upload)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canPreview) ...[
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                        onPressed: () => controller.previewImage(
                          context,
                          fileRx,
                          urlRx,
                          title: title,
                        ),
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: const Color(0xFFD08700),
                          size: 18.sp,
                        ),
                        tooltip: "Preview",
                      ),
                      SizedBox(width: 2.w),
                    ],
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      onPressed: () => controller.pickFromCamera(fileRx),
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      tooltip: "Camera",
                    ),
                    if (!onlyCamera) ...[
                      SizedBox(width: 2.w),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                        onPressed: () =>
                            controller.pickFromFile(context, fileRx),
                        icon: Icon(
                          Icons.file_upload_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        tooltip: "Upload File",
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Embedded Expiration Date Section
            SizedBox(height: 14.h),
            const Divider(color: Color(0xFF262626), height: 1),
            SizedBox(height: 14.h),
            _buildFieldLabel("Expiration Date"),
            _buildExpireDateField(context, expireController),
          ],
        ),
      );
    });
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Icon(icon, color: Colors.white, size: 16.sp),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        color: const Color(0xFF9EA3AE),
      ),
    );
  }

  Widget _buildExpireDateField(
    BuildContext context,
    TextEditingController textController,
  ) {
    return TextFormField(
      controller: textController,
      readOnly: true,
      onTap: () => controller.selectDate(context, textController),
      style: TextStyle(color: Colors.white, fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: "Select Date",
        hintStyle: TextStyle(color: AppColors.gray100, fontSize: 13.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: const Color(0xFF9EA3AE),
          size: 18.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF9EA3AE)),
        ),
      ),
    );
  }
}
