import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../Core/routs.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_icons.dart';
import '../../../widgets/CustomText.dart';
import '../../../widgets/CustomTextGary.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Job_Bottom_sheet/Job_Bottom_sheet_Tabbar.dart';
import 'My_jobs/my_jobs.dart';
import 'Notifications/Notifications_popup.dart';

class Jobofferpage extends StatefulWidget {
  const Jobofferpage({super.key});

  @override
  State<Jobofferpage> createState() => _JobofferpageState();
}

class _JobofferpageState extends State<Jobofferpage> {

  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController specialInstructionsController = TextEditingController();

  @override
  void dispose() {
    flightNumberController.dispose();
    paymentMethodController.dispose();
    specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,),
        child: Column(
          children: [
            SizedBox(height: 20,),
            CustomJobButton(
              text: "New Job",
              onPressed: () {
                Get.bottomSheet(
                  PostJobBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            SizedBox(height: 20.h),
            CustomJobCard(
              dateTime: "Tue, Jan 20 · 08:30 AM",
              vehicleType: "SEDAN",
              pickupLocation: "Dhaka Airport",
              dropoffLocation: "Barisal",
              driverName: "Khaled",
              companyName: "Khaled Transportation",
              flightNumberHint: "Flight AA 1234",
              paymentMethodHint: "Collect",
              specialInstructionsHint: "Airport Expert, Vip Client",
              price: "\$125",
              flightNumberController: flightNumberController,
              paymentMethodController: paymentMethodController,
              specialInstructionsController: specialInstructionsController,
              vehicleTypeColor: VehicleTypeColors.sedan,
              onArrowTap: () {
                // Handle arrow tap
                Get.toNamed(Routes.requestSubmitted);

                print("Arrow tapped");
              },
              onPriceTap: () {
                // Handle price tap
                print("Price tapped");
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= VEHICLE TYPE COLORS =================
class VehicleTypeColors {
  static const Color sedan = Colors.red;
  static const Color suv = Colors.blue;
  static const Color van = Colors.green;
  static const Color luxury = Color(0xFFD4AF37); // Gold
  static const Color truck = Colors.orange;
  static const Color mini = Colors.purple;
}

/// ================= CUSTOM VEHICLE TYPE BADGE =================
class VehicleTypeBadge extends StatelessWidget {
  final String vehicleType;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const VehicleTypeBadge({
    Key? key,
    required this.vehicleType,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        vehicleType,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: fontSize ?? 10.sp,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      ),
    );
  }
}

/// ================= CUSTOM JOB CARD WIDGET =================
class CustomJobCard extends StatelessWidget {
  final String dateTime;
  final String vehicleType;
  final String pickupLocation;
  final String dropoffLocation;
  final String driverName;
  final String companyName;
  final String flightNumberHint;
  final String paymentMethodHint;
  final String specialInstructionsHint;
  final String price;
  final TextEditingController flightNumberController;
  final TextEditingController paymentMethodController;
  final TextEditingController specialInstructionsController;
  final VoidCallback? onArrowTap;
  final VoidCallback? onPriceTap;
  final Color vehicleTypeColor;

  const CustomJobCard({
    Key? key,
    required this.dateTime,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.driverName,
    required this.companyName,
    required this.flightNumberHint,
    required this.paymentMethodHint,
    required this.specialInstructionsHint,
    required this.price,
    required this.flightNumberController,
    required this.paymentMethodController,
    required this.specialInstructionsController,
    this.onArrowTap,
    this.onPriceTap,
    this.vehicleTypeColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER - Date & Vehicle Type
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
                    dateTime,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              VehicleTypeBadge(
                vehicleType: vehicleType,
                backgroundColor: vehicleTypeColor,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// PICKUP LOCATION
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14.sp),
              children: [
                TextSpan(
                  text: "PU: ",
                  style: const TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: pickupLocation,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),

          /// DROPOFF LOCATION
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14.sp),
              children: [
                TextSpan(
                  text: "DO: ",
                  style: const TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: dropoffLocation,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          /// DRIVER NAME
          Row(
            children: [
              SvgPicture.asset(AppIcons.person_icon),
              SizedBox(width: 5.w),
              Text(
                driverName,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// COMPANY NAME
          Row(
            children: [
              SvgPicture.asset(AppIcons.sadax_icon),
              SizedBox(width: 5.w),
              Text(
                companyName,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          /// FLIGHT NUMBER
          CustomTextgray(
            text: "Flight Number",
            color: const Color(0xFF737373),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          CustomTextFieldGold(
            controller: flightNumberController,
            hintText: flightNumberHint,
            obscureText: false,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 10.h),

          /// PAYMENT METHOD
          CustomTextgray(
            text: "Payment Method",
            color: const Color(0xFF737373),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          CustomTextFieldGold(
            controller: paymentMethodController,
            hintText: paymentMethodHint,
            obscureText: false,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 10.h),

          /// SPECIAL INSTRUCTIONS
          CustomTextgray(
            text: "Special Instructions",
            color: const Color(0xFF737373),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          CustomTextFieldGold(
            controller: specialInstructionsController,
            hintText: specialInstructionsHint,
            obscureText: false,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 30.h),

          /// BOTTOM ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onArrowTap,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.orange100,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(AppIcons.arre_right_icon),
                ),
              ),
              GestureDetector(
                onTap: onPriceTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 100.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange100,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: CustomText(
                    text: price,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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