import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Profile/widgets/LogoutBottomSheet.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../Views/home/JobOfferPage/Notifications/Notifications_popup.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onMyJobsTap;
  final VoidCallback? onLogoutTap;
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
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (logoPath != null && logoPath!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.zero,
                  child: Image.asset(logoPath!, height: 50.h, width: 50.h),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: (logoPath != null && logoPath!.isNotEmpty) ? 12.w : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null && title!.isNotEmpty)
                        CustomText(text: title!, fontSize: 20.sp),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        CustomTextgray(text: subtitle!, fontSize: 12.sp),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: Row(
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
                              top: -6.w,
                              right: -5.w,
                              child: Container(
                                width: 20.w,
                                height: 20.w,
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
                      onSelected: (item) => handleMenuItemSelection(item),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.black,
                                ),
                              ),
                              const Text('Account'),
                              SizedBox(width: 5.w),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.work_outline,
                                  color: Colors.black,
                                ),
                              ),
                              const Text('My Jobs'),
                              SizedBox(width: 5.w),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              const Text('Logout'),
                              SizedBox(width: 10.w),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                      offset: const Offset(
                        0,
                        80,
                      ), // Adjusted for taller AppBar height (80.h)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
  Size get preferredSize => Size.fromHeight(80.h);
}
