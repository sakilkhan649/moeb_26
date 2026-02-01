import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/widgets/CustomButton.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextField.dart';
import 'package:moeb_26/widgets/Custom_ButtonIcon.dart';
import '../Utils/app_icons.dart';

// ============================================
// FUNCTION: Bottom Sheet Show Korar Jonno
// ============================================
void showContactSupportBottomSheet() {
  Get.bottomSheet(
    const ContactSupportBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}

// ============================================
// MAIN WIDGET: Contact Support Bottom Sheet
// ============================================
class ContactSupportBottomSheet extends StatelessWidget {
  const ContactSupportBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    // State management
    final isSubmitting = false.obs;
    final submitted = false.obs;

    return Container(
      height: 600.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(),

          // Form Content Section
          Expanded(
            child: _buildFormContent(
              subjectController,
              messageController,
              isSubmitting,
              submitted,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // HEADER SECTION
  // ============================================
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: CustomText(text: "Contact Support", fontSize: 20.sp),
        ),
      ],
    );
  }

  // ============================================
  // FORM CONTENT SECTION
  // ============================================
  Widget _buildFormContent(
    TextEditingController subjectController,
    TextEditingController messageController,
    RxBool isSubmitting,
    RxBool submitted,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subject Field
          _buildSubjectField(subjectController),
          SizedBox(height: 24.h),

          // Message Field
          _buildMessageField(messageController),
          SizedBox(height: 24.h),

          // Info Box
          _buildInfoBox(),
          SizedBox(height: 24.h),

          // Action Buttons
          _buildActionButtons(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // ============================================
  // SUBJECT FIELD
  // ============================================
  Widget _buildSubjectField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Subject',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),

        // Input Field
        Customtextfield(
          controller: controller,
          hintText: "problem",
          obscureText: false,
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  // ============================================
  // MESSAGE FIELD
  // ============================================
  Widget _buildMessageField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Message',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),

        // Multi-line Input Field
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe your issue or question in detail...',
            hintStyle: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF111827),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFF374151), width: 2),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  // ============================================
  // INFO BOX (Response Time)
  // ============================================
  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border.all(color: const Color(0xFF384555)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: SvgPicture.asset(
              AppIcons.message_icon,
              width: 24.w,
              height: 24.w,
            ),
          ),
          SizedBox(width: 12.w),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Average Response Time',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),

                // Description
                Text(
                  'Our support team typically responds within 24 hours during business days.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFFC5B6B6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // ACTION BUTTONS (Cancel & Send)
  // ============================================
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: CustomButton(
            text: "Cancel",
            onPressed: () {
              Get.back();
            },
          ),
        ),
        SizedBox(width: 12.w),

        // Send Message Button
        Expanded(
          child: CustomButtonIcon(
            text: "Send Message",
            backgroundColor: Colors.transparent,
            borderColor: Colors.white,
            textColor: Colors.white,
            iconWidget: SvgPicture.asset(
              AppIcons.send_icon,
              width: 24.w,
              height: 24.w,
            ),
            iconColor: Colors.white,
            iconOnRight: false,
            onPressed: () {
              Get.toNamed(Routes.chatPage);
              // Send message logic here
            },
          ),
        ),
      ],
    );
  }
}
