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

class Createaccountscreen extends StatelessWidget {
  Createaccountscreen({super.key});
  final _formkey = GlobalKey<FormState>();

  // Reactive variable to control password visibility
  final isPasswordVisible = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyRoleController = TextEditingController();

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
                CustomText(text: "Account Create"),
                SizedBox(height: 7.h),
                // Subtitle Text
                CustomTextgray(
                  text: "Tell us about yourself to get started",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                /// Full Name
                Row(
                  children: [
                    CustomText(
                      text: "Full Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: nameController,
                  hintText: "Monirul Islam",
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Name";
                    }
                    if (!AppString.usernameRegexp.hasMatch(value)) {
                      return "Invalid Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// Phone Number
                Row(
                  children: [
                    CustomText(
                      text: "Phone Number",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: phoneController,
                  hintText: "01744114084",
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Phone";
                    }
                    if (!AppString.phoneRegexp.hasMatch(value)) {
                      return "Invalid Phone";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// Email Address
                Row(
                  children: [
                    CustomText(
                      text: "Email Address",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: phoneController,
                  hintText: "m@gmail.com",
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

                /// Service Area
                Row(
                  children: [
                    CustomText(
                      text: "Service Area",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: serviceController,
                  hintText: "ATLANTA",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Service Area";
                    }
                    if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Invalid service Area";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// Years of Experience
                Row(
                  children: [
                    CustomText(
                      text: "Years of Experience",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: yearController,
                  hintText: "7",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Years of Experience";
                    }
                    if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Invalid Years of Experience";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// Company Name
                Row(
                  children: [
                    CustomText(
                      text: "Company Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: companyNameController,
                  hintText: "SADRTX",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Company Name";
                    }
                    if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Invalid Company Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// Company Name
                Row(
                  children: [
                    CustomText(
                      text: "Company Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: companyNameController,
                  hintText: "SADRTX",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Company Name";
                    }
                    if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Invalid Company Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                /// COMPANY ROLE *
                Row(
                  children: [
                    CustomText(
                      text: "COMPANY ROLE *",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: companyRoleController,
                  hintText: "DRIVER",
                  obscureText: false,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30, // Or CupertinoIcons.arrow_left
                      color: AppColors.gray100,
                    ),
                  ),
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Company Name";
                    }
                    // Adjust the validation logic if necessary
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                    // Handle SignIn action, like form validation
                    if (_formkey.currentState!.validate()) {}
                    Get.toNamed(Routes.vehicleinformation);
                  },
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
