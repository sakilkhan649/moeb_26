import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ServiceAreaController.dart';

class ServiceArea extends StatelessWidget {
  const ServiceArea({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    Get.put(ServiceAreaController());

    return Scaffold(
      backgroundColor: const Color(
        0xFF424242,
      ), // Dark grey background similar to screenshot
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
                      color:
                          Colors.grey, // Light grey for header "Service Area"
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(4),
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
                child: GetBuilder<ServiceAreaController>(
                  builder: (ctrl) {
                    return ListView.separated(
                      itemCount: ctrl.serviceAreas.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final item = ctrl.serviceAreas[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The Header (e.g., Florida, Texas)
                            GestureDetector(
                              onTap: () {
                                // Allow toggling even if locked, as per screenshot showing locked items expanded
                                ctrl.toggleExpansion(index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 15.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .black, // darker background for the item
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Color(0xFF364153)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.inter(
                                            color: Colors.grey, // Text color
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (item.isLocked) ...[
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
                            // The Body (Cities) - Only shown if expanded
                            if (item.isExpanded)
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                padding: EdgeInsets.all(15.w),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.r),
                                  // No border for the body as per screenshot
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: item.cities.map((city) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6.h,
                                      ),
                                      child: Text(
                                        city,
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
