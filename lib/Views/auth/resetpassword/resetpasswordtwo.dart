import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_const.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';

class Resetpasswordtwo extends StatelessWidget {
  Resetpasswordtwo({super.key});
  TextEditingController emailOneController = TextEditingController();
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
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF14F195)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.check_mark, color: Color(0xFF14F195)),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: "Password reset link sent to your email!",
                          fontSize: 13,
                          color: Color(0xFF14F195),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 26.h),

                  Customtextfield(
                    controller: emailOneController,
                    hintText: "your.email@example.com",
                    obscureText: false,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.gray100,
                    ),
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
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: "Send Reset Link",
                    onPressed: () {
                      // Handle SignIn action, like form validation
                      if (_formkey.currentState!.validate()) {}
                      // Perform sign in action
                      Get.toNamed(Routes.resetpasswordthree);
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
