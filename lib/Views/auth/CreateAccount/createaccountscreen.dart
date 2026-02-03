import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_const.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';
import 'CreateAccountController/CreateAccountController.dart';


class Createaccountscreen extends StatelessWidget {
  Createaccountscreen({super.key});

  final controller = Get.put(CreateAccountController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                CustomText(text: "Account Create"),
                SizedBox(height: 7.h),
                CustomTextgray(
                  text: "Tell us about yourself to get started",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // ========== Full Name ==========
                Row(
                  children: [
                    CustomText(
                      text: "Full Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.nameController,
                  hintText: "Monirul Islam",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Name";
                    if (!AppString.usernameRegexp.hasMatch(value))
                      return "Invalid Name";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Phone Number ==========
                Row(
                  children: [
                    CustomText(
                      text: "Phone Number",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.phoneController,
                  hintText: "01744114084",
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Phone";
                    if (!AppString.phoneRegexp.hasMatch(value))
                      return "Invalid Phone";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Service Area (Dropdown) ==========
                Row(
                  children: [
                    CustomText(
                      text: "Service Area",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Miami, FL',
                        style: GoogleFonts.inter(
                          color: AppColors.gray100,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: controller.selectedArea.value.isEmpty
                          ? null
                          : controller.selectedArea.value,
                      items: controller.cities
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
                          controller.pickArea(value);
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
                          size: 24.sp,
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
                        return controller.cities.map((String value) {
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
                SizedBox(height: 20.h),

                // ========== Years of Experience ==========
                Row(
                  children: [
                    CustomText(
                      text: "Years of Experience",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.yearController,
                  hintText: "7",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Years of Experience";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Company Name ==========
                Row(
                  children: [
                    CustomText(
                      text: "Company Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.companyNameController,
                  hintText: "SADRTX",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Company Name";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Company Role (Dropdown) ==========
                Row(
                  children: [
                    CustomText(
                      text: "COMPANY ROLE",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Role',
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
                          size: 24.sp,
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
                                color: Colors.black,
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
                SizedBox(height: 20.h),

                // ========== Password ==========
                Row(
                  children: [
                    CustomText(
                      text: "Password",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.passwordController,
                    hintText: "Password",
                    obscureText: !controller.showPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter your Password";
                      if (!AppString.passRegexp.hasMatch(value))
                        return "Invalid Password";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Confirm Password ==========
                Row(
                  children: [
                    CustomText(
                      text: "Confirm Password",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: !controller.showConfirmPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter Confirm Password";
                      if (!AppString.passRegexp.hasMatch(value))
                        return "Invalid Confirm Password";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showConfirmPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: controller.toggleConfirmPassword,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // ========== Submit Button ==========
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                    //if (_formKey.currentState!.validate()) {}
                    Get.toNamed(Routes.vehicleinformation);
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
