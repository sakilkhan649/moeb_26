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
      appBar: CustomAppBar(title: 'Favorite Chauffeurs', notificationCount: 3),
      body: Column(
        children: [
          SizedBox(height: 15.h),
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
            child: TextFormField(
              onChanged: (value) => controller.searchQuery.value = value,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: 'Search by phone or email...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 8.w),
                  child: Icon(Icons.search, color: Colors.grey, size: 24.sp),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.h,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: const Color(0xFF242424),
                    width: 1.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: const Color(0xFFD08700),
                    width: 1.w,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: const Color(0xFF242424),
                    width: 1.w,
                  ),
                ),
              ),
            ),
          ),
          // Chauffeur list content
          Expanded(
            child: Obx(() {
              if (controller.filteredChauffeursList.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.isEmpty
                        ? 'No favorite chauffeurs added yet.'
                        : 'No matching chauffeurs found.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                itemCount: controller.filteredChauffeursList.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final chauffeur = controller.filteredChauffeursList[index];
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
                            backgroundImage: NetworkImage(chauffeur.imageUrl),
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
                                chauffeur.name,
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
                                    chauffeur.rating.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    chauffeur.ratingCount,
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
                          onPressed: () => controller.viewProfile(chauffeur),
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
