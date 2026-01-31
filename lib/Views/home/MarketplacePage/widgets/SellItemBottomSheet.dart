import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Views/home/MarketplacePage/Controller/Marketplace_controller.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import '../../../../Utils/app_colors.dart';

class SellItemBottomSheet extends StatelessWidget {
  SellItemBottomSheet({super.key});

  final MarketplaceController controller = Get.find<MarketplaceController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0B), // Black background as per image
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2632), // Dark blue header
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sell Item",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.5),
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  20.h,
                  20.w,
                  MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Item Title *"),
                    _buildTextField(
                      controller: controller.titleController,
                      hint: "e.g., Professional Car Phone Mount",
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel("Price *"),
                    _buildTextField(
                      controller: controller.priceController,
                      hint: "\$50",
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel("Condition (Optional)"),
                    Obx(
                      () => Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: controller.conditions.map((condition) {
                          bool isSelected =
                              controller.selectedCondition.value == condition;
                          return GestureDetector(
                            onTap: () => controller.updateCondition(condition),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1E2632)
                                    : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF323B49)
                                      : const Color(0xFF242424),
                                ),
                              ),
                              child: Text(
                                condition,
                                style: GoogleFonts.inter(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  fontSize: 14.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel("Location *"),
                    _buildTextField(
                      controller: controller.locationController,
                      hint: "Manhattan, NY",
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel("Description (Optional)"),
                    _buildTextField(
                      controller: controller.descriptionController,
                      hint: "Describe the item, its features, and condition...",
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel("Photos (Optional)"),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFF1A1A1A)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            color: Colors.grey,
                            size: 32.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Upload or take Photos",
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),

                    CustomButton(
                      text: "List Item",
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: () => controller.listItem(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.black,
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
      ),
    );
  }
}
