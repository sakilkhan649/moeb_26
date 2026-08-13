import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/utils/validators.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomText.dart';
import 'package:moeb_26/core/widgets/CustomTextGary.dart';
import 'package:moeb_26/modules/auth/vehicle/controllers/vehicle_action_controller.dart';
import 'package:moeb_26/modules/auth/vehicle/views/vehicle_Information_view.dart';

class AddNewVehicleView extends StatelessWidget {
  // Use a unique tag for each navigation to ensure NO data leaks or copying from previous visits
  final String tag = DateTime.now().millisecondsSinceEpoch.toString();

  AddNewVehicleView({super.key}) {
    // Inject a completely fresh and unique controller instance
    Get.put(VehicleActionController(), tag: tag);
  }

  // Find the exact instance using the unique tag
  VehicleActionController get controller =>
      Get.find<VehicleActionController>(tag: tag);

  final _formKey = GlobalKey<FormState>();
  final RxBool showErrors = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Obx(
          () => CustomSubAppBar(
            title: controller.isEditMode.value
                ? "Edit Vehicle"
                : "Add New Vehicle",
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildVehicleForm(context),
                SizedBox(height: 30.h),
                Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: controller.isEditMode.value
                              ? "Update Vehicle"
                              : "Add Vehicle",
                          onPressed: () {
                            showErrors.value = true;
                            if (_formKey.currentState!.validate()) {
                              if (controller
                                  .selectedVehicleType
                                  .value
                                  .isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please select a vehicle type",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              controller.submitVehicle();
                            }
                          },
                        ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleForm(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF262626), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: "Vehicle Type",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.gray100,
              ),
              Text(
                " *",
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Vehicle Type Chips
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _buildVehicleTypeChip("Sedan"),
              _buildVehicleTypeChip("SUV"),
              _buildVehicleTypeChip("Sprinter"),
              _buildVehicleTypeChip("LimoStretch"),
            ],
          ),

          // Vehicle type validation error
          Obx(() {
            if (showErrors.value &&
                controller.selectedVehicleType.value.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(left: 4.w, top: 6.h),
                child: Text(
                  'Select a Vehicle Type',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          SizedBox(height: 20.h),
          // Make & Model Dropdown Selection
          Obx(() {
            final type = controller.selectedVehicleType.value;
            final cars = vehicleMakeModelMap[type] ?? [];
            final currentSelection =
                (controller.makeController.text.isEmpty &&
                    controller.modelController.text.isEmpty)
                ? null
                : "${controller.makeController.text} ${controller.modelController.text}"
                      .trim();
            final value = cars.contains(currentSelection)
                ? currentSelection
                : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "Make & Model",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  key: ValueKey(type),
                  value: value,
                  dropdownColor: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16.r),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFD5C4AB),
                    size: 22,
                  ),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Select Make & Model"
                      : null,
                  decoration: InputDecoration(
                    hintText: type.isEmpty
                        ? "Select Vehicle Type First"
                        : "Select Make & Model",
                    hintStyle: TextStyle(
                      color: AppColors.gray100,
                      fontSize: 14.sp,
                    ),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 16.w,
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
                      borderSide: const BorderSide(
                        color: Color(0xFFD08700),
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: cars.map((car) {
                    return DropdownMenuItem<String>(
                      value: car,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          car,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: type.isEmpty
                      ? null
                      : (val) {
                          if (val != null) {
                            final parts = val.split(' ');
                            controller.makeController.text = parts.first;
                            controller.modelController.text = parts
                                .sublist(1)
                                .join(' ');
                          }
                        },
                ),
              ],
            );
          }),
          SizedBox(height: 15.h),
          // Row 2: Color (Inside) & Color (Outside)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Color (Inside)",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.colorInsideController,
                      hintText: "Black",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Color (Inside)";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Color (Outside)",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final type = controller.selectedVehicleType.value;
                      final isLimo = type == "LimoStretch";
                      final colors = isLimo ? ["Black", "White"] : ["Black"];

                      // Auto-populate "Black" for non-limo
                      if (!isLimo &&
                          controller.colorOutsideController.text != "Black") {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.colorOutsideController.text = "Black";
                        });
                      }

                      final currentSelection =
                          controller.colorOutsideController.text;
                      final value = colors.contains(currentSelection)
                          ? currentSelection
                          : null;

                      return DropdownButtonFormField<String>(
                        key: ValueKey(type),
                        value: value,
                        dropdownColor: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16.r),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFD5C4AB),
                          size: 22,
                        ),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Select Color"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Select Color",
                          hintStyle: TextStyle(
                            color: AppColors.gray100,
                            fontSize: 14.sp,
                          ),
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 11.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 16.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: AppColors.black200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: AppColors.black200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFD08700),
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: colors.map((c) {
                          return DropdownMenuItem<String>(
                            value: c,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                c,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.colorOutsideController.text = val;
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Row 3: Year & License Plate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Year",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.yearController,
                      hintText: "2021",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final type = controller.selectedVehicleType.value;
                        final maxAge = (type == "LimoStretch") ? 15 : 5;
                        return Validators.year(
                          value,
                          min: DateTime.now().year - maxAge,
                          max: DateTime.now().year,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "License Plate",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.licensePlateController,
                      hintText: "ABC-1234",
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Enter License Plate";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          /// Commercial Insurance
          _buildUnifiedDocumentCard(
            context: context,
            title: "Commercial Insurance",
            isRequired: true,
            fileRx: controller.commercialInsuranceFile,
            urlRx: controller.commercialInsuranceUrl,
            expireController: controller.commercialInsuranceExpireController,
          ),
          SizedBox(height: 20.h),

          /// Vehicle Registration
          _buildUnifiedDocumentCard(
            context: context,
            title: "Vehicle Registration",
            isRequired: true,
            fileRx: controller.vehicleRegistrationFile,
            urlRx: controller.vehicleRegistrationUrl,
            expireController: controller.vehicleRegistrationExpireController,
          ),
          SizedBox(height: 24.h),

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
            context: context,
            title: "Front View",
            fileRx: controller.frontViewFile,
            urlRx: controller.frontViewUrl,
          ),
          SizedBox(height: 12.h),

          /// Rear View
          _buildPhotoSection(
            context: context,
            title: "Rear View",
            fileRx: controller.rearViewFile,
            urlRx: controller.rearViewUrl,
          ),
          SizedBox(height: 12.h),

          /// Interior View
          _buildPhotoSection(
            context: context,
            title: "Interior View",
            fileRx: controller.interiorViewFile,
            urlRx: controller.interiorViewUrl,
          ),
        ],
      ),
    );
  }

  // ========== UI Helpers ==========

  Widget _buildUnifiedDocumentCard({
    required BuildContext context,
    required String title,
    required bool isRequired,
    required Rx<File?> fileRx,
    required RxnString urlRx,
    required TextEditingController expireController,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      final hasUrl = urlRx.value != null && urlRx.value!.isNotEmpty;
      final canPreview = hasFile || hasUrl;
      final showError = showErrors.value && isRequired && !hasFile && !hasUrl;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasFile
                ? const Color(0xFFD08700).withValues(alpha: 0.6)
                : const Color(0xFF262626),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildDocumentIcon(),
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
                          if (isRequired)
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      hasFile
                          ? Row(
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
                          : hasUrl
                          ? Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: const Color(0xFFD08700),
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Current file on record",
                                  style: TextStyle(
                                    color: const Color(0xFFFFDCA1),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : CustomTextgray(
                              text: "PDF, JPG, PNG",
                              fontSize: 11.sp,
                            ),
                    ],
                  ),
                ),
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
                ),
              ],
            ),
            if (showError)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "Please upload $title",
                  style: TextStyle(color: Colors.redAccent, fontSize: 12.sp),
                ),
              ),
            SizedBox(height: 14.h),
            const Divider(color: Color(0xFF262626), height: 1),
            SizedBox(height: 14.h),
            Row(
              children: [
                CustomText(
                  text: "Expiration Date",
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: const Color(0xFF9EA3AE),
                ),
                if (isRequired)
                  Text(
                    " *",
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            _buildExpireDateField(
              context: context,
              textController: expireController,
              hintText: "Select Expiration Date",
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter expire date";
                return null;
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDocumentSection({
    required BuildContext context,
    required String title,
    required bool isRequired,
    required Rx<File?> fileRx,
    required RxnString urlRx,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      final hasUrl = urlRx.value != null && urlRx.value!.isNotEmpty;
      final canPreview = hasFile || hasUrl;
      final showError = showErrors.value && isRequired && !hasFile && !hasUrl;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomContainer(
            child: Row(
              children: [
                _buildDocumentIcon(),
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
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          if (isRequired)
                            Text(
                              " *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      hasFile
                          ? Text(
                              controller.getFileName(fileRx),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 11.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : hasUrl
                          ? Text(
                              "Current file on record",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                              ),
                            )
                          : CustomTextgray(
                              text: "PDF, JPG, PNG",
                              fontSize: 11.sp,
                            ),
                    ],
                  ),
                ),
                if (canPreview)
                  IconButton(
                    onPressed: () => controller.previewImage(
                      context,
                      fileRx,
                      urlRx,
                      title: title,
                    ),
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue,
                      size: 20.sp,
                    ),
                    tooltip: "Preview image",
                  ),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.pickFromFile(context, fileRx),
                  icon: Icon(
                    Icons.file_upload_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.only(left: 4.w, top: 6.h),
              child: Text(
                "Please upload $title",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPhotoSection({
    required BuildContext context,
    required String title,
    required Rx<File?> fileRx,
    required RxnString urlRx,
  }) {
    return Obx(() {
      final hasFile = fileRx.value != null;
      final hasUrl = urlRx.value != null && urlRx.value!.isNotEmpty;
      final canPreview = hasFile || hasUrl;
      final showError = showErrors.value && !hasFile && !hasUrl;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomContainer(
            child: Row(
              children: [
                _buildDocumentIconPhoto(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                      if (hasFile)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            controller.getFileName(fileRx),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (hasUrl)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            "Current photo on record",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (canPreview)
                  IconButton(
                    onPressed: () => controller.previewImage(
                      context,
                      fileRx,
                      urlRx,
                      title: title,
                    ),
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue,
                      size: 20.sp,
                    ),
                    tooltip: "Preview photo",
                  ),
                IconButton(
                  onPressed: () => controller.pickFromCamera(fileRx),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.only(left: 4.w, top: 6.h),
              child: Text(
                "Please upload $title",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildExpireDateField({
    required BuildContext context,
    required TextEditingController textController,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: textController,
      readOnly: true,
      onTap: () => controller.selectDate(context, textController),
      validator: validator,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
        errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
        errorMaxLines: 2,
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 18.sp,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
      ),
    );
  }

  Widget _buildDocumentIcon() {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2939),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.description_outlined, color: Colors.white, size: 16.sp),
    );
  }

  Widget _buildDocumentIconPhoto() {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Icon(Icons.image_outlined, color: Colors.white, size: 16.sp),
    );
  }

  Widget _buildVehicleTypeChip(String vehicleType) {
    return Obx(() {
      bool isSelected = controller.selectedVehicleType.value == vehicleType;
      return GestureDetector(
        onTap: () {
          if (controller.selectedVehicleType.value != vehicleType) {
            controller.makeController.clear();
            controller.modelController.clear();
            controller.yearController.clear();
            if (vehicleType != "LimoStretch") {
              controller.colorOutsideController.text = "Black";
            } else {
              controller.colorOutsideController.clear();
            }
            controller.selectedVehicleType.value = vehicleType;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 15.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF181F26) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFF364153)),
          ),
          child: CustomTextgray(
            text: vehicleType,
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      );
    });
  }

  // ignore: non_constant_identifier_names
  Widget _CustomContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.black200),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
          errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
          errorMaxLines: 2,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
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
            borderSide: BorderSide(color: AppColors.black200),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.black200),
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}
