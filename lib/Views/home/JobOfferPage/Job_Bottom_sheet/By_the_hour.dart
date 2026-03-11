import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../widgets/CustomText.dart';
import '../../../../widgets/CustomText_Field_Hight.dart';
import 'Controller/Job_bottom_sheet_Controller.dart';
import 'Controller/Oneway_controller.dart';

class ByTheHour extends StatelessWidget {
  ByTheHour({super.key});

  final fromController = TextEditingController();
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final pickupTimeController = TextEditingController();
  final payController = TextEditingController();
  final specialController = TextEditingController();

  final OnewayController onewayControllerInstance = Get.put(OnewayController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PostJobController controller = Get.find<PostJobController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldWithLabel(
              "From",
              fromController,
              "e.g., JFK Airport, Terminal 4",
              SvgPicture.asset(
                AppIcons.fromlocation_icon,
                height: 20.sp,
                width: 20.sp,
              ),
              validator: (val) =>
                  (val == null || val.isEmpty) ? "Address is required" : null,
            ),
            _buildFieldWithLabel(
              "Duration",
              durationController,
              "e.g., 2 hours",
              SvgPicture.asset(
                AppIcons.duration_icon,
                height: 20.sp,
                width: 20.sp,
              ),
              isRequired: false,
            ),
            _buildDateTimeField(
              "Date",
              SvgPicture.asset(AppIcons.date_icon, height: 20.sp, width: 20.sp),
              dateController,
              "Select Date",
              () async {
                await onewayControllerInstance.chooseDate(context);
                final date = onewayControllerInstance.selectedDate.value;
                if (date != null) {
                  dateController.text =
                      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                }
              },
              validator: (val) =>
                  (val == null || val.isEmpty) ? "Date is required" : null,
            ),
            _buildDateTimeField(
              "Pickup Time",
              SvgPicture.asset(
                AppIcons.time_myjob_icon,
                height: 20.sp,
                width: 20.sp,
              ),
              pickupTimeController,
              "Select Time",
              () async {
                await onewayControllerInstance.chooseTime(context);
                final time = onewayControllerInstance.selectedTime.value;
                if (time != null) {
                  pickupTimeController.text =
                      onewayControllerInstance.formattedTime.value;
                }
              },
              validator: (val) =>
                  (val == null || val.isEmpty) ? "Time is required" : null,
            ),
            FormField<String>(
              initialValue: controller.selectedVehicle.value,
              validator: (value) {
                if (controller.selectedVehicle.value.isEmpty) {
                  return "Please select a vehicle type";
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleSelection(controller, state),
                    if (state.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),
            _buildFieldWithLabel(
              "Pay Amount",
              payController,
              "\$",
              SvgPicture.asset(
                AppIcons.payAmount_icon,
                height: 20.sp,
                width: 20.sp,
              ),
              validator: (val) =>
                  (val == null || val.isEmpty) ? "Amount is required" : null,
            ),
            CustomText(text: "Payment *", fontSize: 13.sp),
            SizedBox(height: 8.h),
            FormField<String>(
              initialValue: onewayControllerInstance.selectedRole.value,
              validator: (value) {
                if (onewayControllerInstance.selectedRole.value.isEmpty) {
                  return "Select payment";
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select payment',
                            style: GoogleFonts.inter(
                              color: AppColors.gray100,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value:
                              onewayControllerInstance
                                  .selectedRole
                                  .value
                                  .isEmpty
                              ? null
                              : onewayControllerInstance.selectedRole.value,
                          items: onewayControllerInstance.roles
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              onewayControllerInstance.pickRole(value);
                              state.didChange(value);
                            }
                          },
                          buttonStyleData: ButtonStyleData(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 8.h,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.black200),
                              color: Colors.transparent,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 24,
                              color: AppColors.gray100,
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.black,
                            ),
                            offset: Offset(0, -5.h),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: Radius.circular(40.r),
                              thickness: WidgetStateProperty.all(6),
                              thumbVisibility: WidgetStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 40.h,
                            padding: EdgeInsets.only(left: 14.w, right: 14.w),
                          ),
                          selectedItemBuilder: (context) {
                            return onewayControllerInstance.roles.map((
                              String value,
                            ) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  value,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, left: 10.w),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),
            _buildFieldWithLabel(
              "Special Instructions (Optional)",
              specialController,
              "e.g., VIP client, suit required, name sign needed",
              null,
              isRequired: false,
            ),
            SizedBox(height: 24.h),
            CustomJobButton(
              text: "New Job",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.submitByTheHourJob(
                    pickupLocation: fromController.text,
                    dropoffLocation: "By the hour",
                    duration: durationController.text.isEmpty
                        ? "Not specified"
                        : durationController.text,
                    date: onewayControllerInstance.selectedDate.value!,
                    time: onewayControllerInstance.selectedTime.value!,
                    paymentAmount: payController.text,
                    paymentType: onewayControllerInstance.selectedRole.value,
                    instruction: specialController.text.isEmpty
                        ? null
                        : specialController.text,
                  );
                }
              },
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWithLabel(
    String label,
    TextEditingController ctrl,
    String hint,
    Widget? icon, {
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) icon,
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
          validator: validator,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildDateTimeField(
    String label,
    Widget? icon,
    TextEditingController ctrl,
    String hint,
    VoidCallback onPressed, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) icon,
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
        GestureDetector(
          onTap: onPressed,
          child: AbsorbPointer(
            child: CustomtextFieldHight(
              controller: ctrl,
              hintText: hint,
              obscureText: false,
              textInputType: TextInputType.none,
              validator: validator,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildVehicleSelection(
    PostJobController controller,
    FormFieldState<String> state,
  ) {
    final vehicles = [
      'SEDAN',
      'SUV',
      'SPRINTER',
      'BUS',
      'LIMO STRETCH',
      'SEDAN/SUV',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppIcons.vechile_car_icon,
              height: 20.sp,
              width: 20.sp,
            ),
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
                onTap: () {
                  controller.selectVehicle(vehicle);
                  state.didChange(vehicle);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ///select color========================================================
                        ? const Color(0xFF364153)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF404040)
                          : const Color(0xFF2A2A2A),
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
        SizedBox(height: 16.h),
      ],
    );
  }
}
