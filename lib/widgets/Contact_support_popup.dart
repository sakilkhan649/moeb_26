import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// এভাবে call করবেন:
// showContactSupportBottomSheet();

void showContactSupportBottomSheet() {
  Get.bottomSheet(
    const ContactSupportBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}

class ContactSupportBottomSheet extends StatelessWidget {
  const ContactSupportBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    final isSubmitting = false.obs;
    final submitted = false.obs;

    Future<void> handleSubmit() async {
      if (subjectController.text.isEmpty || messageController.text.isEmpty) {
        return;
      }

      isSubmitting.value = true;

      await Future.delayed(const Duration(milliseconds: 1500));

      isSubmitting.value = false;
      submitted.value = true;

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }

    void handleCancel() {
      Get.back();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border.all(color: const Color(0xFF1F2937)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDragHandle(),
            _buildHeader(),
            Flexible(
              child: _buildFormContent(
                subjectController,
                messageController,
                isSubmitting,
                submitted,
                handleSubmit,
                handleCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: const Color(0xFF374151),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF111827), Colors.black]),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937))),
      ),
      child: Text(
        'Contact Support',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFormContent(
      TextEditingController subjectController,
      TextEditingController messageController,
      RxBool isSubmitting,
      RxBool submitted,
      Function handleSubmit,
      Function handleCancel,
      ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSubjectField(subjectController),
          SizedBox(height: 24.h),
          _buildMessageField(messageController),
          SizedBox(height: 24.h),
          _buildInfoBox(),
          Obx(() {
            if (submitted.value) {
              return Column(
                children: [
                  SizedBox(height: 24.h),
                  _buildSuccessMessage(),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          SizedBox(height: 24.h),
          _buildButtons(
            isSubmitting,
            subjectController,
            messageController,
            handleSubmit,
            handleCancel,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSubjectField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFD1D5DB),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: 'problem',
            hintStyle: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF111827),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFD1D5DB),
          ),
        ),
        SizedBox(height: 8.h),
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
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF172554), Color(0xFF111827)],
        ),
        border: Border.all(color: const Color(0xFF1E3A8A)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.access_time,
              color: const Color(0xFF60A5FA),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Response Time',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Our support team typically responds within 24 hours during business days.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF047857)],
        ),
        border: Border.all(color: const Color(0xFF059669)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'Message sent successfully! ✓',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFD1FAE5),
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildButtons(
      RxBool isSubmitting,
      TextEditingController subjectController,
      TextEditingController messageController,
      Function handleSubmit,
      Function handleCancel,
      ) {
    return Row(
      children: [
        Expanded(child: _buildCancelButton(handleCancel)),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSubmitButton(
            isSubmitting,
            subjectController,
            messageController,
            handleSubmit,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(Function handleCancel) {
    return ElevatedButton(
      onPressed: () => handleCancel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 0,
      ),
      child: Text(
        'Cancel',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSubmitButton(
      RxBool isSubmitting,
      TextEditingController subjectController,
      TextEditingController messageController,
      Function handleSubmit,
      ) {
    return Obx(() {
      final bool isEnabled = subjectController.text.isNotEmpty &&
          messageController.text.isNotEmpty &&
          !isSubmitting.value;

      return ElevatedButton(
        onPressed: isEnabled ? () => handleSubmit() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          elevation: 0,
        ),
        child: isSubmitting.value
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Sending...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Send Message',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }
}