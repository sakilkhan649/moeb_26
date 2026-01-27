import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'By_the_hour.dart';
import 'Controller/Job_bottom_sheet_Controller.dart';
import 'OneWay_screen.dart';

class PostJobBottomSheet extends StatelessWidget {
  PostJobBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final PostJobController controller = Get.put(PostJobController());

    return Container(
      height: 0.9.sh,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(controller),
          Expanded(
            child: Obx(
              () => controller.jobType.value == 'One Way'
                  ? OnewayScreen()
                  : ByTheHour(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Post New Job',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
          ),
        ],
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
                        : Color(0xFF1F1C1C),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xFF364153)),
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
                        : Color(0xFF1F1C1C),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xFF364153)),
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
