import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_const.dart';
import '../../Core/routs.dart';
import '../../Utils/app_colors.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomText.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/CustomTextGary.dart';

class Signscreen extends StatelessWidget {
  Signscreen({super.key});
  final _formkey = GlobalKey<FormState>();

  // Reactive variable to control password visibility
  final isPasswordVisible = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                CustomText(text: "Welcome Back"),
                SizedBox(height: 7.h),
                // Subtitle Text
                CustomTextgray(
                  text: "Sign in to continue to your account",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Email Address",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: emailController,
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
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText:
                        !isPasswordVisible.value, // Toggle between true/false
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
                        isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: () {
                        isPasswordVisible.value =
                            !isPasswordVisible.value; // Toggle visibility
                      },
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
                CustomButton(
                  text: "Sign In",
                  onPressed: () {
                    // Handle SignIn action, like form validation
                    if (_formkey.currentState!.validate()) {
                      // Perform sign in action
                    }
                  },
                ),
                SizedBox(height: 30.h),
                Center(
                  child: CustomTextgray(
                    text: "Don't have an account?",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
