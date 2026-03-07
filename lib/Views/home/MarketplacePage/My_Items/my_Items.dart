import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/Custom_AppBar.dart';
import 'Controller/my_items_controller.dart';
import 'widgets/my_items_card.dart';

class MyItems extends StatelessWidget {
  MyItems({super.key});

  final MyItemsController controller = Get.put(MyItemsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Items',
        subtitle: 'MANAGE YOUR LISTINGS',
        notificationCount: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF1A107)),
                  );
                }

                // For demonstration, using all items.
                // In a real app, we might filter by user ID.
                if (controller.myItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No products found",
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: (controller.myItems.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final int leftIndex = index * 2;
                    final int rightIndex = leftIndex + 1;
                    final bool hasRight =
                        rightIndex < controller.myItems.length;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MyItemsCard(
                              item: controller.myItems[leftIndex],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: hasRight
                                ? MyItemsCard(
                              item: controller.myItems[rightIndex],
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
