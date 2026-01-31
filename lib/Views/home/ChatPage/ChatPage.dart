import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Core/routs.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Controller/Chat_controller.dart';

class Chatpage extends StatelessWidget {
  Chatpage({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Messages',
        subtitle: 'Elite Chauffeur Network',
        notificationCount: 3,
        onMyJobsTap: () {
          Get.toNamed(Routes.myJobsScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // Header Section
            // Search Bar
            TextFormField(
              onChanged: (value) => controller.filterChats(value),
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: Color(0xff1A1A1A),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24.sp),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 10.w,
                ), // Adjust padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Color(0xff242424)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Color(0xff242424)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Color(0xff242424)),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Chat List
            Expanded(
              child: Obx(() {
                if (controller.filteredChats.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages found',
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.filteredChats.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                  itemBuilder: (context, index) {
                    final chat = controller.filteredChats[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.chatDetailPage, arguments: chat);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 28.r,
                              backgroundColor: Colors.grey[800],
                              backgroundImage: chat.avatarPath != null
                                  ? AssetImage(chat.avatarPath!)
                                        as ImageProvider
                                  : null,
                              child: chat.avatarPath == null
                                  ? Text(
                                      chat.initials ?? '',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12.w),
                            // Chat Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        chat.name,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        chat.time,
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          chat.lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      if (chat.unreadCount > 0)
                                        Container(
                                          padding: EdgeInsets.all(6.w),
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .amber[700], // Orange/Gold circle
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            chat.unreadCount.toString(),
                                            style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
