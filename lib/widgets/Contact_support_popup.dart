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
import '../Views/auth/Application_Not_Approved/Controller/support_controller.dart';

// ============================================
// FUNCTION: Bottom Sheet Show Korar Jonno
// ============================================
void showContactSupportBottomSheet() {
  Get.bottomSheet(
    ContactSupportBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}

// ============================================
// MAIN WIDGET: Contact Support Bottom Sheet
// ============================================
class ContactSupportBottomSheet extends StatelessWidget {
  ContactSupportBottomSheet({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final SupportController controller = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.h,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Tickets List (If any)
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: CircularProgressIndicator(color: Colors.white),
                      ));
                    }
                    if (controller.tickets.isEmpty) return SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: CustomText(text: "My Support Tickets", fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 190.h,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.tickets.length,
                            itemBuilder: (context, index) {
                              final ticket = controller.tickets[index];
                              return _buildTicketCard(ticket);
                            },
                          ),
                        ),
                        Divider(color: Colors.grey[900]),
                      ],
                    );
                  }),

                  Form(
                    key: _formKey,
                    child: _buildFormContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(dynamic ticket) {
    return Container(
      width: 250.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF374151)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket['subject'] ?? 'No Subject',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            ticket['messages'] != null && ticket['messages'].isNotEmpty 
                ? ticket['messages'].last['message'] 
                : 'No messages',
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _formatDate(ticket['createdAt']),
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return "";
    }
  }

  // ============================================
  // HEADER SECTION
  // ============================================
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Contact Support", fontSize: 20.sp),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================
  // FORM CONTENT SECTION
  // ============================================
  Widget _buildFormContent() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subject Field
          _buildSubjectField(controller.subjectController),
          SizedBox(height: 24.h),

          // Message Field
          _buildMessageField(controller.messageController),
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
          hintText: "Enter subject",
          obscureText: false,
          textInputType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a subject";
            }
            return null;
          },
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
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a message";
            }
            if (value.length < 10) {
              return "Message must be at least 10 characters";
            }
            return null;
          },
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 2),
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
          child: Obx(() => CustomButtonIcon(
            text: controller.isSubmitting.value ? "Sending..." : "Send Message",
            backgroundColor: Colors.transparent,
            borderColor: Colors.white,
            textColor: Colors.white,
            iconWidget: controller.isSubmitting.value 
              ? SizedBox(width: 20.w, height: 20.w, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : SvgPicture.asset(
                  AppIcons.send_icon,
                  width: 24.w,
                  height: 24.w,
                ),
            iconColor: Colors.white,
            iconOnRight: false,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                controller.createSupportTicket();
              }
            },
          )),
        ),
      ],
    );
  }
}

