import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_const.dart';
import '../../../Utils/app_images.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';

class Resetpasswordscreen extends StatelessWidget {
  Resetpasswordscreen({super.key});
  TextEditingController emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The logo (use an image asset or network image)
                  Image.asset(AppImages.app_logo, width: 100.w, height: 100.h),
                  SizedBox(height: 20.h),
                  // Title Text
                  CustomText(text: "Elite Chauffeur Network"),
                  SizedBox(height: 30.h),
                  // Subtitle Text
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
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
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
                          controller: emailController,
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
                          style: TextStyle(
                            color: Colors.white,
                          ), // Text color inside the field
                          decoration: InputDecoration(
                            hintText: "your.email@example.com", // Hint text
                            hintStyle: TextStyle(
                              color: Color(0xFFE3DCDC),
                            ), // Hint text color
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 10.w,
                            ), // Adjust padding for input field
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: Color(0xFFE3DCDC),
                              ), // Border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: Color(0xFFE3DCDC),
                              ), // Focused border color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: Color(0xFFE3DCDC),
                              ), // Enabled border color
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          text: "Send Reset Link",
                          onPressed: () {
                            // Handle SignIn action, like form validation
                            if (_formkey.currentState!.validate()) {}
                              // Perform sign in action
                            Get.toNamed(Routes.resetpasswordtwo);
                          },
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          borderColor: Colors.white,
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
                              onTap: () {
                                Get.toNamed(Routes.signscreen);
                              },
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
                  // Dots for the indicator (if needed)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
