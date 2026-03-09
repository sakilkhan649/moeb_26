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
      appBar: CustomAppBar(
        title: 'My Items',
        subtitle: 'MANAGE YOUR LISTINGS',
        notificationCount: 3,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchMyItems(),
        color: const Color(0xFFF1A107),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.myItems.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF1A107),
                      ),
                    );
                  }

                  if (controller.myItems.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 200.h),
                        Center(
                          child: Text(
                            "No items found",
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
