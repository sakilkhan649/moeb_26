import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 18.sp,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    color: const Color(0xFF2C2C2E),
                    elevation: 8,
                    offset: Offset(-30, -90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
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
                        );

                        Get.bottomSheet(
                          SellItemBottomSheet(editItemId: item.id),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      } else if (value == 'delete') {
                        _showDeleteDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.blueAccent,
                                size: 16.sp,
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
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Delete",
                              style: GoogleFonts.inter(
                                color: Colors.redAccent,
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
          ),
        ],
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
