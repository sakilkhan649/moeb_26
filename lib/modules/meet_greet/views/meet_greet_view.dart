import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import '../controllers/meet_greet_controller.dart';

class MeetGreetView extends GetView<MeetGreetController> {
  const MeetGreetView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameTextController = TextEditingController();
    final TextEditingController subtitleTextController =
        TextEditingController();

    // Sync controllers with rx values
    nameTextController.text = controller.passengerName.value;
    subtitleTextController.text = controller.subtitleText.value;

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
              'Meet & Greet Sign',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: const Color(0xFFD5C4AB),
                  size: 22.sp,
                ),
                tooltip: 'Refresh Active Jobs',
                onPressed: () => controller.fetchActiveJobs(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- LIVE PREVIEW CARD ---
                    _buildSectionHeader('LIVE SIGN BOARD PREVIEW'),
                    SizedBox(height: 10.h),
                    _buildLivePreviewCard(),
                    SizedBox(height: 24.h),

                    // --- ACTIVE RIDE QUICK SELECT ---
                    Obx(() {
                      final jobs = controller.activeJobsList;
                      final selectedJobId = controller.selectedJob.value?.id;

                      if (jobs.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              'ASSIGNED PASSENGERS (ACTIVE RIDES)',
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 40.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: jobs.length,
                                separatorBuilder: (ctx, idx) =>
                                    SizedBox(width: 10.w),
                                itemBuilder: (ctx, idx) {
                                  final job = jobs[idx];
                                  final isSelected = selectedJobId == job.id;
                                  String passengerStr =
                                      'Ride #${job.id?.substring(0, 5) ?? idx}';
                                  if (job.createdBy != null) {
                                    if (job.createdBy is Map) {
                                      passengerStr =
                                          job.createdBy['name'] ?? passengerStr;
                                    }
                                  }

                                  return ChoiceChip(
                                    checkmarkColor: Colors.black,
                                    label: Text(
                                      passengerStr,
                                      style: GoogleFonts.inter(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedColor: const Color(0xFFD5C4AB),
                                    backgroundColor: const Color(0xFF1E1E1E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                      side: BorderSide(
                                        color: isSelected
                                            ? const Color(0xFFD5C4AB)
                                            : const Color(0xFF364153),
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        controller.selectJob(job);
                                        nameTextController.text =
                                            controller.passengerName.value;
                                        subtitleTextController.text =
                                            controller.subtitleText.value;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // --- PASSENGER & SUBTITLE INPUTS ---
                    _buildSectionHeader('PASSENGER DETAILS'),
                    SizedBox(height: 12.h),

                    _buildInputField(
                      label: 'Passenger / Guest Name',
                      hintText: 'e.g. JOHN SMITH',
                      icon: Icons.person_outline,
                      controller: nameTextController,
                      onChanged: (val) {
                        controller.passengerName.value = val.trim().isEmpty
                            ? 'JOHN SMITH'
                            : val.trim().toUpperCase();
                      },
                    ),

                    SizedBox(height: 14.h),

                    _buildInputField(
                      label: 'Flight No. / Subtitle / Note',
                      hintText: 'e.g. FLIGHT BG-088',
                      icon: Icons.flight_land,
                      controller: subtitleTextController,
                      onChanged: (val) {
                        controller.subtitleText.value = val.trim();
                      },
                    ),

                    SizedBox(height: 24.h),

                    // --- HEADER TAG PRESETS ---
                    _buildSectionHeader('HEADER TAG PRESET'),
                    SizedBox(height: 10.h),
                    Obx(() {
                      final currentTag = controller.headerTag.value;
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.headerTagPresets.map((tag) {
                          final isSelected = currentTag == tag;
                          return ChoiceChip(
                            checkmarkColor: Colors.black,
                            label: Text(
                              tag,
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFFD5C4AB),
                            backgroundColor: const Color(0xFF1E1E1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFFD5C4AB)
                                    : const Color(0xFF364153),
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                controller.headerTag.value = tag;
                              }
                            },
                          );
                        }).toList(),
                      );
                    }),

                    SizedBox(height: 24.h),

                    // --- COLOR THEME SELECTION ---
                    _buildSectionHeader('SIGN BOARD COLOR THEME'),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 75.h,
                      child: Obx(() {
                        final selectedIdx = controller.selectedThemeIndex.value;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.themes.length,
                          separatorBuilder: (ctx, idx) => SizedBox(width: 12.w),
                          itemBuilder: (ctx, idx) {
                            final themeItem = controller.themes[idx];
                            final isSelected = selectedIdx == idx;

                            return GestureDetector(
                              onTap: () =>
                                  controller.selectedThemeIndex.value = idx,
                              child: Container(
                                width: 130.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: themeItem.backgroundColor,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFD5C4AB)
                                        : themeItem.borderColor,
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          themeItem.name,
                                          style: GoogleFonts.inter(
                                            color: themeItem.headerColor,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: const Color(0xFFD5C4AB),
                                            size: 14.sp,
                                          ),
                                      ],
                                    ),
                                    Container(
                                      height: 18.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: themeItem.cardColor,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'TEXT PREVIEW',
                                        style: GoogleFonts.outfit(
                                          color: themeItem.nameColor,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 24.h),

                    // --- DISPLAY OPTIONS TOGGLES ---
                    _buildSectionHeader('DISPLAY & VISIBILITY OPTIONS'),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFF364153)),
                      ),
                      child: Obx(() {
                        final showLogo = controller.showCompanyLogo.value;
                        final showQr = controller.showQrCode.value;
                        final isFlashing = controller.isFlashingText.value;

                        return Column(
                          children: [
                            _buildToggleTile(
                              title: 'Show Company Logo Header',
                              subtitle: 'Displays company branding at top',
                              value: showLogo,
                              onChanged: (v) =>
                                  controller.showCompanyLogo.value = v,
                            ),
                            const Divider(color: Color(0xFF364153)),
                            _buildToggleTile(
                              title: 'Enable QR Code',
                              subtitle:
                                  'Displays QR code for ride / passenger info',
                              value: showQr,
                              onChanged: (v) => controller.showQrCode.value = v,
                            ),
                            const Divider(color: Color(0xFF364153)),
                            _buildToggleTile(
                              title: 'Pulsing Text Effect',
                              subtitle:
                                  'Subtle text pulse for night arrival gates',
                              value: isFlashing,
                              onChanged: (v) =>
                                  controller.isFlashingText.value = v,
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // --- BOTTOM PRIMARY ACTION BUTTON ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5C4AB),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 3,
                  ),
                  icon: Icon(Icons.fullscreen_rounded, size: 24.sp),
                  label: Text(
                    'SHOW PICKUP SIGN BOARD',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.w,
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.meetGreetFullscreenView);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: const Color(0xFFD5C4AB),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5.w,
      ),
    );
  }

  Widget _buildLivePreviewCard() {
    return Obx(() {
      final theme = controller.currentTheme;
      final pName = controller.passengerName.value;
      final pSubtitle = controller.subtitleText.value;
      final pHeader = controller.headerTag.value;

      return Container(
        width: double.infinity,
        height: 150.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: theme.borderColor.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MOEB PICKUP',
                  style: GoogleFonts.inter(
                    color: theme.headerColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: theme.borderColor),
                  ),
                  child: Text(
                    pHeader,
                    style: GoogleFonts.inter(
                      color: theme.headerColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    pName,
                    style: GoogleFonts.outfit(
                      color: theme.nameColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2.w,
                    ),
                  ),
                ),
              ),
            ),
            if (pSubtitle.isNotEmpty)
              Text(
                pSubtitle,
                style: GoogleFonts.inter(
                  color: theme.subtitleColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFFD5C4AB), size: 20.sp),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF364153)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFD5C4AB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: const Color(0xFFD5C4AB),
          activeTrackColor: const Color(0xFFD5C4AB).withValues(alpha: 0.4),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: const Color(0xFF121212),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
