import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/services/auth_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _obscureText = true.obs;

  DeleteAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final AuthService authService = Get.find<AuthService>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.w),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delete Account",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  "Warning: This action is permanent and your account cannot be recovered. All your data will be deleted.",
                  style: GoogleFonts.inter(
                    color: Colors.redAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enter Password to Confirm",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText.value,
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.6)),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _obscureText.value = !_obscureText.value;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.orange100),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Obx(() {
                        final isUpdating = profileController.isUpdating.value;
                        return ElevatedButton(
                          onPressed: isUpdating
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await profileController
                                        .deleteAccount(_passwordController.text);
                                    if (success) {
                                      Get.back(); // close bottom sheet
                                      await authService.clearLocalAuth();
                                      Helpers.showCustomSnackBar(
                                        "Account deleted successfully.",
                                        isError: false,
                                      );
                                      Get.offAllNamed(Routes.signinView);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            disabledBackgroundColor: Colors.red.withValues(alpha: 0.5),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isUpdating
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Delete",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
