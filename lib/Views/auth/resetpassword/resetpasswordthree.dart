import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_const.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';

class Resetpasswordthree extends StatelessWidget {
  Resetpasswordthree({super.key});

  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Reactive variables to control password visibility
  final isPasswordVisible = false.obs;
  final isPasswordVisibleTwo = false.obs;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
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
                  // Subtitle Text
                  CustomTextgray(
                    text:
                        "Enter your email address and we'll send you a link to reset your password.",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 26.h),

                  Customtextfield(
                    controller: tokenController,
                    hintText: "Reset Token",
                    obscureText: false,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Token";
                      }
                      return null;
                    },
                    prefixIcon: Icon(Icons.vpn_key, color: AppColors.gray100),
                  ),

                  SizedBox(height: 26.h),

                  Obx(
                    () => Customtextfield(
                      controller: passwordController,
                      hintText: "New Password",
                      obscureText:
                          !isPasswordVisible.value, // Toggle between true/false
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
                  SizedBox(height: 26.h),

                  Obx(
                    () => Customtextfield(
                      controller: confirmPasswordController,
                      hintText: "Confirm New Password",
                      obscureText: !isPasswordVisibleTwo
                          .value, // Toggle between true/false
                      textInputType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Confirm New Password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      prefixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisibleTwo.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.gray100,
                        ),
                        onPressed: () {
                          isPasswordVisibleTwo.value =
                              !isPasswordVisibleTwo.value; // Toggle visibility
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: "Reset Password",
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        Get.toNamed(Routes.successResetpassword);
                      }
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.white,
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
