import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/Custom_Job_Button.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Controller/Marketplace_controller.dart';
import 'widgets/SellItemBottomSheet.dart';
import 'widgets/MarketplaceCard.dart';

class Marketplacepage extends StatelessWidget {
  Marketplacepage({super.key});

  final MarketplaceController controller = Get.put(MarketplaceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Marketplace',
        subtitle: 'WHERE THE NETWORK MEETS OPPORTUNITY',
        notificationCount: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 5.h),

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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF1A107)),
                  );
                }
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
                      padding: EdgeInsets.only(bottom: 10.h, left: 0, right: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MarketplaceCard(
                              item: controller.filteredItems[leftIndex],
                            ),
                          ),
                          SizedBox(width: 10.w),
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
