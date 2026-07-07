import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/preferred_drivers_controller.dart';

class PreferredDriverProfileView extends StatelessWidget {
  const PreferredDriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferredDriversController controller = Get.find<PreferredDriversController>();
    final driver = controller.selectedDriver.value;

    if (driver == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No driver selected.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Favorite Drivers List',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.5.h),
          child: Divider(color: const Color(0xFF1E1E1E), height: 1.5.h, thickness: 1.5.h),
        ),
      ),
      body: Column(
        children: [
          
          // Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Driver Avatar with Rating Badge
                  Stack(
                    children: [
                      Container(
                        width: 130.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD08700),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD08700).withValues(alpha: 0.15),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(65.w),
                          child: Image.network(
                            driver.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD08700),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 13.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                driver.rating.toString(),
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Driver Name
                  Text(
                    driver.name,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFEDB9B), // Soft peach-yellow
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // "Remove from Favorites" Button
                  OutlinedButton(
                    onPressed: () => controller.removeFromFavorites(driver),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFEDB9B), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.heart_broken_outlined,
                          color: const Color(0xFFFEDB9B),
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Remove from Favorites',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFEDB9B),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Total Rides
                  Text(
                    '${driver.totalRides} Total Rides',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Driver Information Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Driver Information',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD5C4AB),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Info Card Container
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF2C2C2C),
                        width: 0.98,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.calendar_today_outlined,
                          title: 'Joined',
                          value: driver.joinedDate,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.directions_car_outlined,
                          title: 'Vehicle',
                          value: driver.vehicleName,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.translate_outlined,
                          title: 'Languages',
                          value: driver.languages,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Recent Ratings Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Ratings & Feedback',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD5C4AB),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'View All',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD08700),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Feedback Card Container
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF2C2C2C),
                        width: 0.98,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: const Color(0xFFD08700),
                                  size: 16.sp,
                                ),
                              ),
                            ),
                            Text(
                              driver.reviewDate,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD5C4AB),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '"${driver.reviewText}"',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2C2C2C),
                                  width: 0.98,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundImage: NetworkImage(driver.reviewerImageUrl),
                                backgroundColor: const Color(0xFF27272A),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              driver.reviewerName,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD5C4AB),
            size: 20.sp,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
