import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import 'Controller/VehicleInformationController.dart';
import 'Model/VehicleModel.dart';


class Vehicleinformation extends StatelessWidget {
  Vehicleinformation({super.key});

  final VehicleInformationController controller = Get.put(
    VehicleInformationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.w),
            CustomText(text: "Vehicle Information", fontSize: 20.sp),
            SizedBox(height: 7.h),
            CustomTextgray(
              text: "Add your professional vehicles",
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 30.h),

            // Vehicle list with buttons inside
            Expanded(
              child: Obx(
                () => ListView(
                  children: [
                    // সব vehicle cards
                    ...List.generate(
                      controller.vehicles.length,
                      (index) =>
                          _buildVehicleCard(index, controller.vehicles[index]),
                    ),

                    SizedBox(height: 25.h),

                    // Add Another Vehicle Button
                    CustomAddButton(
                      onPressed: () {
                        controller.addVehicle(); // নতুন vehicle add করো
                      },
                    ),

                    SizedBox(height: 30.h),
                    CustomButton(
                      text: "Continue",
                      onPressed: () {
                        Get.toNamed(Routes.documentsupload);
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
    );
  }

  // একটা vehicle card
  Widget _buildVehicleCard(int index, VehicleModel model) {
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
              if (controller.vehicles.length > 1)
                GestureDetector(
                  onTap: () {
                    controller.removeVehicle(index); // Vehicle delete করো
                  },
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

          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column for Make and Year
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Make",
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
                      controller: model.makeController,
                      hintText: "Mercedes",
                    ),
                    SizedBox(height: 15.h),
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
                      controller: model.yearController,
                      hintText: "5 years maxim",
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              // Column for Model and Color
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Model",
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
                      controller: model.modelController,
                      hintText: "S-Class",
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        CustomText(
                          text: "Color",
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
                      controller: model.colorController,
                      hintText: "Black(Fix)",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              CustomText(
                text: "License Plate",
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
          _buildTextField(
            controller: model.licensePlateController,
            hintText: "ABC-1234",
          ),
        ],
      ),
    );
  }

  // Method to build the chip (with selected/unselected color)
  Widget _buildVehicleTypeChip(VehicleModel model, String vehicleType) {
    return Obx(() {
      bool isSelected = model.selectedVehicleType.value == vehicleType;
      return GestureDetector(
        onTap: () {
          model.selectedVehicleType.value = vehicleType;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 15.w),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF181F26) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Color(0xFF364153)),
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

  // Text field method
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray100, fontSize: 14.sp),
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
        ),
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}

/// Custom "Add Another Vehicle" Button
class CustomAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 25.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Color(0xFFFAC0C0), size: 20.r),
            SizedBox(width: 10.w),
            Text(
              'Add Another Vehicle',
              style: TextStyle(
                color: Color(0xFFFAC0C0),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
