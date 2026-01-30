import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'Controller/ChatDetail_controller.dart';
import 'Model/Chat_message_model.dart';
import 'Model/Chat_model.dart';

class ChatDetailPage extends StatelessWidget {
  ChatDetailPage({super.key});

  final ChatDetailController controller = Get.put(ChatDetailController());
  final ChatPreview chat = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(color: Color(0xffDADADA), height: 1),
          // Messages List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageBubble(message);
                },
              );
            }),
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
          CircleAvatar(
            radius: 20.r,
            backgroundColor: const Color(0xffE0E0E0),
            backgroundImage: chat.avatarPath != null
                ? AssetImage(chat.avatarPath!) as ImageProvider
                : null,
            child: chat.avatarPath == null
                ? Text(
                    chat.initials ?? '',
                    style: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Text(
            chat.name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isSender
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 0.7.sw),
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.only(bottom: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              message.text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h, left: 4.w, right: 4.w),
            child: Text(
              message.time,
              style: GoogleFonts.inter(
                color: Colors.grey[700],
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
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
        border: Border(top: BorderSide(color: Color(0xffDADADA))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffDADADA)),
              ),
              child: TextField(
                controller: controller.messageController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
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
        ],
      ),
    );
  }
}
