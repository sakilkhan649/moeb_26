import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Services/user_service.dart';
import '../../../Core/routs.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Controller/Chat_controller.dart';
import 'Model/Chat_model.dart';

class Chatpage extends StatelessWidget {
  Chatpage({super.key});

  final ChatController controller = Get.find<ChatController>();
  final UserService userService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Messages',
        subtitle: 'Messaging',
        notificationCount: 3,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),

              // ── Search Bar ──
              
              TextFormField(
                onChanged: (value) => controller.filterChats(value),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xff1A1A1A),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w),
                    child: Icon(Icons.search, color: Colors.grey, size: 24.sp),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40.w,
                    minHeight: 40.h,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 16.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: const Color(0xff242424),
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: const Color(0xffD4A843),
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: const Color(0xff242424),
                      width: 1.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // ── Chat List ──
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchChats,
                  color: const Color(0xffD4A843),
                  backgroundColor: const Color(0xff1A1A1A),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.chats.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.filteredChats.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: 0.6.sh,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.grey.withOpacity(0.4),
                                size: 48.sp,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No messages found',
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.filteredChats.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.withOpacity(0.15),
                        height: 1.h,
                        thickness: 0.5.h,
                      ),
                      itemBuilder: (context, index) {
                        final chat = controller.filteredChats[index];
                        return _buildChatTile(chat);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Single Chat Tile ──
  Widget _buildChatTile(ChatPreview chat) {
    final other = chat.getOtherParticipant(userService.userId);
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.chatDetailPage, arguments: chat);
      },
      borderRadius: BorderRadius.circular(12.r),
      splashColor: Colors.white10,
      highlightColor: Colors.white10,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            // ── Avatar ──
            _buildAvatar(chat),
            SizedBox(width: 12.w),

            // ── Chat Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          other?.name ?? 'Chat',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (chat.lastMessageAt != null)
                        Text(
                          _formatTime(chat.lastMessageAt!),
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Last Message
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage ?? 'No messages yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 14.sp,
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
  }

  /// ── Avatar Widget ──
  Widget _buildAvatar(ChatPreview chat) {
    final other = chat.getOtherParticipant(userService.userId);
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: Colors.grey[800],
      backgroundImage: other?.profilePicture != null
          ? NetworkImage(other!.profilePicture!) as ImageProvider
          : null,
      child: other?.profilePicture == null
          ? Text(
              other?.initials ?? '?',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        final hour = date.hour > 12 ? date.hour - 12 : date.hour;
        final minute = date.minute.toString().padLeft(2, '0');
        final period = date.hour >= 12 ? 'PM' : 'AM';
        return '$hour:$minute $period';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}
