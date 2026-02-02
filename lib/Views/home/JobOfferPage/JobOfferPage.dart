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

class Jobofferpage extends StatefulWidget {
  const Jobofferpage({super.key});

  @override
  State<Jobofferpage> createState() => _JobofferpageState();
}

class _JobofferpageState extends State<Jobofferpage> {
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController specialInstructionsController =
      TextEditingController();

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
        onAccountTap: () {
          Get.toNamed(Routes.profileScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.w),
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
              SizedBox(height: 15.h),
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
              SizedBox(height: 60.h),
            ],
          ),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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
/// ================= CUSTOM JOB CARD WIDGET =================
class CustomJobCard extends StatefulWidget {
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
  State<CustomJobCard> createState() => _CustomJobCardState();
}

class _CustomJobCardState extends State<CustomJobCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
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
                    widget.dateTime,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              VehicleTypeBadge(
                vehicleType: widget.vehicleType,
                backgroundColor: widget.vehicleTypeColor,
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
                  text: widget.pickupLocation,
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
                  text: widget.dropoffLocation,
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
                widget.driverName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
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
                widget.companyName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
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
            controller: widget.flightNumberController,
            hintText: widget.flightNumberHint,
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
            controller: widget.paymentMethodController,
            hintText: widget.paymentMethodHint,
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
            controller: widget.specialInstructionsController,
            hintText: widget.specialInstructionsHint,
            obscureText: false,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 20.h),

          /// BOTTOM ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Draggable<String>(
                data: 'confirm',
                axis: Axis.horizontal,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.orange100,
                      shape: BoxShape.circle,
                      // No shadow
                    ),
                    child: SvgPicture.asset(
                      AppIcons.arre_right_icon,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
                childWhenDragging: SvgPicture.asset(
                  AppIcons.arre_right_icon,
                  color: Colors.transparent,
                ),
                child: GestureDetector(
                  onTap: widget.onArrowTap,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.orange100,
                      shape: BoxShape.circle,
                      // No shadow
                    ),
                    child: SvgPicture.asset(AppIcons.arre_right_icon),
                  ),
                ),
              ),
              // Directional Arrows
              Row(
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                  Transform.translate(
                    offset: Offset(-8.w, 0), // Slight overlap for style
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFF6B6B6B),
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
              DragTarget<String>(
                onAcceptWithDetails: (details) {
                  if (details.data == 'confirm') {
                    widget.onArrowTap?.call();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  bool isOver = candidateData.isNotEmpty;
                  return GestureDetector(
                    onTap: widget.onPriceTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 70.w,
                      ),
                      decoration: BoxDecoration(
                        color: isOver ? Color(0xFFE1C16E) : AppColors.orange100,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: CustomText(text: widget.price, fontSize: 18.sp),
                    ),
                  );
                },
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
