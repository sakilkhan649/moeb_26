import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/utils/validators.dart';
import '../../../../core/widgets/CustomButton.dart';
import '../../../../core/widgets/CustomText.dart';
import '../../../../core/widgets/CustomTextField.dart';
import '../../../../core/widgets/CustomTextGary.dart';
import '../controllers/change_pass_controller.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final ChangePasswordController controller =
      Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              'Change Password',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                CustomTextgray(
                  text:
                      "Enter your current password and new password to change your password.",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 20.h),

                /// ========== Current Password ==========
                CustomText(
                  text: "Current Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.currentPasswordController,
                    hintText: "Enter your current password",
                    obscureText: !controller.isCurrentPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your Current Password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isCurrentPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: () {
                        controller.isCurrentPasswordVisible.value =
                            !controller.isCurrentPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                /// ========== New Password ==========
                CustomText(
                  text: "New Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.newPasswordController,
                    hintText: "Enter your new password",
                    obscureText: !controller.isNewPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) => Validators.password(
                      value,
                      minLength: 8,
                      requireDigit: true,
                      requireUppercase: true,
                      requireSpecialChar: true,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: () {
                        controller.isNewPasswordVisible.value =
                            !controller.isNewPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                /// ========== Confirm Password ==========
                CustomText(
                  text: "Confirm Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.confirmPasswordController,
                    hintText: "Re-enter your new password",
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Confirm Password";
                      }
                      if (value != controller.newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: () {
                        controller.isConfirmPasswordVisible.value =
                            !controller.isConfirmPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                /// ========== Button ==========
                Obx(
                  () => CustomButton(
                    text: controller.isLoading.value
                        ? "Please wait..."
                        : "Change Password",
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.changePassword();
                            }
                          },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
