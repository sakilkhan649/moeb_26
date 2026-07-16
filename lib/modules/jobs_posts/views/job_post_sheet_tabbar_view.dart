import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'by_the_hour_view.dart';
import '../controllers/job_post_controller.dart';
import 'one_way_view.dart';

class JobPostSheetTabBarView extends StatelessWidget {
  const JobPostSheetTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final PostJobController controller = Get.find<PostJobController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
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
              'Post New Job',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildTabBar(controller),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(
                () => controller.jobType.value == 'One Way'
                    ? OnewayScreen()
                    : ByTheHour(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildChauffeurSelection(BuildContext context, PostJobController controller) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chauffeur Selection',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFD5C4AB), // warm beige
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => GestureDetector(
              onTap: () => showChauffeurSelectionBottomSheet(context, controller),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1C1C), // dark background
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF364153)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.chauffeurSelectionText,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFD5C4AB),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // If Chauffeur Selection is 'Service Area / Chauffeur Favorite', show Service Area Picker
          Obx(() {
            if (controller.isGlobal.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  Text(
                    'Select Service Area',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD5C4AB),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => showServiceAreaBottomSheet(context, controller),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1C1C),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFF364153)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedServiceArea.value,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFD5C4AB),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  static void showChauffeurSelectionBottomSheet(
      BuildContext context, PostJobController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: const Border(
            top: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Section 1: Service Area / Chauffeur Favorite
              Text(
                'Service Area / Chauffeur Favorite',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD5C4AB),
                ),
              ),
              SizedBox(height: 8.h),

              // Auto-assign Chauffeur Card
              Obx(
                () => GestureDetector(
                  onTap: () => controller.selectGlobal(),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: controller.isGlobal.value
                            ? const Color(0xFFD08700)
                            : const Color(0xFF2C2C2C),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.isGlobal.value
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: controller.isGlobal.value
                              ? const Color(0xFFD08700)
                              : Colors.grey.shade600,
                          size: 22.sp,
                        ),
                        SizedBox(width: 14.w),
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF27272A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.public,
                            color: Color(0xFFD5C4AB),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto-assign Chauffeur',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Closest available chauffeur',
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade500,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Section 2: Favorite Chauffeurs
              Text(
                'Favorite Chauffeurs',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD5C4AB),
                ),
              ),
              SizedBox(height: 8.h),

              // Chauffeur list items
              ...controller.favoriteDrivers.map((driver) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Obx(() {
                    final isSelected =
                        controller.selectedDrivers.contains(driver.name);
                    return GestureDetector(
                      onTap: () => controller.toggleDriverSelection(driver.name),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD08700)
                                : const Color(0xFF2C2C2C),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? const Color(0xFFD08700)
                                  : Colors.grey.shade600,
                              size: 22.sp,
                            ),
                            SizedBox(width: 14.w),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFD08700)
                                      : const Color(0xFF2C2C2C),
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 22.r,
                                backgroundImage: NetworkImage(driver.imageUrl),
                                backgroundColor: const Color(0xFF27272A),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        driver.name,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (driver.isTopRated) ...[
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD08700),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            'TOP RATED',
                                            style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        '${driver.vehicleName} • ',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey.shade500,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: const Color(0xFFD08700),
                                        size: 13.sp,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        driver.rating.toString(),
                                        style: GoogleFonts.inter(
                                          color: Colors.grey.shade500,
                                          fontSize: 13.sp,
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
                    );
                  }),
                );
              }),

              SizedBox(height: 16.h),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD08700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static void showServiceAreaBottomSheet(
      BuildContext context, PostJobController controller) {
    Get.bottomSheet(
      Container(
        height: 0.6.sh,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: const Border(
            top: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Service Area',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD5C4AB),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: controller.serviceAreas.length,
                itemBuilder: (context, index) {
                  final area = controller.serviceAreas[index];
                  return Obx(() {
                    final isSelected = controller.selectedServiceArea.value == area;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      title: Text(
                        area,
                        style: GoogleFonts.inter(
                          color: isSelected ? const Color(0xFFD08700) : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15.sp,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFFD08700))
                          : null,
                      onTap: () {
                        controller.selectedServiceArea.value = area;
                        Get.back();
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(PostJobController controller) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeJobType('One Way'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    color: controller.jobType.value == 'One Way'
                        ? Colors.white
                        : const Color(0xFF1F1C1C),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF364153)),
                  ),
                  child: Center(
                    child: Text(
                      'One Way',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.jobType.value == 'One Way'
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeJobType('By the hour'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    color: controller.jobType.value == 'By the hour'
                        ? Colors.white
                        : const Color(0xFF1F1C1C),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF364153)),
                  ),
                  child: Center(
                    child: Text(
                      'By the hour',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.jobType.value == 'By the hour'
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
