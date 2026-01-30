import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Core/routs.dart';
import '../../../../widgets/CustomButton.dart';
import '../Model/Marketplace_model.dart';

class ContactSellerPopup extends StatefulWidget {
  final MarketplaceItem item;

  const ContactSellerPopup({super.key, required this.item});

  @override
  State<ContactSellerPopup> createState() => _ContactSellerPopupState();
}

class _ContactSellerPopupState extends State<ContactSellerPopup> {
  final TextEditingController _messageController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _charCount = _messageController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contact Seller",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: Colors.grey, size: 24.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Item Info Card
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        widget.item.imagePath,
                        height: 50.w,
                        width: 50.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "\$${widget.item.price}",
                            style: GoogleFonts.inter(
                              color: const Color(0xFFF1A107),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Message Label
              Text(
                "Your Message",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              // Message Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 4,
                  maxLength: 500,
                  style: GoogleFonts.inter(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15.w),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "$_charCount/500 characters",
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
              ),
              SizedBox(height: 24.h),
              // Buttons
              CustomButton(
                text: "Send Message",
                backgroundColor: const Color(0xFFF1A107),
                textColor: Colors.white,
                onPressed: () {
                  Get.back(); // Close popup
                  Get.toNamed(Routes.chatPage); // Navigate to ChatPage
                },
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: "Cancel",
                backgroundColor: const Color(0xFF1E1E1E),
                textColor: Colors.white,
                borderColor: const Color(0xFF242424),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
