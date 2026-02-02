import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import '../../../Core/routs.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Controller/Deals_controller.dart';
import 'Model/Deals_model.dart';
import 'widgets/QrPopup.dart';

class Dealspage extends StatelessWidget {
  Dealspage({super.key});

  // Initialize the controller
  final DealsController controller = Get.put(DealsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Deals',
        subtitle: 'ELITE NETWORK EXCLUSIVE SAVINGS',
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: Obx(() {
        // Handle empty state
        if (controller.dealsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty State Box Icon (Placeholder wrapper)
                Container(
                  padding: EdgeInsets.all(40.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff1C1C1C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey[700],
                    size: 60.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "No deals at this time",
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // Handle list of deals
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(20.w, 0.w, 20.w, 10.w),
          itemCount: controller.dealsList.length,
          itemBuilder: (context, index) {
            final deal = controller.dealsList[index];
            return DealsCard(deal: deal, controller: controller);
          },
        );
      }),
    );
  }
}

class DealsCard extends StatelessWidget {
  final DealsItem deal;
  final DealsController controller;

  const DealsCard({super.key, required this.deal, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1A), // Dark card background
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xff242424)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.service_icon, // Using the tag/service icon
                height: 18.sp,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xff1E1E1E),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xff242424)),
                ),
                child: Text(
                  deal.category,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Title
          Text(
            deal.title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          // Description
          Text(
            deal.description,
            style: GoogleFonts.inter(
              color: const Color(0xff949494),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 10.h),
          // Promo Code Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xff242424)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Promo Code",
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      deal.promoCode,
                      style: GoogleFonts.inter(
                        color: const Color(0xffF1A107), // Gold color
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                // Copy Button
                GestureDetector(
                  onTap: () => controller.copyToClipboard(deal.promoCode),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "Copy",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // Footer: Expiry and Use QR Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey[700],
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Expires ${deal.expiryDate}",
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              // Use QR Button
              GestureDetector(
                onTap: () {
                  Get.dialog(const QrPopup());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1A107),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Use QR",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SvgPicture.asset(
                        AppIcons.qr_icon,
                        height: 16.sp,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
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
