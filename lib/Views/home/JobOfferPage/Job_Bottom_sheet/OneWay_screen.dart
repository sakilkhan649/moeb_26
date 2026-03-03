import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:moeb_26/Utils/app_colors.dart';

import 'package:moeb_26/widgets/CustomText.dart';

import 'package:moeb_26/widgets/CustomText_Field_Hight.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../../Core/routs.dart';
import 'Controller/Job_bottom_sheet_Controller.dart';
import 'Controller/Oneway_controller.dart';

class OnewayScreen extends StatefulWidget {
  const OnewayScreen({super.key});

  @override
  State<OnewayScreen> createState() => _OnewayScreenState();
}

class _OnewayScreenState extends State<OnewayScreen> {
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final flightController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final payController = TextEditingController();
  final specialController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final OnewayController onewayControllerInstance = Get.put(OnewayController());

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    flightController.dispose();
    dateController.dispose();
    timeController.dispose();
    payController.dispose();
    specialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PostJobController postJobController = Get.find<PostJobController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //dite hove
            _buildFieldWithLabel(
              textInputType: TextInputType.text,
              "Pickup Location",
              pickupController,
              "e.g., JFK Airport, Terminal 4",
              Icons.location_on_outlined,
              validator: (val) => (val == null || val.isEmpty)
                  ? "Pickup location is required"
                  : null,
            ),
            //dite hove
            _buildFieldWithLabel(
              textInputType: TextInputType.text,
              "Drop-off Location",
              dropoffController,
              "e.g., Manhattan, Times Square",
              Icons.location_on_outlined,
              validator: (val) => (val == null || val.isEmpty)
                  ? "Drop-off location is required"
                  : null,
            ),
            //dite hove
            _buildFieldWithLabel(
              textInputType: TextInputType.text,
              "Flight Number (Optional)",
              flightController,
              "",
              Icons.flight,
              isRequired: false,
            ),
            _buildDateTimeRow(context),
            FormField<String>(
              initialValue: postJobController.selectedVehicle.value,
              validator: (value) {
                if (postJobController.selectedVehicle.value.isEmpty) {
                  return "Please select a vehicle type";
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleSelection(postJobController, state),
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
            SizedBox(height: 10.h),
            //dite hove
            _buildFieldWithLabel(
              textInputType: TextInputType.number,
              "Pay Amount",
              payController,
              "\$",
              Icons.attach_money,
              validator: (val) =>
                  (val == null || val.isEmpty) ? "Amount is required" : null,
            ),
            CustomText(text: "Payment *", fontSize: 13.sp),
            SizedBox(height: 8.h),
            Obx(
              () => DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
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
                  fillColor: Colors.transparent,
                  filled: true,
                ),
                hint: Text(
                  'Select payment',
                  style: GoogleFonts.inter(
                    color: AppColors.gray100,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value:
                    onewayControllerInstance.selectedRole.value.isEmpty
                        ? null
                        : onewayControllerInstance.selectedRole.value,
                items: onewayControllerInstance.roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: GoogleFonts.inter(
                            color: Colors.black,
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
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select payment";
                  }
                  return null;
                },
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.only(right: 8.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
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
                    color: Colors.white,
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
                  return onewayControllerInstance.roles.map((String value) {
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
            SizedBox(height: 20.h),
            //dite hove
            _buildFieldWithLabel(
              textInputType: TextInputType.text,
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
                if (_formKey.currentState!.validate()) {
                  postJobController.submitOneWayJob(
                    pickupLocation: pickupController.text,
                    dropoffLocation: dropoffController.text,
                    flightNumber: flightController.text,
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
    IconData icon, {
    bool isRequired = true,
    String? Function(String?)? validator,
    TextInputType textInputType = TextInputType.none,
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
          textInputType: textInputType,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDateTimeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateTimeField(
            "Date",
            Icons.date_range,
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
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildDateTimeField(
            "Time",
            Icons.access_time,
            timeController,
            "Select Time",
            () async {
              await onewayControllerInstance.chooseTime(context);
              final time = onewayControllerInstance.selectedTime.value;
              if (time != null) {
                timeController.text = time.format(context);
              }
            },
            validator: (val) =>
                (val == null || val.isEmpty) ? "Time is required" : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
    String label,
    IconData icon,
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
      ],
    );
  }

  Widget _buildVehicleSelection(
    PostJobController controller,
    FormFieldState<String> state,
  ) {
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
