import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/core/utils/app_const.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';

class EditProfileBottomSheet extends StatelessWidget {
  EditProfileBottomSheet({super.key});

  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hasUploadedPhoto = controller.userProfile.value?.profilePicture != null &&
        controller.userProfile.value!.profilePicture.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.black, // Dark background matching request
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: const Color(0xFF1E1E1E),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Sheet Pull Handle
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 48.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Profile",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1E1E1E)),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  24.h,
                  20.w,
                  MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Section
                      Center(
                        child: Stack(
                          children: [
                            Obx(
                              () => Container(
                                height: 110.h,
                                width: 110.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: hasUploadedPhoto
                                        ? const Color(0xFF374151)
                                        : const Color(0xFFFF9800), // Orange outline if not uploaded
                                    width: 2.5,
                                  ),
                                  image: DecorationImage(
                                    image: controller.pickedImage.value != null
                                        ? FileImage(
                                            controller.pickedImage.value!,
                                          )
                                        : (controller
                                                  .userProfile
                                                  .value
                                                  ?.profilePicture
                                                  .isEmpty ??
                                              true)
                                        ? const AssetImage(
                                                "assets/images/sadat_image", // fallback
                                              ) as ImageProvider
                                        : NetworkImage(
                                            controller
                                                .userProfile
                                                .value!
                                                .profilePicture,
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2.h,
                              right: 2.w,
                              child: hasUploadedPhoto
                                  ? Container(
                                      padding: EdgeInsets.all(8.h),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF374151)),
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white70,
                                        size: 16.sp,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => controller.pickImage(context),
                                      child: Container(
                                        padding: EdgeInsets.all(8.h),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF9800), // Orange theme camera edit button
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Lock Warning Banner if Photo is Locked
                      if (hasUploadedPhoto) ...[
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            "Profile photo is locked for professional verification",
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 28.h),

                      // Full Name Field (ReadOnly & Locked)
                      _buildField(
                        "Full Name",
                        controller.nameController,
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                          size: 18.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),

                      // Email Field (ReadOnly & Locked)
                      _buildField(
                        "Email",
                        controller.emailController,
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                          size: 18.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!AppString.emailRegexp.hasMatch(value)) {
                            return "Invalid email format";
                          }
                          return null;
                        },
                      ),

                      // Phone Field (Editable)
                      _buildField(
                        "Phone",
                        controller.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
                      ),

                      // Nick Name Field (Editable)
                      _buildField(
                        "Nick Name",
                        controller.nickNameController,
                      ),

                      SizedBox(height: 36.h),

                      // Actions Block
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(0xFF374151),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate() &&
                                    !controller.isUpdating.value) {
                                  controller.saveProfile();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9800), // Orange theme save button
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9800).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Obx(
                                    () => controller.isUpdating.value
                                        ? SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(
                                            "Save Changes",
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController textController, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
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
            controller: textController,
            validator: validator,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: GoogleFonts.inter(
              color: readOnly ? Colors.grey[500] : Colors.white,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFF0F172A) : const Color(0xFF111827),
              errorStyle: TextStyle(fontSize: 12.sp),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly ? const Color(0xFF1E293B) : const Color(0xFF374151),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly ? const Color(0xFF1E293B) : const Color(0xFF374151),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: readOnly ? const Color(0xFF1E293B) : const Color(0xFFFF9800),
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
