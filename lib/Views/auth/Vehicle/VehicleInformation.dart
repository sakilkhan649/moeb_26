import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/Views/auth/Vehicle/Model/VehicleModel.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';

class Vehicleinformation extends StatelessWidget {
  Vehicleinformation({super.key});

  // Using the unified SignupController
  final SignupController controller = Get.find<SignupController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.w),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 50.w),
              CustomText(text: "Vehicle Information", fontSize: 20.sp),
              SizedBox(height: 7.h),
              CustomTextgray(
                text: "Add your professional vehicles",
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 30.h),

              // Vehicle list
              Expanded(
                child: Obx(
                  () => ListView(
                    children: [
                      ...List.generate(
                        controller.vehiclesList.length,
                        (index) => _buildVehicleCard(
                          context,
                          index,
                          controller.vehiclesList[index],
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // Add Another Vehicle Button
                      CustomAddButton(onPressed: () => controller.addVehicle()),

                      SizedBox(height: 30.h),

                      CustomButton(
                        text: "Continue",
                        onPressed: () {
                          controller.showErrors.value = true;
                          final isFormValid = _formKey.currentState!.validate();

                          bool allValid = true;
                          for (var v in controller.vehiclesList) {
                            if (v.selectedVehicleType.value.isEmpty ||
                                v.commercialInsuranceFile.value == null ||
                                v.vehicleRegistrationFile.value == null ||
                                v.frontViewFile.value == null ||
                                v.rearViewFile.value == null ||
                                v.interiorViewFile.value == null) {
                              allValid = false;
                              break;
                            }
                          }

                          if (isFormValid && allValid) {
                            // Just navigate to the next page
                            Get.toNamed(Routes.documentsupload);
                          }
                        },
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Vehicle Card ---
  Widget _buildVehicleCard(
    BuildContext context,
    int index,
    VehicleModel model,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.black200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Vehicle ${index + 1}", fontSize: 15.sp),
              if (controller.vehiclesList.length > 1)
                GestureDetector(
                  onTap: () => controller.removeVehicle(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black200,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.black200, width: 1),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVehicleTypeChip(model, "Sedan"),
              _buildVehicleTypeChip(model, "SUV"),
              _buildVehicleTypeChip(model, "Sprinter"),
              _buildVehicleTypeChip(model, "Bus"),
            ],
          ),
          SizedBox(height: 10.h),
          _buildVehicleTypeChip(model, "LimoStretch"),

          // Validation Error
          Obx(() {
            if (controller.showErrors.value &&
                model.selectedVehicleType.value.isEmpty) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("Make"),
                    _buildTextField(
                      controller: model.makeController,
                      hintText: "Mercedes",
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter Make"
                          : null,
                    ),
                    SizedBox(height: 15.h),
                    _buildFieldLabel("Year"),
                    _buildTextField(
                      controller: model.yearController,
                      hintText: "2023",
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter Year"
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("Model"),
                    _buildTextField(
                      controller: model.modelController,
                      hintText: "S-Class",
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter Model"
                          : null,
                    ),
                    SizedBox(height: 15.h),
                    _buildFieldLabel("Color"),
                    _buildTextField(
                      controller: model.colorController,
                      hintText: "Black",
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter Color"
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          _buildFieldLabel("License Plate"),
          _buildTextField(
            controller: model.licensePlateController,
            hintText: "ABC-1234",
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter License Plate" : null,
          ),
          SizedBox(height: 24.h),

          _buildFileSection(
            title: "Commercial Insurance",
            fileRx: model.commercialInsuranceFile,
            isRequired: true,
          ),
          SizedBox(height: 16.h),
          _buildFieldLabel("Expire Date"),
          _buildExpireDateField(
            context,
            model.commercialInsuranceExpireController,
          ),

          SizedBox(height: 24.h),

          _buildFileSection(
            title: "Vehicle Registration",
            fileRx: model.vehicleRegistrationFile,
            isRequired: true,
          ),
          SizedBox(height: 16.h),
          _buildFieldLabel("Expire Date"),
          _buildExpireDateField(
            context,
            model.vehicleRegistrationExpireController,
          ),

          SizedBox(height: 24.h),
          CustomText(
            text: "Vehicle Photos",
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
          SizedBox(height: 10.h),
          _buildPhotoSection(
            title: "Front View",
            fileRx: model.frontViewFile,
            isRequired: true,
          ),
          SizedBox(height: 12.h),
          _buildPhotoSection(
            title: "Rear View",
            fileRx: model.rearViewFile,
            isRequired: true,
          ),
          SizedBox(height: 12.h),
          _buildPhotoSection(
            title: "Interior View",
            fileRx: model.interiorViewFile,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          CustomText(text: text, fontWeight: FontWeight.w500, fontSize: 13.sp),
          Text(
            " *",
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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

  Widget _buildExpireDateField(
    BuildContext context,
    TextEditingController textController,
  ) {
    return TextFormField(
      controller: textController,
      readOnly: true,
      onTap: () => controller.selectDate(context, textController),
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Date required" : null,
      decoration: InputDecoration(
        hintText: "Select Date",
        hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 18.sp,
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

  Widget _buildFileSection({
    required String title,
    required Rx<File?> fileRx,
    bool isRequired = false,
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
                      CustomText(
                        text: title,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
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
          if (controller.showErrors.value && isRequired && !hasFile)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
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
    required String title,
    required Rx<File?> fileRx,
    bool isRequired = false,
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
                _buildIcon(Icons.image_outlined),
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
                          if (isRequired)
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
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
          if (controller.showErrors.value && isRequired && !hasFile)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                "Please upload $title",
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
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
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: Colors.white, size: 20.sp),
    );
  }

  Widget _buildVehicleTypeChip(VehicleModel model, String type) {
    return Obx(() {
      bool isSelected = model.selectedVehicleType.value == type;
      return GestureDetector(
        onTap: () => model.selectedVehicleType.value = type,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF181F26) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFF364153)),
          ),
          child: CustomTextgray(
            text: type,
            color: Colors.white,
            fontSize: 13.sp,
          ),
        ),
      );
    });
  }
}

class CustomAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Color(0xFFFAC0C0), size: 20),
            SizedBox(width: 8.w),
            const Text(
              'Add Another Vehicle',
              style: TextStyle(
                color: Color(0xFFFAC0C0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
