import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import '../controllers/meet_greet_controller.dart';

class MeetGreetFullscreenView extends StatefulWidget {
  const MeetGreetFullscreenView({super.key});

  @override
  State<MeetGreetFullscreenView> createState() =>
      _MeetGreetFullscreenViewState();
}

class _MeetGreetFullscreenViewState extends State<MeetGreetFullscreenView>
    with SingleTickerProviderStateMixin {
  final MeetGreetController controller = Get.find<MeetGreetController>();

  bool _showControls = true;
  Timer? _hideTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    controller.enterFullscreen();
    _startHideTimer();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pulseController.dispose();
    controller.exitFullscreen();
    controller.resetOrientation();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _showQuickEditDialog(BuildContext context) {
    final nameEditingController =
        TextEditingController(text: controller.passengerName.value);
    final subtitleEditingController =
        TextEditingController(text: controller.subtitleText.value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: Color(0xFF364153)),
          ),
          title: Text(
            'Quick Edit Sign Board',
            style: GoogleFonts.inter(
              color: const Color(0xFFD5C4AB),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameEditingController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
                decoration: InputDecoration(
                  labelText: 'Passenger / Guest Name',
                  labelStyle: GoogleFonts.inter(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF121212),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xFF364153)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xFFD5C4AB)),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: subtitleEditingController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: 'Flight / Note Subtitle',
                  labelStyle: GoogleFonts.inter(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF121212),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xFF364153)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xFFD5C4AB)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD5C4AB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                if (nameEditingController.text.trim().isNotEmpty) {
                  controller.passengerName.value =
                      nameEditingController.text.trim();
                }
                controller.subtitleText.value =
                    subtitleEditingController.text.trim();
                Navigator.pop(context);
              },
              child: Text(
                'Update Name',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.exitFullscreen();
        controller.resetOrientation();
      },
      child: Obx(() {
        final theme = controller.currentTheme;

        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: GestureDetector(
            onTap: _toggleControls,
            onDoubleTap: () => _showQuickEditDialog(context),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                // Main Sign Board Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: controller.isLandscape.value ? 8.h : 16.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- TOP BAR (Company Logo & Header Badge) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (controller.showCompanyLogo.value)
                              Image.asset(
                                AppImages.app_logo,
                                height: controller.isLandscape.value ? 35.h : 45.h,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                  'MOEB',
                                  style: GoogleFonts.outfit(
                                    color: theme.accentColor,
                                    fontSize: controller.isLandscape.value ? 16.sp : 20.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.w,
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: controller.isLandscape.value ? 4.h : 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: theme.borderColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_taxi_rounded,
                                    color: theme.headerColor,
                                    size: controller.isLandscape.value ? 14.sp : 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    controller.headerTag.value.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      color: theme.headerColor,
                                      fontSize: controller.isLandscape.value ? 11.sp : 14.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // --- MAIN CONTENT ---
                        Expanded(
                          child: (controller.isLandscape.value && controller.showQrCode.value)
                              ? Row(
                                  children: [
                                    // Left Side: Name & Subtitle Card
                                    Expanded(
                                      flex: 3,
                                      child: _buildNameCard(theme, isLandscape: true),
                                    ),
                                    // Right Side: Subtitle & QR Code
                                    SizedBox(width: 16.w),
                                    _buildLandscapeRightPanel(theme),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: _buildNameCard(
                                        theme,
                                        isLandscape: controller.isLandscape.value,
                                      ),
                                    ),
                                    if (controller.subtitleText.value.isNotEmpty) ...[
                                      SizedBox(height: controller.isLandscape.value ? 6.h : 10.h),
                                      Text(
                                        controller.subtitleText.value.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: theme.subtitleColor,
                                          fontSize: controller.isLandscape.value ? 16.sp : 20.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5.w,
                                        ),
                                      ),
                                    ],
                                    if (!controller.isLandscape.value && controller.showQrCode.value) ...[
                                      SizedBox(height: 10.h),
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: QrImageView(
                                          data: controller.qrData.value.isEmpty
                                              ? controller.passengerName.value
                                              : controller.qrData.value,
                                          version: QrVersions.auto,
                                          size: 90.sp,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: controller.isLandscape.value ? 4.h : 8.h),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- FLOATING CONTROLS OVERLAY ---
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: Stack(
                      children: [
                        // Top Bar Actions
                        Positioned(
                          top: 20.h,
                          right: 20.w,
                          child: SafeArea(
                            child: Row(
                              children: [
                                _buildControlButton(
                                  icon: controller.isLandscape.value
                                      ? Icons.screen_lock_portrait
                                      : Icons.screen_lock_landscape,
                                  tooltip: 'Rotate Screen',
                                  onTap: () => controller.toggleOrientation(),
                                  theme: theme,
                                ),
                                SizedBox(width: 10.w),
                                _buildControlButton(
                                  icon: Icons.edit_note_rounded,
                                  tooltip: 'Edit Name',
                                  onTap: () => _showQuickEditDialog(context),
                                  theme: theme,
                                ),
                                SizedBox(width: 10.w),
                                _buildControlButton(
                                  icon: Icons.close_rounded,
                                  tooltip: 'Exit Full Screen',
                                  onTap: () {
                                    controller.exitFullscreen();
                                    controller.resetOrientation();
                                    Get.back();
                                  },
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Hint Toast
                        Positioned(
                          bottom: 25.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                  color: theme.borderColor.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.touch_app_outlined,
                                    color: theme.headerColor,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Tap screen to toggle controls  |  Double tap to edit name',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNameCard(MeetGreetThemeData theme, {required bool isLandscape}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: isLandscape ? 4.h : 10.h),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: isLandscape ? 8.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.borderColor.withValues(alpha: 0.8),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Decorative Bar
          Container(
            height: isLandscape ? 2.h : 3.h,
            width: isLandscape ? 100.w : 140.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.borderColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: isLandscape ? 8.h : 20.h),

          // BIG BOLD PASSENGER NAME WITH SCALING
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final scale = controller.isFlashingText.value
                      ? _pulseAnimation.value
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        controller.passengerName.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: theme.nameColor,
                          fontSize: ((isLandscape ? 48 : 70) *
                                  controller.fontSizeScale.value)
                              .sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.w,
                          shadows: [
                            Shadow(
                              color: theme.borderColor.withValues(alpha: 0.4),
                              blurRadius: 15,
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

          SizedBox(height: isLandscape ? 6.h : 16.h),
          // Bottom Decorative Bar
          Container(
            height: isLandscape ? 2.h : 3.h,
            width: isLandscape ? 100.w : 140.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.borderColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeRightPanel(MeetGreetThemeData theme) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.subtitleText.value.isNotEmpty) ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                controller.subtitleText.value.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: theme.subtitleColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.w,
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          if (controller.showQrCode.value)
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: QrImageView(
                data: controller.qrData.value.isEmpty
                    ? controller.passengerName.value
                    : controller.qrData.value,
                version: QrVersions.auto,
                size: 70.sp,
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required MeetGreetThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        shape: BoxShape.circle,
        border: Border.all(color: theme.borderColor, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22.sp),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}
