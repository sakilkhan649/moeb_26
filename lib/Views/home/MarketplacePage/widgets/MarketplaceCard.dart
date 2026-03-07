import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import '../Model/Marketplace_model.dart';
import 'ContactSellerPopup.dart';
import 'ImagePreviewPopup.dart';

class MarketplaceCard extends StatelessWidget {
  final MarketplaceItem item;

  const MarketplaceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h, // Updated height
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image with rounded top corners
          GestureDetector(
            onTap: () {
              Get.dialog(
                ImagePreviewPopup(imagePath: item.imagePath, title: item.name),
              );
            },
            child: ClipRRect(child: _buildImage()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                SizedBox(
                  height: 38.h,
                  child: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                // Price and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.price}",
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF1A107),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.star,
                    //       color: const Color(0xFFF1A107),
                    //       size: 14.sp,
                    //     ),
                    //     SizedBox(width: 4.w),
                    //     Text(
                    //       item.rating.toString(),
                    //       style: GoogleFonts.inter(
                    //         color: const Color(0xff949494),
                    //         fontSize: 12.sp,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h), // Reduced gap instead of Spacer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.condition,
                  style: GoogleFonts.inter(
                    color: const Color(0xff949494),
                    fontSize: 12.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(ContactSellerPopup(item: item));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1A107),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppIcons.contact_icon,
                          height: 14.sp,
                          width: 14.sp,
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
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (item.imagePath.isEmpty) {
      return _buildNoImagePlaceholder();
    }

    if (item.imagePath.startsWith('http')) {
      return Image.network(
        item.imagePath,
        height: 130.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildNoImagePlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 130.h,
            width: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF1A107),
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        item.imagePath,
        height: 130.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildNoImagePlaceholder(),
      );
    }
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      height: 130.h,
      width: double.infinity,
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 30.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            "No Image",
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
