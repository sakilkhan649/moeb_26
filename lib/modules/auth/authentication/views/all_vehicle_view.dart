import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/data/models/user_profile_model.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';

class AllVehicleView extends StatelessWidget {
  AllVehicleView({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    // Automatically trigger fresh fetch when opening this view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVehicles();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomSubAppBar(title: "My Vehicles"),
      body: Obx(() {
        if (controller.isVehiclesLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        final vehicles = controller.vehiclesList;

        if (vehicles.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: const Color(0xFF1A1A1A),
            onRefresh: () => controller.fetchVehicles(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                SizedBox(height: 200.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        color: Colors.grey[600],
                        size: 50.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "No vehicles added yet",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 180.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildAddNewVehicleButton(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: () => controller.fetchVehicles(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    final vehicleStyle = VehicleTypeColors.getVehicleStyle(
                      vehicle.carType,
                    );

                    final displayName = vehicle.year > 0
                        ? "${vehicle.year} ${vehicle.makeAndModel}"
                        : vehicle.makeAndModel;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: GestureDetector(
                        onTap: () => _showActionPopup(context, vehicle),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.directions_car_rounded,
                                  color: const Color(0xFFFEDB9B),
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName.isNotEmpty
                                          ? displayName
                                          : "Vehicle #${index + 1}",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${vehicle.carType} • ${vehicle.licensePlate}",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey[400],
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: vehicleStyle is Color
                                      ? vehicleStyle
                                      : null,
                                  gradient: vehicleStyle is Gradient
                                      ? vehicleStyle
                                      : null,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  vehicle.carType.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Add New Vehicle Button at Bottom
            Padding(
              padding: EdgeInsets.all(20.w),
              child: _buildAddNewVehicleButton(),
            ),
            SizedBox(height: 10.h),
          ],
        );
      }),
    );
  }

  Widget _buildAddNewVehicleButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.addNewVehicleView,
          arguments: {"isEdit": false},
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: const Color(0xFFFAC0C0),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              "Add New Vehicle",
              style: GoogleFonts.inter(
                color: const Color(0xFFFAC0C0),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionPopup(BuildContext context, Vehicle vehicle) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              "Vehicle Actions",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),

            // Edit Option
            _buildActionItem(
              icon: Icons.edit_outlined,
              title: "Edit Vehicle",
              color: AppColors.orange100,
              onTap: () {
                Get.back();
                Get.toNamed(
                  Routes.addNewVehicleView,
                  arguments: {"isEdit": true, "vehicle": vehicle},
                );
              },
            ),
            SizedBox(height: 12.h),

            // Delete Option
            _buildActionItem(
              icon: Icons.delete_outline,
              title: "Delete Vehicle",
              color: Colors.red,
              onTap: () {
                Get.back();
                _showDeleteConfirmation(vehicle.id);
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String vehicleId) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Delete Vehicle?",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Are you sure you want to remove this vehicle? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deleteVehicle(vehicleId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
