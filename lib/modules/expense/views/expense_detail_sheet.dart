import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import '../controllers/expense_controller.dart';
import '../models/expense_model.dart';

class ExpenseDetailSheet extends StatelessWidget {
  final ExpenseModel expense;
  final ExpenseController controller = Get.find<ExpenseController>();

  ExpenseDetailSheet({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = controller.currentTheme;
      final dateLongStr = DateFormat('EEEE, dd MMMM yyyy').format(expense.date);
      
      IconData getIcon(String cat) {
        switch (cat) {
          case 'Fuel':
            return Icons.local_gas_station_outlined;
          case 'Oil Change':
            return Icons.opacity_outlined;
          case 'Maintenance':
            return Icons.build_circle_outlined;
          case 'Parking':
            return Icons.local_parking_outlined;
          case 'Tolls':
            return Icons.toll_outlined;
          default:
            return Icons.receipt_outlined;
        }
      }

      return Container(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).padding.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border.all(color: theme.borderColor, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag indicator and Header
              Center(
                child: Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.borderColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Expense Details",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.white, size: 22.sp),
                  ),
                ],
              ),
              Divider(color: theme.borderColor.withValues(alpha: 0.3), thickness: 1),
              SizedBox(height: 20.h),

              // Category Badge & Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: theme.accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.accentColor.withValues(alpha: 0.2)),
                      ),
                      child: Icon(
                        getIcon(expense.category),
                        color: theme.accentColor,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      expense.category,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "\$${expense.amount.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        color: theme.accentColor,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Details Group
              _buildDetailRow("Date", dateLongStr, theme),
              if (expense.description.isNotEmpty) ...[
                SizedBox(height: 15.h),
                _buildDetailRow("Notes / Description", expense.description, theme, isMultiline: true),
              ],
              
              // Attachment Preview
              if (expense.receiptImageUrl != null) ...[
                SizedBox(height: 20.h),
                Text(
                  "Receipt Attachment",
                  style: GoogleFonts.inter(
                    color: AppColors.gray100,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => _previewReceipt(context, expense.receiptImageUrl!),
                  child: Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
                      image: DecorationImage(
                        image: FileImage(File(expense.receiptImageUrl!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in, color: Colors.white, size: 20.sp),
                            SizedBox(width: 6.w),
                            Text(
                              "Tap to zoom",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value, ExpenseThemeData theme, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.gray100,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: theme.borderColor.withValues(alpha: 0.2)),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              height: isMultiline ? 1.4 : 1.0,
            ),
          ),
        ),
      ],
    );
  }

  void _previewReceipt(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFF2C2C2C)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Receipt Preview",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
