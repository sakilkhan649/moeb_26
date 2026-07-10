import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/core/widgets/Custom_AppBar.dart';
import '../controllers/preferred_drivers_controller.dart';

class PreferredDriversView extends StatelessWidget {
  const PreferredDriversView({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferredDriversController controller = Get.put(
      PreferredDriversController(),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Favorite Driver',
        subtitle: 'YOUR FAVORITE LIST OF DRIVERS',
        notificationCount: 3,
      ),
      body: Column(
        children: [
          // Driver list content
          Expanded(
            child: Obx(() {
              if (controller.driversList.isEmpty) {
                return Center(
                  child: Text(
                    'No favorite drivers added yet.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: controller.driversList.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final driver = controller.driversList[index];
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF2C2C2C),
                        width: 0.98,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left: Avatar with golden-yellow border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD08700),
                              width: 1.5.w,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 28.r,
                            backgroundImage: NetworkImage(driver.imageUrl),
                            backgroundColor: const Color(0xFF27272A),
                          ),
                        ),
                        SizedBox(width: 16.w),

                        // Middle: Name and Rating Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                driver.name,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: const Color(0xFFD08700),
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    driver.rating.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    driver.ratingCount,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFD5C4AB),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right: View Profile Button
                        ElevatedButton(
                          onPressed: () => controller.viewProfile(driver),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD08700),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'View Profile',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}
