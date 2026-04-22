import 'package:moeb_26/widgets/Custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/validators.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/CustomTextGary.dart';

class Createaccountscreen extends StatefulWidget {
  const Createaccountscreen({super.key});

  @override
  State<Createaccountscreen> createState() => _CreateaccountscreenState();
}

class _CreateaccountscreenState extends State<Createaccountscreen> {
  final RxString areaError = ''.obs;
  final RxString roleError = ''.obs;

  // Using the unified SignupController
  final controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();
  final ScrollController dropdownScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchServiceAreas();
    dropdownScrollController.addListener(_onDropdownScroll);
  }

  void _onDropdownScroll() {
    if (dropdownScrollController.position.pixels >=
        dropdownScrollController.position.maxScrollExtent - 50) {
      controller.loadMoreCities();
    }
  }

  @override
  void dispose() {
    dropdownScrollController.removeListener(_onDropdownScroll);
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
                const CustomText(text: "Account Create"),
                SizedBox(height: 7.h),
                CustomTextgray(
                  text: "Tell us about yourself to get started",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // ========== Full Name ==========
                _buildLabel("Full Name", isRequired: true),
                Customtextfield(
                  controller: controller.nameController,
                  hintText: "Monirul Islam",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) => Validators.name(value),
                ),
                SizedBox(height: 20.h),

                // ========== Phone Number ==========
                _buildLabel("Phone Number", isRequired: true),
                Customtextfield(
                  controller: controller.phoneController,
                  hintText: "01744114084",
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  validator: (value) => Validators.phone(value),
                ),
                SizedBox(height: 20.h),

                // ========== Email Address ==========
                _buildLabel("Email Address", isRequired: true),
                Customtextfield(
                  controller: controller.emailController,
                  hintText: "your.email@example.com",
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) => Validators.email(value),
                ),
                SizedBox(height: 20.h),

                // // ========== Home Address ==========
                // _buildLabel("Home Address", isRequired: true),
                // Customtextfield(
                //   controller: controller.homeAddressController,
                //   hintText: "Enter your home address",
                //   obscureText: false,
                //   textInputType: TextInputType.streetAddress,
                //   validator: (value) => Validators.required(value, message: "Enter your Home Address"),
                // ),
                // SizedBox(height: 20.h),

                // ========== Service Area ==========
                _buildLabel("Service Area", isRequired: true),
                Obx(
                  () => _buildDropdownField(
                    error: areaError.value,
                    isLoading: controller.isCitiesLoading,
                    child: CustomDropdown(
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
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Years of Experience ==========
                _buildLabel("Years of Experience", isRequired: false),
                Customtextfield(
                  controller: controller.yearController,
                  hintText: "7",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) => Validators.required(
                    value,
                    message: "Enter your Years of Experience",
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Company Name ==========
                _buildLabel("Company Name", isRequired: true),
                Customtextfield(
                  controller: controller.companyNameController,
                  hintText: "SADRTX",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) => Validators.required(
                    value,
                    message: "Enter your Company Name",
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Company Role ==========
                _buildLabel("COMPANY ROLE", isRequired: true),
                Obx(
                  () => _buildDropdownField(
                    error: roleError.value,
                    child: CustomDropdown(
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
                  ),
                ),
                SizedBox(height: 20.h),

                // ========== Password ==========
                _buildLabel("Create Password", isRequired: false),
                Obx(
                  () => Customtextfield(
                    controller: controller.passwordController,
                    hintText: "Enter your password",
                    obscureText: !controller.showPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) => Validators.password(value),
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
                _buildLabel("Confirm Password", isRequired: false),
                Obx(
                  () => Customtextfield(
                    controller: controller.confirmPasswordController,
                    hintText: "Enter your password",
                    obscureText: !controller.showConfirmPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      controller.passwordController.text,
                    ),
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
                CustomButton(text: "Continue", onPressed: _handleSubmit),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          CustomText(text: text, fontWeight: FontWeight.w500, fontSize: 14.sp),
          if (isRequired)
            Text(
              " *",
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required Widget child,
    String? error,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: AppColors.orange100),
            ),
          )
        else
          child,
        if (error != null && error.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 6.h),
            child: Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  // --- Logic ---

  void _handleSubmit() {
    final isFormValid = _formKey.currentState!.validate();

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
      Get.toNamed(Routes.vehicleinformation);
    }
  }
}
