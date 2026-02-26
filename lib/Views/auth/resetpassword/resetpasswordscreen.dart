import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_const.dart';
import '../../../Utils/app_images.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import 'ForgetPassword/forgetPassword_controller.dart';


class Resetpasswordscreen extends StatelessWidget {
  Resetpasswordscreen({super.key});

  final _controller = Get.put(ForgotPasswordController());

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
                children: [
                  Image.asset(AppImages.app_logo, width: 100.w, height: 100.h),
                  SizedBox(height: 20.h),
                  CustomText(text: "Elite Chauffeur Network"),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF394156),
                      border: Border.all(color: Color(0xFF1E2939)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            SizedBox(width: 10.w),
                            CustomText(text: "Forget Password", fontSize: 20),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        CustomTextgray(
                          text:
                          "Enter your email address and we'll send you a link to reset your password.",
                          color: Color(0xFFE3DCDC),
                        ),
                        SizedBox(height: 20.h),
                        CustomText(
                          text: "Email Address",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _controller.emailController,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter your Email";
                            }
                            if (!AppString.emailRegexp.hasMatch(value)) {
                              return "Invalid Email";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "your.email@example.com",
                            hintStyle: TextStyle(color: Color(0xFFE3DCDC)),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 10.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: Color(0xFFE3DCDC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: Color(0xFFE3DCDC)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: Color(0xFFE3DCDC)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // ── Send Button ──
                        Obx(
                              () => CustomButton(
                            text: _controller.isLoading.value
                                ? "Sending..."
                                : "Send Reset Link",
                            onPressed: () {
                              if (!_controller.isLoading.value) {
                                _controller.forgotPassword();
                              }
                            },
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            borderColor: Colors.white,
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextgray(
                              text: "Remember your password?",
                              color: Color(0xFFE3DCDC),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.signscreen),
                              child: CustomTextgray(
                                text: "Sign In",
                                color: Color(0xFFA49898),
                              ),
                            ),
                          ],
                        ),
                      ],
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