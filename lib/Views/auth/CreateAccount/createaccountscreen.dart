import 'package:moeb_26/widgets/Custom_dropdown.dart';
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
import 'CreateAccountController/CreateAccountController.dart';

class Createaccountscreen extends StatefulWidget {
  Createaccountscreen({super.key});

  @override
  State<Createaccountscreen> createState() => _CreateaccountscreenState();
}

class _CreateaccountscreenState extends State<Createaccountscreen> {
  // Reactive error messages for dropdowns (not covered by Form validation)
  final RxString areaError = ''.obs;
  final RxString roleError = ''.obs;

  final controller = Get.put(CreateAccountController());
  final _formKey = GlobalKey<FormState>();
  final ScrollController dropdownScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    dropdownScrollController.addListener(() {
      if (dropdownScrollController.position.pixels >=
          dropdownScrollController.position.maxScrollExtent - 50) {
        controller.loadMoreCities();
      }
    });
  }

  @override
  void dispose() {
    dropdownScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                CustomText(text: "Account Create"),
                SizedBox(height: 7.h),
                CustomTextgray(
                  text: "Tell us about yourself to get started",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // ========== Full Name ==========
                Row(
                  children: [
                    CustomText(
                      text: "Full Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.nameController,
                  hintText: "Monirul Islam",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Name";
                    if (!AppString.usernameRegexp.hasMatch(value))
                      return "Invalid Name";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Phone Number ==========
                Row(
                  children: [
                    CustomText(
                      text: "Phone Number",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.phoneController,
                  hintText: "01744114084",
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Phone";
                    if (!AppString.phoneRegexp.hasMatch(value))
                      return "Invalid Phone";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                // ========== Email Address ==========
                Row(
                  children: [
                    CustomText(
                      text: "Email Address",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.emailController,
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
                // ========== Home Address ==========
                Row(
                  children: [
                    CustomText(
                      text: "Home Address",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.homeAddressController,
                  hintText: "",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Home Address";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                // ========== Service Area (Dropdown) ==========
                Row(
                  children: [
                    CustomText(
                      text: "Service Area",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Using CustomDropdown for clearer code and reusability
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.isCitiesLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.orange100,
                              ),
                            )
                          : CustomDropdown(
                              hintText: 'Select Service Area',
                              value: controller.selectedArea.value.isEmpty
                                  ? null
                                  : controller.selectedArea.value,
                              items: controller.cities,
                              scrollController: dropdownScrollController,
                              isLoadingMore: controller.isMoreCitiesLoading,
                              hasNextPage: controller.hasNextCitiesPage,
                              onLoadMore: () => controller.loadMoreCities(),
                              onChanged: (value) {
                                if (value != null &&
                                    value != 'loading' &&
                                    value != 'loadMore') {
                                  controller.pickArea(value);
                                  areaError.value = '';
                                }
                              },
                            ),
                      if (areaError.value.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 12.w, top: 6.h),
                          child: Text(
                            areaError.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Years of Experience ==========
                Row(
                  children: [
                    CustomText(
                      text: "Years of Experience",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.yearController,
                  hintText: "7",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Years of Experience";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Company Name ==========
                Row(
                  children: [
                    CustomText(
                      text: "Company Name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: controller.companyNameController,
                  hintText: "SADRTX",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Enter your Company Name";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // ========== Company Role (Dropdown) ==========
                Row(
                  children: [
                    CustomText(
                      text: "COMPANY ROLE",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Using CustomDropdown for consistent UI and less boilerplate
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        hintText: 'Select Company Role',
                        value: controller.selectedRole.value.isEmpty
                            ? null
                            : controller.selectedRole.value,
                        items: controller.roles,
                        onChanged: (value) {
                          if (value != null) {
                            controller.pickRole(value);
                            roleError.value = '';
                          }
                        },
                      ),
                      if (roleError.value.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 12.w, top: 6.h),
                          child: Text(
                            roleError.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Password ==========
                CustomText(
                  text: "Create Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),

                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.passwordController,
                    hintText: "Enter your password",
                    obscureText: !controller.showPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter your Password";
                      if (!AppString.passRegexp.hasMatch(value))
                        return "Invalid Password";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Confirm Password ==========
                CustomText(
                  text: "Confirm Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),

                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: controller.confirmPasswordController,
                    hintText: "Enter your password",
                    obscureText: !controller.showConfirmPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter Confirm Password";
                      if (value != controller.passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showConfirmPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray100,
                      ),
                      onPressed: controller.toggleConfirmPassword,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // ========== Submit Button ==========
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                    // Validate text fields via Form
                    final isFormValid = _formKey.currentState!.validate();

                    // Validate dropdowns manually
                    bool dropdownsValid = true;
                    if (controller.selectedArea.value.isEmpty) {
                      areaError.value = 'Select a Service Area';
                      dropdownsValid = false;
                    }
                    if (controller.selectedRole.value.isEmpty) {
                      roleError.value = 'Select a Company Role';
                      dropdownsValid = false;
                    }

                    if (isFormValid && dropdownsValid) {
                      controller.register();
                    }
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
