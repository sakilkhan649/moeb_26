import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Data/models/job_model.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/app_icons.dart';
import '../../../../Utils/app_images.dart';
import '../../../../widgets/Custom_AppBar.dart';
import 'Controller/My_job_controller.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final BookingController controller = Get.put(BookingController());

  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController specialInstructionsController =
      TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Divider(color: Colors.white, thickness: 1.h),
              SizedBox(height: 8.h),

              /// ================= JOB CARD =================
              Obx(() {
                if (controller.isLoadingList.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: const CircularProgressIndicator(
                        color: AppColors.orange100,
                      ),
                    ),
                  );
                }

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

                if (controller.jobsList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Text(
                        "No jobs found",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.jobsList.length,
                  itemBuilder: (context, index) {
                    final job = controller.jobsList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildJobCard(job),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    // Safely extract properties
    final dateRaw = job.date.toString();
    final timeRaw = job.time;

    // Parse date if possible
    String displayDate = "$dateRaw · $timeRaw";
    try {
      if (dateRaw.isNotEmpty) {
        DateTime parsed = DateTime.parse(dateRaw);
        // Basic format to keep it simple, e.g., "Tue, Jan 20"
        displayDate =
            "${_getWeekday(parsed.weekday)}, ${_getMonth(parsed.month)} ${parsed.day} · $timeRaw";
      }
    } catch (_) {}

    final puLocation = job.pickupLocation;
    final doLocation = job.dropoffLocation ?? 'N/A';
    final vehicle = job.vehicleType;
    final flight = job.flightNumber ?? 'N/A';
    final paymentType = job.paymentType;
    final instruction = job.instruction ?? 'N/A';
    final jobType = job.jobType == 'ONE_WAY' ? 'SADAX' : 'HOURLY';

    // Local controllers for this specific card
    final TextEditingController cardFlightController = TextEditingController(
      text: flight,
    );
    final TextEditingController cardPaymentController = TextEditingController(
      text: paymentType,
    );
    final TextEditingController cardInstructionController =
        TextEditingController(text: instruction);
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
            padding: EdgeInsets.fromLTRB(10.w, 12.w, 10.w, 10.w),
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
                          displayDate,
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                /// PU / DO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(fontSize: 14.sp),
                          children: [
                            const TextSpan(
                              text: "PU: ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: puLocation,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
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
                        vehicle.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(fontSize: 13.sp),
                          children: [
                            const TextSpan(
                              text: "DO: ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: doLocation,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
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
                      jobType,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                ///Fligt Number
                if (flight != 'N/A' && flight != '') ...[
                  const CustomTextgray(
                    text: "Flight Number",
                    color: Color(0xFF737373),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextFieldGold(
                    readOnly: true,
                    controller: cardFlightController,
                    hintText: "Flight AA 1234",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 10.h),
                ],

                ///Payment Method
                const CustomTextgray(
                  text: "Payment Method",
                  color: Color(0xFF737373),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomTextFieldGold(
                  readOnly: true,
                  controller: cardPaymentController,
                  hintText: "Collect",
                  obscureText: false,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10.h),

                ///Special Instructions
                if (instruction != 'N/A' && instruction != '') ...[
                  const CustomTextgray(
                    text: "Special Instructions",
                    color: Color(0xFF737373),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextFieldGold(
                    readOnly: true,
                    controller: cardInstructionController,
                    hintText: "Airport Expert, Vip Client",
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: -4.w,
            right: -13.w,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Color(0xFF364153), width: 1),
              ),
              icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
              color: Color(0xFF1E1E1E),
              padding: EdgeInsets.zero,
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
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.edit_icon,
                        height: 22.h,
                        width: 22.w,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Edit",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.delete_icon,
                        height: 22.h,
                        width: 22.w,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Delete",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
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
                padding: EdgeInsets.fromLTRB(10.w, 12.w, 10.w, 10.w),
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
                    SizedBox(height: 8.h),

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
                      readOnly: true,
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
                      readOnly: true,
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
                      readOnly: true,
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
                margin: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 10.w),
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
            ],
          ),
          Positioned(
            top: -4.w,
            right: -13.w,
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

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
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
    this.readOnly = false,
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
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
