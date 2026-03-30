import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_colors.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Views/home/JobOfferPage/JobOfferPage.dart';
import 'package:moeb_26/Core/routs.dart';

class AllVehicle extends StatelessWidget {
  AllVehicle({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(12.r),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
        title: Text(
          "All Vehicles",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final vehicles = controller.userProfile.value?.vehicles ?? [];
        
        if (vehicles.isEmpty) {
          return Center(
            child: Text(
              "No vehicles added",
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  final vehicleStyle = VehicleTypeColors.getVehicleStyle(vehicle.carType);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.grey,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${vehicle.year} ${vehicle.make} ${vehicle.model}",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${vehicle.carType} • ${vehicle.licensePlate}",
                                  style: GoogleFonts.inter(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Edit Icon
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.addNewVehicle,
                                arguments: {
                                  "isEdit": true,
                                  "vehicle": vehicle,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: AppColors.orange100,
                                size: 16.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: vehicleStyle is Color ? vehicleStyle : null,
                              gradient: vehicleStyle is Gradient ? vehicleStyle : null,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              vehicle.carType.toUpperCase(),
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Add New Vehicle Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.addNewVehicle, arguments: {"isEdit": false});
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: const Color(0xFFFAC0C0), size: 20.sp),
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
              ),
            ),
            SizedBox(height: 20.h),
          ],
        );
      }),
    );
  }
}
