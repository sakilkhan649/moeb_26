import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/widgets/Custom_AppBar.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import '../controllers/chat_controller.dart';
import '../../../data/models/chat_community_model.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final ChatController controller = Get.find<ChatController>();
  final UserService userService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Chats', notificationCount: 3),
      body: GestureDetector(
        onTap: () => controller.clearDeleteSelection(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),

                // ── Search Bar ──
                TextFormField(
                  onChanged: (value) => controller.filterChats(value),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
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
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 24.sp,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
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
                        color: const Color(0xFFD08700),
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
                    onRefresh: () async {
                      await controller.fetchChats();
                      await controller.fetchCommunityRoom();
                    },
                    color: Colors.grey,
                    backgroundColor: const Color(0xff1A1A1A),
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.chats.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final communityRoom = controller.communityRoom.value;

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            controller.filteredChats.length +
                            (communityRoom != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (communityRoom != null && index == 0) {
                            return _buildCommunityChatTile(communityRoom);
                          }

                          final chatIndex = communityRoom != null
                              ? index - 1
                              : index;
                          final chat = controller.filteredChats[chatIndex];
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
      ),
    );
  }

  /// ── Community Chat Tile ──
  Widget _buildCommunityChatTile(CommunityRoom room) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.chatCommunityDetailView, arguments: room);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              padding: EdgeInsets.all(2.r), // This creates space for the border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[700]!, // Visible gray border
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/ekkali chat.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Live Chat",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (room.lastMessageAt != null)
                        Text(
                          _formatTime(room.lastMessageAt!),
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    room.lastMessage ?? 'No messages yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── Single Chat Tile ──
  Widget _buildChatTile(ChatPreview chat) {
    final other = chat.getOtherParticipant(userService.userId);
    return InkWell(
      onTap: () {
        if (controller.selectedChatIdForDelete.value != "") {
          controller.clearDeleteSelection();
        } else {
          Get.toNamed(Routes.chatDetailView, arguments: chat);
        }
      },
      onLongPress: () {
        controller.toggleDeleteIcon(chat.id);
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
                      Obx(() {
                        final isDeleteMode =
                            controller.selectedChatIdForDelete.value == chat.id;
                        return isDeleteMode
                            ? GestureDetector(
                                onTap: () => _showDeleteConfirmation(chat),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 22.sp,
                                ),
                              )
                            : chat.lastMessageAt != null
                            ? Text(
                                _formatTime(chat.lastMessageAt!),
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
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

  void _showDeleteConfirmation(ChatPreview chat) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xff1A1A1A),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete Chat?",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Are you sure you want to delete this chat? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.deleteChat(chat.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Delete",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Avatar Widget ──
  Widget _buildAvatar(ChatPreview chat) {
    final other = chat.getOtherParticipant(userService.userId);
    final hasImage =
        other?.profilePicture != null && other!.profilePicture!.isNotEmpty;
    final isNetwork = hasImage && other.profilePicture!.startsWith('http');
    return Container(
      width: 56.r,
      height: 56.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[700]!, width: 1.5),
      ),
      child: ClipOval(
        child: CircleAvatar(
          radius: 28.r,
          backgroundColor: Colors.grey[800],
          backgroundImage: hasImage
              ? (isNetwork
                        ? NetworkImage(other.profilePicture!)
                        : AssetImage(other.profilePicture!))
                    as ImageProvider
              : null,
          child: !hasImage
              ? Text(
                  other?.initials ?? '?',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ),
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
