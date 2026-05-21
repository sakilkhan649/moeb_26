// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/Views/home/ChatPage/Controller/Community_chat_detail_controller.dart';
import 'package:moeb_26/Views/home/ChatPage/Model/Community_chat_model.dart';

class CommunityChatDetailPage extends StatelessWidget {
  CommunityChatDetailPage({super.key});

  final CommunityChatDetailController controller = Get.put(
    CommunityChatDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(color: Colors.white, height: 1),
          // Messages List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: controller.messages.length,
                reverse: true, // Show latest messages at the bottom
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageBubble(message);
                },
              );
            }),
          ),


          // Image Previews (Before sending)
          Obx(
            () => controller.selectedImages.isEmpty
                ? const SizedBox.shrink()
                : _buildImagePreviews(),
          ),

          // Bottom Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
           Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(2.r), // This creates space for the border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[700]!, // Visible gray border
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Transform.scale(
                  scale: 1.4,
                  child: Image.asset(
                    AppImages.moeb26_community_chat_pp,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.room.name.replaceAll('Network', '').trim(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Network Chat',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(CommunityMessage message) {
    final bool isMe = message.sender.id == controller.userService.userId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                child: Text(
                  message.sender.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMe ? Color(0xff1A1A1A) : const Color(0xff1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
                ),
                border: Border.all(
                  color: isMe
                      ? const Color(0xff333333)
                      : const Color(0xff333333),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.attachments.isNotEmpty)
                    Column(
                      children: message.attachments
                          .map(
                            (url) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(url, fit: BoxFit.cover),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              message.time,
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviews() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 80.w,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: FileImage(controller.selectedImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 8.w,
                child: GestureDetector(
                  onTap: () => controller.removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 14.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 30.h,
        top: 10.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => controller.pickImage(),
            icon: Icon(Icons.image, color: Colors.grey, size: 24.sp),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white),
              ),
              child: TextField(
                controller: controller.messageController,
                style: GoogleFonts.inter(color: Colors.white),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Obx(
            () => controller.isSending.value
                ? const CircularProgressIndicator(color: Color(0xffD4A843))
                : GestureDetector(
                    onTap: () => controller.sendMessage(),
                    child: SvgPicture.asset(
                      AppIcons.send_message_icon,
                      height: 24.sp,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
