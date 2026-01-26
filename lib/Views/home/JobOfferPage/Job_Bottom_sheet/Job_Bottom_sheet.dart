import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextField.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';

import 'Controller/Job_bottom_sheet_Controller.dart';

class PostJobBottomSheet extends StatelessWidget {
  PostJobBottomSheet({super.key});

  // Controller initialize
  final PostJobController controller = Get.put(PostJobController());

  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();
  TextEditingController flightController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController payController = TextEditingController();
  TextEditingController specialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bottom sheet এর height responsive করার জন্য
      height: 0.9.sh, // Screen height এর 90%
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Header - Title এবং Close button
          _buildHeader(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Type Selection - One Way / By the hour
                  _buildJobTypeSelection(),
                  SizedBox(height: 20.h),

                  // Pickup Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      CustomText(
                        text: "Pickup Location",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Customtextfield(
                    controller: pickupController,
                    hintText: "e.g., JFK Airport, Terminal 4",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),
                  // Drop-off Location
                  // Pickup Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      CustomText(
                        text: "Drop-off Location",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Customtextfield(
                    controller: pickupController,
                    hintText: "e.g., Manhattan, Times Square",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),

                  // Flight Number (Optional)
                  // Pickup Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      CustomText(
                        text: "Flight Number (Optional)",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Customtextfield(
                    controller: pickupController,
                    hintText: "",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),

                  // Date and Time Row
                  Row(
                    children: [
                      // Date Field
                      Expanded(
                        // Pickup Location
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                CustomText(
                                  text: "Date",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                                const Text(
                                  " *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Customtextfield(
                              controller: pickupController,
                              hintText: "",
                              obscureText: false,
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Date Field
                      Expanded(
                        // Pickup Location
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                CustomText(
                                  text: "Time",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                                const Text(
                                  " *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Customtextfield(
                              controller: pickupController,
                              hintText: "",
                              obscureText: false,
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      // Time Field
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Vehicle Type Selection
                  _buildVehicleSelection(),
                  SizedBox(height: 16.h),

                  // Pay Amount
                  // Pickup Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      CustomText(
                        text: "Pay Amount",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Customtextfield(
                    controller: pickupController,
                    hintText: "\$120",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),

                  // Payment Method Dropdown
                  _buildPaymentMethodDropdown(),
                  SizedBox(height: 16.h),

                  // Special Instructions
                  // Pickup Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      CustomText(
                        text: "Special Instructions (Optional)",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Customtextfield(
                    controller: pickupController,
                    hintText:
                        "e.g., VIP client, suit required, name sign needed",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 24.h),

                  // Submit Button
                  CustomJobButton(text: "New Job", onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Widget - Title এবং Close button
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Post New Job',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  // Job Type Selection - One Way / By the hour
  Widget _buildJobTypeSelection() {
    return Obx(
      () => Row(
        children: [
          // One Way Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeJobType('One Way'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.jobType.value == 'One Way'
                      ? Colors.white
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    'One Way',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: controller.jobType.value == 'One Way'
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // By the hour Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeJobType('By the hour'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.jobType.value == 'By the hour'
                      ? Colors.white
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    'By the hour',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: controller.jobType.value == 'By the hour'
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Vehicle Type Selection Widget
  Widget _buildVehicleSelection() {
    final vehicles = [
      'Sedan',
      'SUV',
      'Sprinter',
      'Bus',
      'LimoStretch',
      'SEDAN/SUV',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Vehicle Type Required *',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        // Vehicle chips
        Obx(
          () => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: vehicles.map((vehicle) {
              final isSelected = controller.selectedVehicle.value == vehicle;
              return GestureDetector(
                onTap: () => controller.selectVehicle(vehicle),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                  child: Text(
                    vehicle,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Payment Method Dropdown Widget
  Widget _buildPaymentMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Payment Method *',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        // Dropdown
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButton<String>(
              value: controller.paymentMethod.value,
              isExpanded: true,
              underline: SizedBox(),
              dropdownColor: Colors.grey.shade900,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
              items: ['No collect', 'Collect'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: controller.changePaymentMethod,
            ),
          ),
        ),
      ],
    );
  }
}
