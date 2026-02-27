import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/app_const.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomText.dart';
import '../../../../widgets/CustomTextField.dart';
import '../../../../widgets/CustomTextGary.dart';
import 'resetPassword_controller.dart';


class Resetpasswordthree extends StatelessWidget {
  Resetpasswordthree({super.key});

  final _controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _controller.formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: "Forget Password"),
                  ),
                  SizedBox(height: 30.h),
                  CustomTextgray(
                    text: "Enter your email address and we'll send you a link to reset your password.",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 26.h),

                  // ── New Password ──
                  Obx(
                        () => Customtextfield(
                      controller: _controller.passwordController,
                      hintText: "New Password",
                      obscureText: !_controller.isPasswordVisible.value,
                      textInputType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your New Password";
                        }
                        if (!AppString.passRegexp.hasMatch(value)) {
                          return "Invalid New Password";
                        }
                        return null;
                      },
                      prefixIcon: IconButton(
                        icon: Icon(
                          _controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.gray100,
                        ),
                        onPressed: _controller.togglePassword,
                      ),
                    ),
                  ),
                  SizedBox(height: 26.h),

                  // ── Confirm Password ──
                  Obx(
                        () => Customtextfield(
                      controller: _controller.confirmPasswordController,
                      hintText: "Confirm New Password",
                      obscureText: !_controller.isPasswordVisibleTwo.value,
                      textInputType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Confirm New Password";
                        }
                        if (value != _controller.passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      prefixIcon: IconButton(
                        icon: Icon(
                          _controller.isPasswordVisibleTwo.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.gray100,
                        ),
                        onPressed: _controller.toggleConfirmPassword,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // ── Reset Button ──
                  Obx(
                        () => CustomButton(
                      text: _controller.isLoading.value
                          ? "Resetting..."
                          : "Reset Password",
                      onPressed: () {
                        if (!_controller.isLoading.value) {
                          _controller.resetPassword();
                        }
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}