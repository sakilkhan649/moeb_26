import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import 'controller/documentsupload_controller.dart';

class Documentsupload extends StatelessWidget {
  Documentsupload({super.key});

  final controller = Get.put(DocumentsUploadController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.w),
                // Page title
                CustomText(text: "Documents Upload", fontSize: 20.sp),
                SizedBox(height: 7.h),
                //subtitle text
                CustomTextgray(
                  text: "Upload required documents for verificationHola",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),

                SizedBox(height: 30.h),

                /// First document License Plate
                _buildDocumentSection(
                  title: "License Plate",
                  isRequired: true,
                  fileRx: controller.licensePlateFile,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      text: "Expire Date",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildExpireDateField(
                  textController: controller.licensePlateExpireController,
                  hintText: "1 June 2030",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter expire date";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                /// Second document Hack License
                _buildDocumentSection(
                  title: "Hack License",
                  isRequired: true,
                  fileRx: controller.hackLicenseFile,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      text: "Expire Date",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildExpireDateField(
                  textController: controller.hackLicenseExpireController,
                  hintText: "1 June 2030",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter expire date";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                /// First document Local Permit
                _buildDocumentSection(
                  title: "Local Permit ",
                  isRequired: false,
                  fileRx: controller.localPermitFile,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      text: "Expire Date",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildExpireDateField(
                  textController: controller.localPermitExpireController,
                  hintText: "1 June 2030",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter expire date";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                /// Second document Commercial Insurance
                _buildDocumentSection(
                  title: "Commercial Insurance",
                  isRequired: true,
                  fileRx: controller.commercialInsuranceFile,
                  titleFontSize: 13.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      text: "Expire Date",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildExpireDateField(
                  textController:
                      controller.commercialInsuranceExpireController,
                  hintText: "1 June 2030",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter expire date";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                /// First document Vehicle Registration
                _buildDocumentSection(
                  title: "Vehicle Registration",
                  isRequired: true,
                  fileRx: controller.vehicleRegistrationFile,
                  titleFontSize: 13.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      text: "Expire Date",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildExpireDateField(
                  textController:
                      controller.vehicleRegistrationExpireController,
                  hintText: "1 June 2030",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter expire date";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                /// Second document Upload Headshot
                _buildHeadshotSection(),
                SizedBox(height: 20.h),

                /// Vehicle Photos
                Row(
                  children: [
                    CustomText(
                      text: "Vehicle Photos",
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                /// Front View
                _buildPhotoSection(
                  title: "Front View",
                  fileRx: controller.frontViewFile,
                ),
                SizedBox(height: 12.h),

                /// Rear View
                _buildPhotoSection(
                  title: "Rear View",
                  fileRx: controller.rearViewFile,
                ),
                SizedBox(height: 12.h),

                /// Interior View
                _buildPhotoSection(
                  title: "Interior View",
                  fileRx: controller.interiorViewFile,
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2939),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: CustomTextgray(
                    text:
                        "All documents will be reviewed by our admin team. This process typically takes 24-48 hours. You'll be notified via email once approved.",
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: "Submit Application",
                  onPressed: () {
                    controller.showErrors.value = true;

                    // Validate expire date fields
                    final isFormValid = _formKey.currentState!.validate();

                    // Validate required documents
                    final docsValid = controller.validateDocuments();

                    if (isFormValid && docsValid) {
                      Get.toNamed(Routes.termPolicy);
                    }
                  },
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a document upload section (License Plate, Hack License, etc.)
  Widget _buildDocumentSection({
    required String title,
    required bool isRequired,
    required Rx<File?> fileRx,
    double? titleFontSize,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      final showError = controller.showErrors.value && isRequired && !hasFile;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDocumentIcon(),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: CustomText(
                              text: title,
                              fontWeight: FontWeight.w500,
                              fontSize: titleFontSize ?? 15.sp,
                            ),
                          ),
                          if (isRequired)
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      hasFile
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    controller.getFileName(fileRx),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 11.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : CustomTextgray(text: "PDF, JPG, PNG"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => controller.pickFromFile(fileRx),
                  icon: Icon(Icons.file_upload_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 6.h),
              child: Text(
                "Please upload $title",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  /// Builds the Headshot upload section (special subtitle)
  Widget _buildHeadshotSection() {
    return Obx(() {
      final hasFile = controller.headshotFile.value != null;
      final showError = controller.showErrors.value && !hasFile;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDocumentIcon(),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: "Upload Headshot",
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                          Text(
                            "  *",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      hasFile
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    controller.getFileName(
                                      controller.headshotFile,
                                    ),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 11.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : CustomTextgray(
                              text: "BLACK SUIT TIE WITH WHITE BACKGROUND",
                              fontSize: 7.sp,
                            ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      controller.pickFromCamera(controller.headshotFile),
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () =>
                      controller.pickFromFile(controller.headshotFile),
                  icon: Icon(Icons.file_upload_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 6.h),
              child: Text(
                "Please upload Headshot",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  /// Builds a vehicle photo section (Front View, Rear View, Interior View)
  Widget _buildPhotoSection({
    required String title,
    required Rx<File?> fileRx,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      final showError = controller.showErrors.value && !hasFile;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDocumentIconPhoto(),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hasFile
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    controller.getFileName(fileRx),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : CustomText(
                              text: title,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                    ],
                  ),
                ),
                SizedBox(width: 30.w),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => controller.pickFromFile(fileRx),
                  icon: Icon(Icons.file_upload_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 6.h),
              child: Text(
                "Please upload $title",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  /// Builds the custom container with the provided child
  Widget _CustomContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.black200, width: 1),
      ),
      child: child,
    );
  }

  /// Builds the expire date text field with validator
  Widget _buildExpireDateField({
    required TextEditingController textController,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Builder(
      builder: (context) {
        return TextFormField(
          controller: textController,
          validator: validator,
          readOnly: true,
          onTap: () => controller.selectDate(context, textController),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.gray100),
            suffixIcon: Icon(
              Icons.calendar_month,
              color: AppColors.gray100,
              size: 20.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 10.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.black200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.black200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.black200),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  /// Builds the document icon with background container
  Widget _buildDocumentIcon() {
    return Container(
      // Icon container with padding
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF364153), width: 1),
        // Dark background for icon
        color: const Color(0xFF1E2939),
        // Rounded corners
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.description_outlined, // Document icon
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }

  /// Builds the document icon with background container
  Widget _buildDocumentIconPhoto() {
    return Container(
      // Icon container with padding
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF364153), width: 1),
        // Dark background for icon
        color: const Color(0xFF1E2939),
        // Rounded corners
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.broken_image_outlined, // Document icon
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }
}
