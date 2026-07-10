import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'invoice_profile_settings_view.dart';

class InvoiceSettingsView extends StatelessWidget {
  const InvoiceSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Invoice Settings',
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        children: [
          _buildSettingsItem(
            icon: Icons.business_outlined,
            title: 'Profile Settings',
            subtitle: 'Update business logo, name, email and address',
            onTap: () => Get.to(() => const InvoiceProfileSettingsView()),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFFEDB9B), size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFD5C4AB),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
