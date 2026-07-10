import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/widgets/LogoutBottomSheet.dart';
import 'package:moeb_26/modules/notifications/controllers/notifications_controller.dart';
import 'package:moeb_26/modules/notifications/views/notifications_view.dart';
import 'package:moeb_26/core/widgets/CustomText.dart';
import 'package:moeb_26/core/widgets/CustomTextGary.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onMyJobsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? serviceAreaTap;
  final VoidCallback? onMyProductsTap;
  final int notificationCount;
  final String? logoPath;
  final String? title;
  final String? subtitle;

  CustomAppBar({
    super.key,
    this.onNotificationTap,
    this.onAccountTap,
    this.onMyJobsTap,
    this.onLogoutTap,
    this.serviceAreaTap,
    this.onMyProductsTap,
    this.notificationCount = 0,
    this.logoPath,
    this.title,
    this.subtitle,
  });

  final NotificationController _notificationController = Get.put(
    NotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 4.w,
      title: Row(
        children: [
          if (logoPath != null && logoPath!.isNotEmpty) ...[
            Image.asset(logoPath!, height: 70.h, width: 130.w),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null && title!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: CustomText(
                        text: title!,
                        fontSize: 20.sp,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: CustomTextgray(
                        text: subtitle!,
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Obx(
          () => GestureDetector(
            onTap:
                onNotificationTap ??
                () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NotificationsView();
                    },
                  );
                },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 30.sp,
                  color: Colors.white,
                ),
                if (_notificationController.unreadCount > 0)
                  Positioned(
                    top: -2.w,
                    right: -1.w,
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _notificationController.unreadCount > 99
                              ? '99+'
                              : '${_notificationController.unreadCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        PopupMenuButton<int>(
          icon: Icon(Icons.person_outline, size: 30.sp, color: Colors.white),
          color: const Color(0xFF1E1E1E), // Dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Color(0xFF364153)),
          ),
          onSelected: (item) => handleMenuItemSelection(item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Account',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Create Invoice',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.deals_icon,
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Deals',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            PopupMenuItem<int>(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.logout_outlined, color: Colors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
          offset: const Offset(0, 50),
        ),
        // SizedBox(width: 16.w),
      ],
    );
  }

  void handleMenuItemSelection(int item) {
    switch (item) {
      case 0:
        if (onAccountTap != null) {
          onAccountTap!();
        } else {
          Get.toNamed(Routes.profileView);
        }
        break;
      case 3:
        Get.toNamed(Routes.invoiceHistoryView);
        break;
      case 1:
        Get.toNamed(Routes.dealsView);
        break;

      case 2:
        if (onLogoutTap != null) {
          onLogoutTap!();
        } else {
          Get.bottomSheet(
            const LogoutBottomSheet(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        }
        break;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
