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
  final ItemData item;

  const MarketplaceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String imagePath = (item.photos != null && item.photos!.isNotEmpty)
        ? item.photos!.first
        : "";
    final String title = item.title ?? "No Title";

    return Container(
      height: 255.h, // Adjusted height for a more compact look
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image with rounded top corners
          GestureDetector(
            onTap: () {
              Get.dialog(ImagePreviewPopup(imagePath: imagePath, title: title));
            },
            child: ClipRRect(child: _buildImage(imagePath)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                SizedBox(
                  height: 38.h, // Fixed height for 2 lines consistency
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                // Price and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.price ?? 0}",
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF1A107),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(), // Removed Spacer to reduce gap
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.condition ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xff949494),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
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
          SizedBox(height: 8.h), // Small padding at the bottom
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.isEmpty) {
      return _buildNoImagePlaceholder();
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
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
        imagePath,
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
