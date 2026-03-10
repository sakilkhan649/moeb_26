import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Controller/serviceController.dart';

class ServiceArea extends StatefulWidget {
  ServiceArea({super.key});

  @override
  State<ServiceArea> createState() => _ServiceAreaState();
}

class _ServiceAreaState extends State<ServiceArea> {
  final ServiceAreaController controller = Get.put(ServiceAreaController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // No need to fetch here if controller already does it in onInit
    // but we can trigger it if needed to ensure fresh data

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreServiceAreas();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF424242),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Service Area",
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      controller.fetchServiceAreas(isRefresh: true),
                  color: const Color(0xFFF1A107),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.serviceAreas.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF1A107),
                        ),
                      );
                    }
                    if (controller.serviceAreas.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: 200.h),
                          Center(
                            child: Text(
                              "No service areas found",
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          controller.serviceAreas.length +
                          (controller.isMoreLoading.value ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        if (index == controller.serviceAreas.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFF1A107),
                              ),
                            ),
                          );
                        }
                        final item = controller.serviceAreas[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => controller.toggleExpansion(index),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 15.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: const Color(0xFF364153),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.areaName,
                                          style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (item.status != 'ACTIVE') ...[
                                          SizedBox(width: 10.w),
                                          Icon(
                                            Icons.lock_outline,
                                            color: Colors.grey,
                                            size: 18.sp,
                                          ),
                                        ],
                                      ],
                                    ),
                                    Icon(
                                      item.isExpanded
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (item.isExpanded)
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                padding: EdgeInsets.all(15.w),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6.h,
                                      ),
                                      child: Text(
                                        item.city,
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
