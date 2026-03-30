import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import 'Controller/PersonalDocumentController.dart';

class PersonalDocument extends StatelessWidget {
  PersonalDocument({super.key});

  final controller = Get.put(PersonalDocumentController());

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
                title: "Driving License",
                fileRx: controller.drivingLicenseFile,
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("Expire Date"),
              _buildExpireDateField(
                context,
                controller.drivingLicenseExpireController,
              ),

              SizedBox(height: 24.h),
              _buildDocumentSection(
                title: "Hack License",
                fileRx: controller.hackLicenseFile,
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("Expire Date"),
              _buildExpireDateField(
                context,
                controller.hackLicenseExpireController,
              ),

              SizedBox(height: 24.h),
              _buildDocumentSection(
                title: "Local Permit",
                fileRx: controller.localPermitFile,
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("Expire Date"),
              _buildExpireDateField(
                context,
                controller.localPermitExpireController,
              ),

              SizedBox(height: 24.h),
              _buildHeadshotSection(),

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
    required String title,
    required Rx<File?> fileRx,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      Row(
                        children: [
                          CustomText(
                            text: title,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ],
                      ),
                      if (hasFile)
                        Text(
                          controller.getFileName(fileRx),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.pickFromFile(fileRx),
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeadshotSection() {
    return Obx(() {
      final hasFile = controller.headshotFile.value != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.black200),
            ),
            child: Row(
              children: [
                _buildIcon(Icons.image_outlined),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: "Upload Headshot",
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ],
                      ),
                      if (hasFile)
                        Text(
                          controller.getFileName(controller.headshotFile),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11.sp,
                          ),
                        )
                      else
                        CustomTextgray(
                          text: "BLACK SUIT TIE WITH WHITE BACKGROUND",
                          fontSize: 8.sp,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      controller.pickFromCamera(controller.headshotFile),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      controller.pickFromFile(controller.headshotFile),
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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
        hintText: "Select New Expiry Date",
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
