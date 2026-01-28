import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';

import '../../../../Core/routs.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
import '../Notifications/Notifications_popup.dart';
import 'Controller/My_job_controller.dart';

class MyJobsScreen extends StatelessWidget {
  MyJobsScreen({super.key});

  final BookingController controller = Get.put(BookingController());

  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController specialInstructionsController =
      TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
        onAccountTap: () {
          Get.toNamed(Routes.homeScreens);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 20.h),
              CustomText(text: "My Jobs", fontSize: 20.sp),
              SizedBox(height: 10.h),
              Divider(color: Colors.white, thickness: 1.h),
              SizedBox(height: 20.h),

              /// ================= JOB CARD =================
              Obx(() {
                if (controller.isDeleted.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Text(
                      "Item Deleted",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  );
                }

                return Container(
                  width: 0.9.sw,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Color(0xFF2A2A2A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                                size: 18.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Tue, Jan 20 · 08:30 AM",
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            color: Colors.white,
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed(Routes.editScreen);
                              } else {
                                _showDeleteDialog();
                              }
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      color: Colors.black,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Edit",
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outlined,
                                      color: Colors.black,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Delete",
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// PU / DO
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(fontSize: 14.sp),
                              children: [
                                TextSpan(
                                  text: "PU: ",
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: "Dhaka Airport",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(fontSize: 13.sp),
                              children: [
                                TextSpan(
                                  text: "DO: ",
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: "Barisal",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              "SEDAN",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      ///Fligt Number
                      CustomTextgray(
                        text: "Flight Number",
                        color: Color(0xFF737373),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFieldGold(
                        controller: flightNumberController,
                        hintText: "Flight AA 1234",
                        obscureText: false,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h),

                      ///Passenger Name
                      CustomTextgray(
                        text: "Payment Method",
                        color: Color(0xFF737373),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      // Example usage of CustomTextField
                      CustomTextFieldGold(
                        controller: paymentMethodController,
                        hintText: "Collect",
                        obscureText: false,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h),

                      ///Special Instructions
                      CustomTextgray(
                        text: "Special Instructions",
                        color: Color(0xFF737373),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      // Example usage of CustomTextField
                      CustomTextFieldGold(
                        controller: specialInstructionsController,
                        hintText: "Airport Expert, Vip Client",
                        obscureText: false,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h),

                      ///Payment
                      CustomTextgray(
                        text: "Payment",
                        color: Color(0xFF737373),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      // Example usage of CustomTextField
                      CustomTextFieldGold(
                        controller: paymentController,
                        hintText: "\$ 125",
                        obscureText: false,
                        textInputType: TextInputType.text,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= DELETE DIALOG =================
  void _showDeleteDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure to delete?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: Get.back,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black, fontSize: 13.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.deleteItem();
                        Get.snackbar(
                          "Deleted",
                          "Item deleted successfully",
                          colorText: Colors.white,
                          backgroundColor: Colors.black,
                        );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

/// ================= CUSTOM TEXT FIELD WIDGET =================
class CustomTextFieldGold extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final String? Function(String?)? validator;

  const CustomTextFieldGold({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFD08700)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
      ),
    );
  }
}
