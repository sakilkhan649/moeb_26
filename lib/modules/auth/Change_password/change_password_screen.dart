import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_const.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';
import 'Controller/change_pass_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black100,
        title:CustomText(text: "Change Password"),
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
      ),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your New Password";
                      }
                      if (!AppString.passRegexp.hasMatch(value)) {
                        return "Invalid password";
                      }
                      return null;
                    },
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