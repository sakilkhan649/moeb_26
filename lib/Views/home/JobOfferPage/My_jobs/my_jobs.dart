import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/app_icons.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
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
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.setJobAcceptanceView(false);
                      Get.toNamed(Routes.homeScreens);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(text: "My Jobs", fontSize: 20.sp),
                  ),
                ],
              ),
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

                if (controller.isJobAcceptanceView.value) {
                  return _buildJobAcceptanceDetailCard();
                }

                return _buildDefaultJobCard();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultJobCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
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
                  ],
                ),
                SizedBox(height: 4.h),

                /// PU / DO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 14.sp),
                        children: [
                          const TextSpan(
                            text: "PU: ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const TextSpan(
                            text: "Dhaka Airport",
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
                SizedBox(height: 6.h),

                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 13.sp),
                        children: [
                          const TextSpan(
                            text: "DO: ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const TextSpan(
                            text: "Barisal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                ///DATE AND TIME
                Row(
                  children: [
                    SvgPicture.asset(AppIcons.sadax_icon),
                    SizedBox(width: 5.w),
                    Text(
                      "SADAX",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                ///Fligt Number
                const CustomTextgray(
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

                ///Payment Method
                const CustomTextgray(
                  text: "Payment Method",
                  color: Color(0xFF737373),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomTextFieldGold(
                  controller: paymentMethodController,
                  hintText: "Collect",
                  obscureText: false,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),

                ///Special Instructions
                const CustomTextgray(
                  text: "Special Instructions",
                  color: Color(0xFF737373),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomTextFieldGold(
                  controller: specialInstructionsController,
                  hintText: "Airport Expert, Vip Client",
                  obscureText: false,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          Positioned(
            top: -0.w,
            right: -5.w,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
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
          ),
        ],
      ),
    );
  }

  Widget _buildJobAcceptanceDetailCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
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
                      ],
                    ),
                    SizedBox(height: 4.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(fontSize: 14.sp),
                            children: [
                              const TextSpan(
                                text: "PU: ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const TextSpan(
                                text: "Dhaka Airport",
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
                    SizedBox(height: 6.h),

                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(fontSize: 13.sp),
                            children: [
                              const TextSpan(
                                text: "DO: ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const TextSpan(
                                text: "Barisal",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    ///DATE AND TIME
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.sadax_icon),
                        SizedBox(width: 5.w),
                        Text(
                          "SADAX",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    ///Fligt Number
                    const CustomTextgray(
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

                    ///Payment Method
                    const CustomTextgray(
                      text: "Payment Method",
                      color: Color(0xFF737373),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFieldGold(
                      controller: paymentMethodController,
                      hintText: "Collect",
                      obscureText: false,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: 10.h),

                    ///Special Instructions
                    const CustomTextgray(
                      text: "Special Instructions",
                      color: Color(0xFF737373),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFieldGold(
                      controller: specialInstructionsController,
                      hintText: "Airport Expert, Vip Client",
                      obscureText: false,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: 10.h),

                    ///Amount
                    const CustomTextgray(
                      text: "Amount",
                      color: Color(0xFF737373),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFieldGold(
                      controller: specialInstructionsController,
                      hintText: "\$",
                      obscureText: false,
                      textInputType: TextInputType.text,
                    ),
                  ],
                ),
              ),

              /// Driver Section
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF191111),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Color(0xFF2A2A2A)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(
                            AppImages.sadat_image,
                          ), // Placeholder
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Sadat",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.directions_car,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "BMW 7 Series, Black",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_border_outlined,
                                    color: const Color(0xFFD08700),
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "4.9/5",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    /// Chat Button
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.chatPage);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.black.withOpacity(0.6),
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Chat with Driver",
                              style: GoogleFonts.inter(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    /// Reject/Approve Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 15.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Reject",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.approvePage);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 15.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange100,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Approve",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
          Positioned(
            top: -0.w,
            right: -5.w,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
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
          ),
        ],
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
