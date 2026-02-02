import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomTextField.dart';
import 'package:moeb_26/widgets/CustomText_Field_Hight.dart';
import 'Controller/edit_controller.dart';

class EditScreen extends StatelessWidget {
  EditScreen({super.key});

  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final flightController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final payController = TextEditingController();
  final specialController = TextEditingController();

  final EditController editController = Get.put(EditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            _buildHeader(),
            SizedBox(height: 10.h),
            _buildFieldWithLabel(
              "Pickup Location",
              pickupController,
              "e.g., JFK Airport, Terminal 4",
              Icons.location_on_outlined,
            ),
            _buildFieldWithLabel(
              "Drop-off Location",
              dropoffController,
              "e.g., Manhattan, Times Square",
              Icons.location_on_outlined,
            ),
            _buildFieldWithLabel(
              "Flight Number (Optional)",
              flightController,
              "",
              Icons.flight,
              isRequired: false,
            ),
            _buildDateTimeRow(),
            SizedBox(height: 16.h),
            _buildVehicleSelection(editController),
            SizedBox(height: 16.h),
            _buildFieldWithLabel(
              "Pay Amount",
              payController,
              "\$120",
              Icons.attach_money,
            ),
            _buildPaymentMethodDropdown(editController),
            SizedBox(height: 16.h),
            _buildFieldWithLabel(
              "Special Instructions (Optional)",
              specialController,
              "e.g., VIP client, suit required, name sign needed",
              Icons.notes,
              isRequired: false,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Cancel",
                    backgroundColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: CustomButton(
                    text: "Save",
                    backgroundColor: AppColors.orange100,
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
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
          child: Obx(() {
            final date = editController.selectedDate.value;
            dateController.text = date == null
                ? ""
                : "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            return _buildDateTimeField(
              "Date",
              Icons.date_range,
              dateController,
              "Select Date",
              (context) => editController.chooseDate(context),
            );
          }),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Builder(
            builder: (context) => Obx(() {
              final time = editController.selectedTime.value;
              timeController.text = time == null ? "" : time.format(context);
              return _buildDateTimeField(
                "Time",
                Icons.access_time,
                timeController,
                "Select Time",
                (context) => editController.chooseTime(context),
              );
            }),
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
    Function(BuildContext) onPressed,
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
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => onPressed(context),
            child: AbsorbPointer(
              child: Customtextfield(
                controller: ctrl,
                hintText: hint,
                obscureText: false,
                textInputType: TextInputType.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSelection(EditController controller) {
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

  Widget _buildPaymentMethodDropdown(EditController controller) {
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
          () => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'No Collect',
                style: GoogleFonts.inter(
                  color: AppColors.gray100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: controller.selectedRole.value.isEmpty
                  ? null
                  : controller.selectedRole.value,
              items: controller.roles
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
                  controller.pickRole(value);
                }
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
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
                  color: Colors.white,
                ),
                offset: Offset(0, -5.h),
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(40.r),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 40.h,
                padding: EdgeInsets.only(left: 14.w, right: 14.w),
              ),
              selectedItemBuilder: (context) {
                return controller.roles.map((String value) {
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
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Job',
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
}
