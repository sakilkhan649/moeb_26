
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Views/auth/Otp_verification/Controller/otp_verification_controller.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import 'package:pinput/pinput.dart';


class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.w,
      textStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.white100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      body: Form(
        key: controller.formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: "Verification"),
                  ),
                  SizedBox(height: 30.h),
                  CustomTextgray(
                    text: "Enter your 4 digits code that you received on your email.",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 26.h),

                  // ========== Pinput ==========
                  Align(
                    alignment: Alignment.center,
                    child: Pinput(
                      length: 4,
                      controller: controller.pinController,
                      separatorBuilder: (index) => SizedBox(width: 20.w),
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(
                            color: AppColors.white100,
                            width: 1,
                          ),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: AppColors.white100,
                          border: Border.all(color: Colors.transparent),
                        ),
                      ),
                      onCompleted: (pin) => controller.verifyOtp(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter OTP';
                        }
                        if (value.length < 4) {
                          return 'Enter 4 digit OTP';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Enter Only number';
                        }
                        return null;
                      },
                      forceErrorState: true,
                      errorTextStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // ========== Countdown Timer ==========
                  Obx(() => Center(
                    child: CustomTextgray(
                      text: controller.timerText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFC727),
                    ),
                  )),
                  SizedBox(height: 30.h),

                  // ========== Continue Button ==========
                  Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Continue",
                        onPressed: () => controller.verifyOtp(),
                      ),
                  ),
                  SizedBox(height: 30.h),

                  // ========== Resend Row ==========
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextgray(
                        text: "If you didn't receive a code!",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: AppColors.white100,
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: controller.canResend.value
                            ? () => controller.resendOtp()
                            : null,
                        child: CustomTextgray(
                          text: " Resend",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: controller.canResend.value
                              ? Color(0xFFFFC727)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}