import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/LogoutBottomSheet.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../Views/home/JobOfferPage/Notifications/Notifications_popup.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onMyJobsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? serviceAreaTap;
  final int notificationCount;
  final String? logoPath;
  final String? title;
  final String? subtitle;

  const CustomAppBar({
    Key? key,
    this.onNotificationTap,
    this.onAccountTap,
    this.onMyJobsTap,
    this.onLogoutTap,
    this.serviceAreaTap,
    this.notificationCount = 0,
    this.logoPath,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 4.w,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logoPath != null && logoPath!.isNotEmpty) ...[
            Image.asset(logoPath!, height: 70.h, width: 150.w),
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
        Row(
          children: [
            GestureDetector(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: -2.w,
                      right: -1.w,
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 99
                                ? '99+'
                                : '$notificationCount',
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
              onTap:
                  onNotificationTap ??
                  () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomNotificationPopup();
                      },
                    );
                  },
            ),
            SizedBox(width: 10.w),
            PopupMenuButton<int>(
              icon: Icon(
                Icons.person_outline,
                size: 30.sp,
                color: Colors.white,
              ),
              color: Color(0xFF1E1E1E), // Dark background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Color(0xFF364153)),
              ),
              onSelected: (item) => handleMenuItemSelection(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Account',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
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
                        AppIcons.job_offer_icon,
                        width: 24.sp,
                        height: 24.sp,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'My Jobs',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
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
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Service Area',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
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
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
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
            SizedBox(width: 16.w),
          ],
        ),
      ],
    );
  }

  void handleMenuItemSelection(int item) {
    switch (item) {
      case 0:
        if (onAccountTap != null) {
          onAccountTap!();
        } else {
          Get.toNamed(Routes.profileScreen);
        }
        break;
      case 1:
        if (onMyJobsTap != null) {
          onMyJobsTap!();
        } else {
          Get.toNamed(Routes.myJobsScreen);
        }
        break;
      case 2:
        if (serviceAreaTap != null) {
          serviceAreaTap!();
        } else {
          Get.toNamed(Routes.serviceArea);
        }
        break;
      case 3:
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
