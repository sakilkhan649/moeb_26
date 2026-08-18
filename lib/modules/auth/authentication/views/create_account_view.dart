import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/utils/validators.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomText.dart';
import 'package:moeb_26/core/widgets/CustomTextGary.dart';
import 'package:moeb_26/core/widgets/CustomTextField.dart';
import 'package:moeb_26/core/widgets/Custom_dropdown.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/signup_controller.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});
  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final RxString areaError = ''.obs;
  final RxString roleError = ''.obs;
  final RxString languageError = ''.obs;

  // Using the unified SignupController
  SignupController get controller => Get.find<SignupController>();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: "Account Create"),
        body: Obx(
          () => Form(
            key: _formKey,
            autovalidateMode: controller.showErrors.value
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      "Tell us about yourself to get started",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD5C4AB),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ========== Full Name ==========
                  _buildInputField(
                    label: "Full Name",
                    isRequired: true,
                    child: Customtextfield(
                      controller: controller.nameController,
                      hintText: "John Smith",
                      obscureText: false,
                      textInputType: TextInputType.name,
                      validator: (value) => Validators.name(value),
                    ),
                  ),

                  // ========== Phone Number ==========
                  _buildInputField(
                    label: "Phone Number",
                    isRequired: true,
                    child: Customtextfield(
                      controller: controller.phoneController,
                      hintText: "Enter your phone number",
                      obscureText: false,
                      textInputType: TextInputType.phone,
                      validator: (value) => Validators.phone(value),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9+()\s-]'),
                        ),
                      ],
                    ),
                  ),

                  // ========== Email Address ==========
                  _buildInputField(
                    label: "Email Address",
                    isRequired: true,
                    child: Customtextfield(
                      controller: controller.emailController,
                      hintText: "Enter your email address",
                      obscureText: false,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) => Validators.email(value),
                    ),
                  ),

                  // ========== Service Area ==========
                  _buildInputField(
                    label: "Service Area",
                    isRequired: true,
                    child: Obx(
                      () => _buildDropdownField(
                        error: areaError.value,
                        child: CustomDropdown(
                          hintText: 'Select service area',
                          isLoading: controller.isCitiesLoading,
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
                  ),

                  // ========== Company Name ==========
                  _buildInputField(
                    label: "Company Name",
                    isRequired: true,
                    child: Customtextfield(
                      controller: controller.companyNameController,
                      hintText: "Example Limo Company LLC",
                      obscureText: false,
                      textInputType: TextInputType.name,
                      validator: (value) => Validators.required(
                        value,
                        message: "Enter your company name",
                      ),
                    ),
                  ),

                  // ========== Company Role ==========
                  _buildInputField(
                    label: "Company Role",
                    isRequired: true,
                    child: Obx(
                      () => _buildDropdownField(
                        error: roleError.value,
                        child: CustomDropdown(
                          hintText: 'Select company role',
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
                  ),

                  // ========== Languages Speaking ==========
                  _buildInputField(
                    label: "Languages Speaking",
                    isRequired: true,
                    child: _buildLanguageMultiSelect(context),
                  ),

                  // ========== Password ==========
                  _buildInputField(
                    label: "Create Password",
                    isRequired: true,
                    child: Obx(
                      () => Customtextfield(
                        controller: controller.passwordController,
                        hintText: "Enter password",
                        obscureText: !controller.showPassword.value,
                        textInputType: TextInputType.visiblePassword,
                        validator: (value) => Validators.password(
                          value,
                          minLength: 8,
                          requireDigit: true,
                          requireUppercase: true,
                          requireSpecialChar: true,
                        ),
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
                  ),

                  // ========== Confirm Password ==========
                  _buildInputField(
                    label: "Confirm Password",
                    isRequired: true,
                    child: Obx(
                      () => Customtextfield(
                        controller: controller.confirmPasswordController,
                        hintText: "Re-enter password",
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
                  ),
                  SizedBox(height: 32.h),

                  // ========== Submit Button ==========
                  CustomButton(text: "Continue", onPressed: _handleSubmit),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildInputField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: label,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
            if (isRequired)
              Text(
                " *",
                style: TextStyle(color: AppColors.orange100, fontSize: 14.sp),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        child,
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDropdownField({required Widget child, String? error}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget _buildLanguageMultiSelect(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedLanguages;
      final displayText = selected.isEmpty
          ? "Select languages"
          : selected.join(", ");

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _showLanguageSelectionSheet(context),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF141416),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF2C2C2C)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: selected.isEmpty ? AppColors.gray100 : Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFFD5C4AB),
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),
          if (languageError.value.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 6.h),
              child: Text(
                languageError.value,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    });
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141416),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Languages Spoken",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                "Select all languages you speak fluently.",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.gray100,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(
                  () {
                    final selectedLangs = controller.selectedLanguages.toList();
                    return ListView.separated(
                      itemCount: controller.availableLanguages.length,
                      separatorBuilder: (_, __) => Divider(
                        color: const Color(0xFF2C2C2C),
                        height: 1.h,
                      ),
                      itemBuilder: (context, index) {
                        final lang = controller.availableLanguages[index];
                        final isSelected = selectedLangs.contains(lang);
                        final isEnglish = lang == 'English';

                      return InkWell(
                        onTap: () {
                          if (isEnglish) return;
                          if (isSelected) {
                            controller.selectedLanguages.remove(lang);
                          } else {
                            controller.selectedLanguages.add(lang);
                          }
                          if (controller.selectedLanguages.isNotEmpty) {
                            languageError.value = '';
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Row(
                            children: [
                              Text(
                                lang,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              if (isEnglish) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  "(Default)",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.gray100,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Icon(
                                isSelected
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : const Color(0xFF444444),
                                size: 22.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),),
              SizedBox(height: 16.h),
              CustomButton(
                text: "Done",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Logic ---

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    controller.showErrors.value = true;

    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    bool isCustomValid = true;
    if (controller.selectedArea.value.isEmpty) {
      areaError.value = 'Select service area';
      isCustomValid = false;
    } else {
      areaError.value = '';
    }

    if (controller.selectedRole.value.isEmpty) {
      roleError.value = 'Select company role';
      isCustomValid = false;
    } else {
      roleError.value = '';
    }

    if (controller.selectedLanguages.isEmpty) {
      languageError.value = 'Select at least one language';
      isCustomValid = false;
    } else {
      languageError.value = '';
    }

    if (isFormValid && isCustomValid) {
      Get.toNamed(Routes.privacyPolicySignUpView);
    }
  }
}
