import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Views/home/JobOfferPage/Notifications/Notifications_popup.dart'; // Import your notification popup

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onMyJobsTap;
  final VoidCallback? onLogoutTap;
  final int notificationCount;
  final String logoPath;

  const CustomAppBar({
    Key? key,
    this.onNotificationTap,
    this.onAccountTap,
    this.onMyJobsTap,
    this.onLogoutTap,
    this.notificationCount = 0,
    required this.logoPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Image.asset(logoPath, height: 60.w, width: 60.w),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
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
                              icon: Icon(
                                Icons.person_outline,
                                color: Colors.black,
                              ),
                            ),
                            Text('Account'),
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
                              icon: Icon(
                                Icons.work_outline,
                                color: Colors.black,
                              ),
                            ),
                            Text('My Jobs'),
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
                              icon: Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
                              ),
                            ),
                            Text('Logout'),
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
                    offset: Offset(0, 50),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleMenuItemSelection(int item) {
    // Popup menu automatically closes, so we need to handle navigation after
    switch (item) {
      case 0:
        // Account selected
        if (onAccountTap != null) {
          onAccountTap!();
        } else {
          print('Account selected');
        }
        break;
      case 1:
        // My Jobs selected
        if (onMyJobsTap != null) {
          onMyJobsTap!();
        } else {
          print('My Jobs selected');
        }
        break;
      case 2:
        // Logout selected
        if (onLogoutTap != null) {
          onLogoutTap!();
        } else {
          print('Logout selected');
        }
        break;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
