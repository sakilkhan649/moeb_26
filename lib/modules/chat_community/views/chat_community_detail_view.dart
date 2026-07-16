import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import 'package:moeb_26/data/models/chat_community_model.dart';
import 'package:moeb_26/modules/chat_community/controllers/chat_community_detail_controller.dart';

class ChatCommunityDetailView extends StatelessWidget {
  ChatCommunityDetailView({super.key});

  final CommunityChatDetailController controller =
      Get.find<CommunityChatDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            const Divider(color: Colors.white, height: 1),
            // Messages List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
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
            _buildMessageInput(context),
          ],
        ),
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
                Obx(() => Text(
                  "${controller.selectedState.value} Chat",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                Obx(() => Text(
                  '${controller.selectedState.value} Live Chat',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            customButton: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF364153)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.selectedState.value,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFD5C4AB),
                    size: 16,
                  ),
                ],
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.black,
              ),
              width: 160.w,
            ),
            items: controller.states.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text(
                  state,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                controller.changeState(val);
              }
            },
          ),
        )),
      ],
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

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A1A), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // Align items to bottom for multiline support
        children: [
          // Attachment Button
          PopupMenuButton<int>(
            offset: Offset(0, -110.h),
            color: const Color(0xFF121212),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: const BorderSide(color: Color(0xFF262626), width: 1),
            ),
            elevation: 8,
            onSelected: (value) {
              if (value == 1) {
                controller.takePhoto();
              } else if (value == 2) {
                controller.pickImage(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      "Camera",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(
                height: 1,
              ),
              PopupMenuItem<int>(
                value: 2,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.photo_library_outlined, color: Colors.white, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      "Gallery",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Container(
              margin: EdgeInsets.only(bottom: 6.h), // align with bottom of textfield
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 10.w),
          // Input field container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: const Color(0xFF262626), width: 1),
              ),
              child: TextField(
                controller: controller.messageController,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF666666),
                    fontSize: 15.sp,
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
          SizedBox(width: 10.w),
          // Send Button with loader support
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Obx(
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
          ),
        ],
      ),
    );
  }
}
