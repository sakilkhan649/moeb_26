import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextField.dart';
import 'package:moeb_26/widgets/CustomText_Field_Hight.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../../Core/routs.dart';
import '../../../../widgets/CustomTextGary.dart';
import 'Controller/Job_bottom_sheet_Controller.dart';
import 'Controller/Oneway_controller.dart';

class OnewayScreen extends StatelessWidget {
  OnewayScreen({super.key});

  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final flightController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final payController = TextEditingController();
  final specialController = TextEditingController();

  TextEditingController onewayController = TextEditingController();
  final OnewayController onewayControllerInstance = Get.put(
    OnewayController(),
  ); // Rename to avoid confusion

  @override
  Widget build(BuildContext context) {
    final PostJobController postJobController =
        Get.find<
          PostJobController
        >(); // Ensure the PostJobController is initialized

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldWithLabel(
            "Pickup Location",
            pickupController,
            "e.g., JFK Airport, Terminal 4",
            Icons.location_on_outlined,
          ),
          SizedBox(height: 20.h),
          _buildFieldWithLabel(
            "Drop-off Location",
            dropoffController,
            "e.g., Manhattan, Times Square",
            Icons.location_on_outlined,
          ),
          SizedBox(height: 20.h),
          _buildFieldWithLabel(
            "Flight Number (Optional)",
            flightController,
            "",
            Icons.flight,
            isRequired: false,
          ),
          SizedBox(height: 20.h),
          _buildDateTimeRow(),
          SizedBox(height: 16.h),
          _buildVehicleSelection(postJobController),
          SizedBox(height: 16.h),
          _buildFieldWithLabel(
            "Pay Amount",
            payController,
            "\$120",
            Icons.attach_money,
          ),
          SizedBox(height: 20.h),
          CustomText(text: "Payment Method *", fontSize: 13.sp),
          SizedBox(height: 8.h),
          Obx(
            () => Customtextfield(
              controller: TextEditingController(),
              hintText: onewayControllerInstance.selectedRole.value.isEmpty
                  ? 'No Collect'
                  : onewayControllerInstance.selectedRole.value,
              obscureText: false,
              textInputType: TextInputType.name,
              suffixIcon: IconButton(
                onPressed: () async {
                  // Show dialog when arrow button is clicked
                  String? selected = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: SingleChildScrollView(
                          child: Column(
                            children: onewayControllerInstance.roles.map((
                              role,
                            ) {
                              return ListTile(
                                title: Text(
                                  role,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                    role,
                                  ); // Close dialog and return selected role
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                  // Save the selected role if user selects one
                  if (selected != null) {
                    onewayControllerInstance.pickRole(selected);
                  }
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                  color: AppColors.gray100,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your Company Role";
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 16.h),
          _buildFieldWithLabel(
            "Special Instructions (Optional)",
            specialController,
            "e.g., VIP client, suit required, name sign needed",
            Icons.notes,
            isRequired: false,
          ),
          SizedBox(height: 24.h),
          CustomJobButton(
            text: "New Job",
            onPressed: () {
              Get.toNamed(Routes.myJobsScreen);
            },
          ),
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

  Widget _buildDateTimeRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDateTimeField("Date", dateController, Icons.date_range),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildDateTimeField("Time", timeController, Icons.access_time),
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
    String label,
    TextEditingController ctrl,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              '$label *',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Customtextfield(
          controller: ctrl,
          hintText: "",
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
}
