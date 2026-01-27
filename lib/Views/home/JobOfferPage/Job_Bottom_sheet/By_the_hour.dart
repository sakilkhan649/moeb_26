import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../widgets/CustomText_Field_Hight.dart';
import 'Controller/Job_bottom_sheet_Controller.dart';

class ByTheHour extends StatelessWidget {
  ByTheHour({super.key});

  final fromController = TextEditingController();
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final pickupTimeController = TextEditingController();
  final payController = TextEditingController();
  final specialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PostJobController controller = Get.find<PostJobController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldWithLabel(
            "From",
            fromController,
            "e.g., JFK Airport, Terminal 4",
            Icons.location_on_outlined,
          ),
          SizedBox(height: 20.h),
          _buildFieldWithLabel(
            "Duration",
            durationController,
            "e.g., 2 hours",
            Icons.timelapse_outlined,
          ),
          SizedBox(height: 20.h),
          _buildFieldWithLabel("Date", dateController, "", Icons.date_range),
          SizedBox(height: 20.h),
          _buildFieldWithLabel(
            "Pickup Time",
            pickupTimeController,
            "",
            Icons.access_time,
          ),
          SizedBox(height: 20.h),
          _buildVehicleSelection(controller),
          SizedBox(height: 16.h),
          _buildFieldWithLabel(
            "Pay Amount",
            payController,
            "\$120",
            Icons.attach_money,
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethodDropdown(controller),
          SizedBox(height: 16.h),
          _buildFieldWithLabel(
            "Special Instructions (Optional)",
            specialController,
            "e.g., VIP client, suit required, name sign needed",
            Icons.notes,
            isRequired: false,
          ),
          SizedBox(height: 24.h),
          CustomJobButton(text: "+ New Job", onPressed: () {
            Get.toNamed(Routes.myJobsScreen);
          }),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildFieldWithLabel(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              label + (isRequired ? ' *' : ''),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        CustomtextFieldHight(
          controller: ctrl,
          hintText: hint,
          obscureText: false,
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildVehicleSelection(PostJobController controller) {
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
        Row(
          children: [
            Icon(Icons.directions_car, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              'Vehicle Type Required *',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
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
                    color: isSelected ? Color(0xFF2A2A2A) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? Color(0xFF404040) : Color(0xFF2A2A2A),
                    ),
                  ),
                  child: Text(
                    vehicle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
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

  Widget _buildPaymentMethodDropdown(PostJobController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payment, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              'Payment Method *',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.black200),
            ),
            child: DropdownButton<String>(
              value: controller.paymentMethod.value,
              isExpanded: true,
              underline: SizedBox(),
              dropdownColor: Colors.black,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 30.sp,
              ),
              style: GoogleFonts.inter(color: Colors.black, fontSize: 13.sp),
              items: ['Collect', 'No collect']
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.changePaymentMethod,
            ),
          ),
        ),
      ],
    );
  }
}
