import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import '../controllers/expense_controller.dart';

class AddExpenseSheet extends StatelessWidget {
  final ExpenseController controller = Get.find<ExpenseController>();
  final _formKey = GlobalKey<FormState>();

  AddExpenseSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = controller.currentTheme;
      return Container(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border.all(color: theme.borderColor, width: 1.5),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag indicator and Header
                Center(
                  child: Container(
                    width: 50.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: theme.borderColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add New Expense",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white, size: 22.sp),
                    ),
                  ],
                ),
                Divider(
                  color: theme.borderColor.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                SizedBox(height: 15.h),

                // Category Field
                _buildFieldLabel("Category"),
                DropdownButtonFormField<String>(
                  key: ValueKey(theme.name),
                  value: controller.selectedCategory.value,
                  dropdownColor: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16.r),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: theme.accentColor,
                    size: 22,
                  ),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: _buildInputDecoration("Select Category", theme),
                  items:
                      [
                        'Fuel',
                        'Oil Change',
                        'Maintenance',
                        'Parking',
                        'Tolls',
                        'Others',
                      ].map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Text(
                              cat,
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
                      controller.setCategory(val);
                    }
                  },
                ),
                SizedBox(height: 15.h),

                // Amount Field
                _buildFieldLabel("Amount (\$)"),
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: _buildInputDecoration(
                    "Enter amount e.g. 50.00",
                    theme,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Amount is required";
                    }
                    if (double.tryParse(val) == null ||
                        double.parse(val) <= 0) {
                      return "Enter a valid positive amount";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),

                // Date Field
                _buildFieldLabel("Date"),
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: theme.accentColor,
                              onPrimary: Colors.white,
                              surface: const Color(0xFF1E1E1E),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      controller.setDate(picked);
                    }
                  },
                  controller: TextEditingController(
                    text: DateFormat(
                      'dd MMM yyyy',
                    ).format(controller.selectedDate.value),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: _buildInputDecoration("Select Date", theme)
                      .copyWith(
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                ),
                SizedBox(height: 15.h),

                // Description Field
                _buildFieldLabel("Description (Optional)"),
                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: _buildInputDecoration(
                    "Add description/notes...",
                    theme,
                  ),
                ),
                SizedBox(height: 20.h),

                // Receipt Attachment
                _buildFieldLabel("Receipt Attachment (Optional)"),
                Builder(
                  builder: (context) {
                    final file = controller.selectedImage.value;
                    if (file != null) {
                      return Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: theme.borderColor),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => controller.selectedImage.value = null,
                            child: Container(
                              margin: EdgeInsets.all(8.r),
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildAttachmentButton(
                              icon: Icons.camera_alt_outlined,
                              label: "Camera",
                              theme: theme,
                              onTap: () =>
                                  controller.pickImage(ImageSource.camera),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: _buildAttachmentButton(
                              icon: Icons.photo_library_outlined,
                              label: "Gallery",
                              theme: theme,
                              onTap: () =>
                                  controller.pickImage(ImageSource.gallery),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 30.h),

                // Submit Button
                CustomButton(
                  text: "Add Expense",
                  backgroundColor: const Color(0xFFD08700),
                  textColor: Colors.black,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.addExpense();
                    }
                  },
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: AppColors.gray100,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, ExpenseThemeData theme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.gray100, fontSize: 13.sp),
      errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: theme.accentColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required ExpenseThemeData theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
