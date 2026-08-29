import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import '../controllers/serviceController.dart';

class ServiceAreaView extends StatefulWidget {
  const ServiceAreaView({super.key});

  @override
  State<ServiceAreaView> createState() => _ServiceAreaViewState();
}

class _ServiceAreaViewState extends State<ServiceAreaView> {
  final ServiceAreaController controller = Get.put(ServiceAreaController());

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
                        color: Colors.grey.withValues(alpha: 0.2),
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
                  color: AppColors.primaryColor,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.serviceAreas.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
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
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          controller.serviceAreas.length +
                          (controller.isMoreLoading.value ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (index == controller.serviceAreas.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }
                        final item = controller.serviceAreas[index];
                        final isActive = item.status == 'ACTIVE';

                        return Obx(() {
                          final isSelected =
                              controller.selectedAreaName.value ==
                              item.areaName;

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
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : const Color(0xFF364153),
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
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (!isActive) ...[
                                            SizedBox(width: 8.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                                border: Border.all(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                "INACTIVE",
                                                style: GoogleFonts.inter(
                                                  color: Colors.red,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
                                  padding: EdgeInsets.all(12.w),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E2939),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: const Color(0xFF364153),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (isActive) {
                                            controller.selectServiceArea(
                                              item.areaName,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            if (isActive)
                                              SizedBox(
                                                height: 30.h,
                                                width: 30.w,
                                                child: Radio<String>(
                                                  value: item.areaName,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  groupValue: controller
                                                      .selectedAreaName
                                                      .value,
                                                  onChanged: (value) =>
                                                      controller
                                                          .selectServiceArea(
                                                            value!,
                                                          ),
                                                  activeColor:
                                                      AppColors.primaryColor,
                                                ),
                                              ),
                                            if (isActive)
                                              SizedBox(width: 8.w),
                                            Text(
                                              "Select ${item.areaName}",
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (item.cities.isNotEmpty) ...[
                                        SizedBox(height: 8.h),
                                        Text(
                                          "Included Cities:",
                                          style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Obx(() {
                                          final isShowAll = controller
                                              .expandedCitiesAreas
                                              .contains(item.areaName);
                                          const limit = 6;
                                          final displayedCities =
                                              isShowAll || item.cities.length <= limit
                                                  ? item.cities
                                                  : item.cities.take(limit).toList();

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 6.w,
                                                runSpacing: 6.h,
                                                children:
                                                    displayedCities.map((city) {
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.r),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF364153),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      city,
                                                      style: GoogleFonts.inter(
                                                        color: Colors.grey[300],
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              if (item.cities.length > limit) ...[
                                                SizedBox(height: 6.h),
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .toggleShowAllCities(
                                                          item.areaName),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.h),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          isShowAll
                                                              ? "Show less"
                                                              : "Show all (+${item.cities.length - limit} more)",
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Icon(
                                                          isShowAll
                                                              ? Icons
                                                                  .keyboard_arrow_up
                                                              : Icons
                                                                  .keyboard_arrow_down,
                                                          size: 16.sp,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          );
                                        }),
                                      ],
                                    ],
                                  ),
                                ),
                            ],
                          );
                        });
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),
              // Save Changes Button
              Obx(
                () => controller.isUpdating.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Save Changes",
                        onPressed: () => controller.updateServiceArea(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
