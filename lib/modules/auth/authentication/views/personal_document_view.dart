import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import '../../../../core/widgets/CustomButton.dart';
import '../../../../core/widgets/CustomText.dart';
import '../../../../core/widgets/CustomTextGary.dart';
import '../controllers/personal_document_controller.dart';

class PersonalDocumentView extends GetView<PersonalDocumentController> {
  const PersonalDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.w),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(height: 20.w),
              CustomText(text: "Personal Documents", fontSize: 20.sp),
              SizedBox(height: 7.h),
              CustomTextgray(
                text: "Update or replace your professional documents.",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 30.h),

              _buildDocumentSection(
                context: context,
                title: "Driving License",
                fileRx: controller.drivingLicenseFile,
                urlRx: controller.drivingLicenseUrl,
                expireController: controller.drivingLicenseExpireController,
              ),

              SizedBox(height: 24.h),
              _buildDocumentSection(
                context: context,
                title: "Hack License",
                fileRx: controller.hackLicenseFile,
                urlRx: controller.hackLicenseUrl,
                expireController: controller.hackLicenseExpireController,
              ),

              SizedBox(height: 24.h),
              _buildDocumentSection(
                context: context,
                title: "Local Permit",
                fileRx: controller.localPermitFile,
                urlRx: controller.localPermitUrl,
                expireController: controller.localPermitExpireController,
              ),

              SizedBox(height: 30.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2939),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const CustomTextgray(
                  text:
                      "Updates to your documents may take up to 24-48 hours to be reviewed and approved by our admin team.",
                ),
              ),
              SizedBox(height: 40.h),

              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
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

  // --- UI Helpers ---

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.w500,
        fontSize: 13.sp,
      ),
    );
  }

  Widget _buildDocumentSection({
    required BuildContext context,
    required String title,
    required Rx<File?> fileRx,
    required RxnString urlRx,
    required TextEditingController expireController,
  }) {
    return Obx(() {
      final hasLocalFile = fileRx.value != null;
      final hasServerUrl = urlRx.value != null && urlRx.value!.isNotEmpty;
      final canPreview = hasLocalFile || hasServerUrl;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document picker row
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.black200),
            ),
            child: Row(
              children: [
                _buildIcon(Icons.description_outlined),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                      if (hasLocalFile)
                        Text(
                          controller.getFileName(fileRx),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11.sp,
                          ),
                        )
                      else if (hasServerUrl)
                        Text(
                          "Current image on file",
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        ),
                    ],
                  ),
                ),
                // 👁 Eye preview icon — shows if local file or server URL exists
                if (canPreview)
                  IconButton(
                    onPressed: () => controller.previewImage(
                      context,
                      fileRx,
                      urlRx,
                      title: title,
                    ),
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue,
                    ),
                    tooltip: "Preview current image",
                  ),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.pickFromFile(context, fileRx),
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Expiry date field
          SizedBox(height: 12.h),
          _buildFieldLabel("Expiration Date"),
          _buildExpireDateField(context, expireController),
        ],
      );
    });
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2939),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: Colors.white, size: 22.sp),
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
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: "Select Date",
        hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
        suffixIcon: Icon(
          Icons.calendar_month,
          color: AppColors.gray100,
          size: 20.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.black200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.black200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.black200),
        ),
      ),
    );
  }
}
