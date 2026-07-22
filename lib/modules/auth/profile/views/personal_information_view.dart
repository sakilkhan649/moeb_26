import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/core/widgets/Custom_AppBar.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';

class PersonalInformationView extends StatelessWidget {
  const PersonalInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Personal & Driver Info',
        showBackButton: true,
        showActions: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar & Camera Picker
              Obx(
                () => Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD08700),
                          width: 2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD08700).withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.w),
                        child: controller.pickedImage.value != null
                            ? Image.file(
                                controller.pickedImage.value!,
                                fit: BoxFit.cover,
                              )
                            : (controller.profilePicture.value.isNotEmpty
                                ? Image.network(
                                    controller.profilePicture.value,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    AppImages.sadat_image,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 2.w,
                      child: GestureDetector(
                        onTap: () => controller.pickImage(context),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD08700),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Verified Chauffeur Badge
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: const Color(0xFFD08700),
                    size: 15.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Verified Professional Chauffeur',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Personal & Driver Details',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD5C4AB),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Full Name (ReadOnly)
              _buildInputField(
                label: 'Full Name',
                controller: controller.nameController,
                readOnly: true,
                icon: Icons.person_outline,
                suffixIcon: Icon(
                  Icons.lock_outline,
                  color: const Color(0xFF71717A),
                  size: 18.sp,
                ),
              ),

              // Email (ReadOnly)
              _buildInputField(
                label: 'Email',
                controller: controller.emailController,
                readOnly: true,
                icon: Icons.email_outlined,
                suffixIcon: Icon(
                  Icons.lock_outline,
                  color: const Color(0xFF71717A),
                  size: 18.sp,
                ),
              ),

              // Phone Number
              _buildInputField(
                label: 'Phone Number',
                controller: controller.phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              // Company Name
              _buildInputField(
                label: 'Company Name',
                controller: controller.companyController,
                icon: Icons.business_outlined,
              ),

              // Service Area
              _buildInputField(
                label: 'Service Area',
                controller: controller.serviceAreaController,
                icon: Icons.map_outlined,
              ),

              // Car - Tag / Vehicle Class
              _buildInputField(
                label: 'Car - Tag / Vehicle Class',
                controller: controller.carTagController,
                icon: Icons.directions_car_outlined,
              ),

              // Languages Spoken
              _buildInputField(
                label: 'Languages Spoken',
                controller: controller.languagesController,
                icon: Icons.translate_outlined,
              ),

              // Nick Name
              _buildInputField(
                label: 'Nick Name',
                controller: controller.nickNameController,
                icon: Icons.badge_outlined,
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(color: Color(0xFF1E1E1E), width: 1),
            ),
          ),
          child: SizedBox(
            height: 50.h,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: controller.isUpdating.value
                    ? null
                    : () => controller.saveProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD08700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: controller.isUpdating.value
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, color: Colors.black),
                label: Text(
                  controller.isUpdating.value ? "Saving..." : "Save Information",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              color: readOnly ? const Color(0xFF71717A) : Colors.white,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly
                  ? const Color(0xFF111111)
                  : const Color(0xFF1A1A1A),
              prefixIcon: Icon(icon, color: const Color(0xFFD5C4AB), size: 19.sp),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF2C2C2C),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF2C2C2C),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFD08700),
                  width: readOnly ? 1 : 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
