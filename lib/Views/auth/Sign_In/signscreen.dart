import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_const.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';
import 'Controller/signin_controller.dart';

class Signscreen extends StatelessWidget {
  Signscreen({super.key});

  final _controller = Get.put(LoginController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _controller.formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                CustomText(text: "Welcome Back"),
                SizedBox(height: 7.h),
                CustomTextgray(
                  text: "Sign in to continue to your account",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Email Address",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: _controller.emailController,
                  hintText: "your.email@example.com",
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Email";
                    }
                    if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Invalid Email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: _controller.passwordController,
                    hintText: "Enter your password",
                    obscureText: !_controller.isPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your Password";
                      }
                      if (!AppString.passRegexp.hasMatch(value)) {
                        return "Invalid password";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: _controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.resetpasswordscreen);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextgray(
                      text: "Forgot Password?",
                      color: AppColors.gray100,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Error Message ──
                Obx(() {
                  if (_controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      _controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 13.sp),
                    ),
                  );
                }),
                // ── Sign In Button ──
                Obx(
                      () => CustomButton(
                    text: _controller.isLoading.value ? "Signing In..." : "Sign In",
                    onPressed: () {
                      if (!_controller.isLoading.value) {
                        _controller.login();
                      }
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.createaccountscreen);
                  },
                  child: Center(
                    child: CustomTextgray(
                      text: "Don't have an account?",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
