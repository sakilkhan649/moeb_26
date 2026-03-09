import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/Views/home/JobOfferPage/My_jobs/Controller/My_job_controller.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
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

  final BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreJobOffers();
      }
    });
  }

  @override
  void dispose() {
    flightNumberController.dispose();
    paymentMethodController.dispose();
    specialInstructionsController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchJobOffers(isRefresh: true);
        },
        color: AppColors.orange100,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
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
                      Obx(() {
                        if (controller.isLoadingList.value &&
                            controller.jobOffersList.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.h),
                              child: const CircularProgressIndicator(
                                color: AppColors.orange100,
                              ),
                            ),
                          );
                        }

                        if (controller.jobOffersList.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.h),
                              child: Text(
                                "No jobs found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.jobOffersList.length,
                              itemBuilder: (context, index) {
                          final job = controller.jobOffersList[index];

                          // Format Date and Time
                          String formattedDateTime = "";
                          if (job.date != null) {
                            String dateStr = DateFormat('EEE, MMM dd').format(job.date!);
                            
                            String timeStr = job.time;
                            try {
                              if (timeStr.contains(':')) {
                                final parts = timeStr.split(':');
                                int hour = int.parse(parts[0]);
                                int minute = int.parse(parts[1].split(' ')[0]);
                                
                                final period = hour >= 12 ? "PM" : "AM";
                                final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                                String formattedTime = "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
                                formattedDateTime = "$dateStr · $formattedTime";
                              } else {
                                formattedDateTime = "$dateStr · $timeStr";
                              }
                            } catch (_) {
                              formattedDateTime = "$dateStr · $timeStr";
                            }
                          } else {
                            formattedDateTime = job.time;
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: CustomJobCard(
                              dateTime: formattedDateTime,
                              vehicleType: job.vehicleType,
                                    pickupLocation: job.pickupLocation,
                                    dropoffLocation: job.dropoffLocation ?? '',
                                    driverName: job.createdBy?.name ?? 'Unknown',
                                    companyName: job.createdBy?.name ?? 'Unknown',
                                    flightNumberHint: job.flightNumber ?? '',
                                    paymentMethodHint: job.paymentType,
                                    specialInstructionsHint: job.instruction ?? '',
                                    price: job.paymentAmount.toString(),
                                    flightNumberController: flightNumberController,
                                    paymentMethodController: paymentMethodController,
                                    specialInstructionsController:
                                        specialInstructionsController,
                                    vehicleTypeColor: VehicleTypeColors.sedan,
                                    onArrowTap: () {
                                      // Handle arrow tap
                                      controller.applyToJob(jobId: job.id);

                                      print("Arrow tapped");
                                    },
                                    onPriceTap: () {
                                      // Handle price tap
                                      print("Price tapped");
                                    },
                                  ),
                                );
                              },
                            ),
                            if (controller.isLoadMore.value)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.orange100,
                                  ),
                                ),
                              ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
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
            readOnly: true,
            controller: widget.flightNumberController,
            hintText: widget.flightNumberHint,
            obscureText: false,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 10.h),

          /// PAYMENT METHOD
          CustomTextgray(
            text: "Payment",
            color: const Color(0xFF737373),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          CustomTextFieldGold(
            readOnly: true,
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
            readOnly: true,
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
  final bool readOnly;

  const CustomTextFieldGold({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
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
