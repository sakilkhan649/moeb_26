import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/invoice_controller.dart';
import 'invoice_preview_view.dart';
import 'create_invoice_view.dart';

class InvoiceDetailView extends GetView<InvoiceController> {
  final int index;

  const InvoiceDetailView({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () => Get.back(),
            ),
            title: Obx(() {
              if (index >= controller.invoiceHistory.length) {
                return const Text('Invoice Details');
              }
              final record = controller.invoiceHistory[index];
              return Text(
                record.invoiceNumber,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),
            centerTitle: true,
          ),
        ),
      ),
      body: Obx(() {
        if (index >= controller.invoiceHistory.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final record = controller.invoiceHistory[index];
        final bool isPaid = record.status.toLowerCase() == 'paid';
        final Color statusColor = isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444);

        // Format dates
        final String issuedStr = DateFormat('MMM dd, yyyy').format(record.issuedDate);
        String dueStr = 'On Receipt';
        if (record.dueDate != 'On Receipt') {
          if (record.dueDate == 'Custom Due Date') {
            dueStr = DateFormat('MMM dd, yyyy').format(record.issuedDate);
          } else {
            // Check if it's dynamic
            final days = int.tryParse(record.dueDate.split(' ')[0]) ?? 0;
            if (days > 0) {
              dueStr = DateFormat('MMM dd, yyyy').format(record.issuedDate.add(Duration(days: days)));
            } else {
              dueStr = record.dueDate;
            }
          }
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER DETAILS CARD ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: const Color(0xFF27272A),
                      child: Text(
                        record.clientName.isNotEmpty
                            ? record.clientName.trim().split(' ').map((e) => e[0]).take(2).join('').toUpperCase()
                            : 'C',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      record.clientName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (record.clientBusinessName.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        record.clientBusinessName,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD5C4AB),
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: const Color(0xFF1E1E1E),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'TOTAL AMOUNT',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD5C4AB),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'USD ${record.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        color: isPaid ? const Color(0xFFFEDB9B) : Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // --- INTERACTIVE STATUS TOGGLE ROW ---
              Text(
                'STATUS & SETTINGS',
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPaid ? Icons.check_circle_outline : Icons.error_outline,
                            color: statusColor,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPaid ? 'PAID' : 'UNPAID',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              isPaid ? 'Payment received' : 'Awaiting payment',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD5C4AB),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: isPaid,
                      activeThumbColor: const Color(0xFF10B981),
                      inactiveThumbColor: const Color(0xFFEF4444),
                      activeTrackColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                      inactiveTrackColor: const Color(0xFFEF4444).withValues(alpha: 0.2),
                      onChanged: (value) {
                        final updated = record.copyWith(status: value ? 'Paid' : 'Unpaid');
                        controller.invoiceHistory[index] = updated;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // --- DATES SECTION ---
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ISSUED DATE',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD5C4AB),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            issuedStr,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 35.h,
                      color: const Color(0xFF1E1E1E),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DUE DATE',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD5C4AB),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            dueStr,
                            style: GoogleFonts.inter(
                              color: Colors.white,
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
              SizedBox(height: 28.h),

              // --- ACTIONS HEADER ---
              Text(
                'ACTIONS',
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 10.h),

              // Action Buttons List
              _buildActionButton(
                icon: Icons.visibility_outlined,
                title: 'Preview Document',
                subtitle: 'View, share or print the generated PDF',
                onTap: () {
                  controller.populateFromRecord(record);
                  Get.to(() => const InvoicePreviewView());
                },
              ),
              SizedBox(height: 12.h),

              _buildActionButton(
                icon: Icons.edit_outlined,
                title: 'Edit / Customize',
                subtitle: 'Modify document entries or templates',
                onTap: () {
                  controller.populateFromRecord(record);
                  controller.editingRecordIndex.value = index;
                  Get.to(() => const CreateInvoiceView());
                },
              ),
              SizedBox(height: 12.h),

              _buildActionButton(
                icon: Icons.delete_outline,
                title: 'Delete Invoice',
                subtitle: 'Permanently remove from history',
                isDestructive: true,
                onTap: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color mainColor = isDestructive ? const Color(0xFFEF4444) : const Color(0xFFFEDB9B);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDestructive ? const Color(0xFFEF4444).withValues(alpha: 0.2) : const Color(0xFF1E1E1E),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isDestructive ? const Color(0xFFEF4444).withValues(alpha: 0.1) : const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: mainColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: isDestructive ? const Color(0xFFEF4444) : Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFD5C4AB),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: Color(0xFF364153)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  color: Color(0x1AEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever,
                  color: Color(0xFFEF4444),
                  size: 32,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Delete Invoice?',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Are you sure you want to permanently delete this invoice? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2C2C2C)),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.invoiceHistory.removeAt(index);
                        Get.back(); // close dialog
                        Get.back(); // close details page (returns to history view)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
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
}
