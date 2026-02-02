import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../Core/routs.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Controller/Marketplace_controller.dart';
import 'Model/Marketplace_model.dart';
import 'widgets/ContactSellerPopup.dart';
import 'widgets/SellItemBottomSheet.dart';

class Marketplacepage extends StatelessWidget {
  Marketplacepage({super.key});

  final MarketplaceController controller = Get.put(MarketplaceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Marketplace',
        subtitle: 'WHERE THE NETWORK MEETS OPPORTUNITY',
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // "List Item for Sale" Button
            CustomJobButton(
              text: "List Item for Sale",
              onPressed: () {
                Get.bottomSheet(
                  SellItemBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            SizedBox(height: 15.h),
            // Search Bar
            TextFormField(
              onChanged: (value) => controller.searchItems(value),
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search accessories...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: const Color(0xff1A1A1A),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xff242424)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xff242424)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xff242424)),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            // Marketplace Items - Refactored to Column with Rows
            Expanded(
              child: Obx(() {
                if (controller.filteredItems.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: Center(
                      child: Text(
                        "No items found",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (controller.filteredItems.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final int leftIndex = index * 2;
                    final int rightIndex = leftIndex + 1;
                    final bool hasRight =
                        rightIndex < controller.filteredItems.length;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 16.h,
                        left: 0,
                        right: 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MarketplaceCard(
                              item: controller.filteredItems[leftIndex],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: hasRight
                                ? MarketplaceCard(
                              item: controller.filteredItems[rightIndex],
                            )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketplaceCard extends StatelessWidget {
  final MarketplaceItem item;

  const MarketplaceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Matches specific dark background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image with rounded top corners
          ClipRRect(
            child: Image.asset(
              item.imagePath,
              height: 130.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp, // Larger as per image
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                // Price and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.price}",
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF1A107), // Gold price color
                        fontSize: 20.sp, // Very prominent as per image
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFF1A107),
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          item.rating.toString(),
                          style: GoogleFonts.inter(
                            color: const Color(0xff949494),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Condition and Contact Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.condition,
                      style: GoogleFonts.inter(
                        color: const Color(0xff949494),
                        fontSize: 13.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(ContactSellerPopup(item: item));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1A107),
                          borderRadius: BorderRadius.circular(
                            30.r,
                          ), // Highly rounded pill
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.contact_icon,
                              height: 18.sp,
                              width: 18.sp,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Contact",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
