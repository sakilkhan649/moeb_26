import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import '../Model/my_items_model.dart';
import '../Controller/my_items_controller.dart';
import '../../widgets/ImagePreviewPopup.dart';
import '../../widgets/SellItemBottomSheet.dart';
import '../../Controller/Marketplace_controller.dart';

class MyItemsCard extends StatelessWidget {
  final MyItemsModel item;

  const MyItemsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
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
                // Price and Condition
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
                    Text(
                      item.condition,
                      style: GoogleFonts.inter(
                        color: const Color(0xff949494),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          // Bottom Row: Status badge + Popup menu icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: item.status == 'Active'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    item.status,
                    style: GoogleFonts.inter(
                      color: item.status == 'Active'
                          ? Colors.green
                          : Colors.orange,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showOptionsDialog(context),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 60.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Edit Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Get.back();
                  final MarketplaceController mpc;
                  if (Get.isRegistered<MarketplaceController>()) {
                    mpc = Get.find<MarketplaceController>();
                  } else {
                    mpc = Get.put(MarketplaceController());
                  }
                  mpc.prefillForEdit(
                    item.name,
                    item.price.toString(),
                    item.location,
                    item.condition,
                    item.description,
                    item.imagePath,
                  );
                  Get.bottomSheet(
                    SellItemBottomSheet(editItemId: item.id),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30.w),
                        SvgPicture.asset(
                          AppIcons.edit_icon_myjob,
                          height: 20.sp,
                          width: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Edit",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Delete Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Get.back();
                  _showDeleteDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 30.w),
                    SvgPicture.asset(
                      AppIcons.deletemyjob_icon,
                      height: 20.sp,
                      width: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Delete",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Remove actions entirely — using content column instead
        actionsPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildImage() {
    if (item.imagePath.isEmpty) {
      return Container(
        height: 130.h,
        width: double.infinity,
        color: Colors.grey[900],
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 40.sp,
        ),
      );
    }

    return Image.network(
      item.imagePath,
      height: 130.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 130.h,
        width: double.infinity,
        color: Colors.grey[900],
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 40.sp,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          "Delete Item",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this item? This action cannot be undone.",
          style: GoogleFonts.inter(color: const Color(0xff949494)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              final MyItemsController controller =
                  Get.find<MyItemsController>();
              controller.deleteItem(item.id);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
