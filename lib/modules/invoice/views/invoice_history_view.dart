import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/modules/invoice/views/invoice_settings_view.dart';
import '../../../config/routes/app_pages.dart';
import '../controllers/invoice_controller.dart';
import 'invoice_preview_view.dart';

class InvoiceHistoryView extends GetView<InvoiceController> {
  const InvoiceHistoryView({super.key});

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
            title: Text(
              'Invoice',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 22.sp,
                ),
                onPressed: () => Get.to(() => const InvoiceSettingsView()),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilters(),

          // List Content
          Expanded(
            child: Obx(() {
              // Apply dynamic filter
              final filteredList = controller.invoiceHistory.where((record) {
                if (controller.selectedFilter.value == 'All') return true;
                return record.status.toLowerCase() ==
                    controller.selectedFilter.value.toLowerCase();
              }).toList();

              if (filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: const Color(0xFF364153),
                        size: 64.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No invoices found',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFA1A1A1),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Create an invoice to get started.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF52525B),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: filteredList.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return _buildInvoiceCard(filteredList[index]);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 96.h,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
          ),
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.createInvoiceView),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24), // Amber/Yellow
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Create Invoice',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
        ),
        child: Row(
          children: ['All', 'Paid', 'Unpaid'].map((filter) {
            return Expanded(
              child: Obx(() {
                final isSelected = controller.selectedFilter.value == filter;
                return GestureDetector(
                  onTap: () => controller.selectedFilter.value = filter,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFBBF24)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.inter(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFFA1A1A1),
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceHistoryRecord record) {
    final bool isPaid = record.status.toLowerCase() == 'paid';
    final Color badgeColor = isPaid
        ? const Color(0xFF10B981) // Green
        : const Color(0xFFEF4444); // Red

    // Format due date representation
    String dueDateDisplay = 'No due date';
    if (record.dueDate != 'No Due Date') {
      if (record.dueDate == 'On Receipt') {
        dueDateDisplay = 'Due: On Receipt';
      } else if (record.dueDate == 'Custom Due Date') {
        dueDateDisplay =
            'Due: ${DateFormat('dd.MM.yy').format(record.issuedDate)}';
      } else {
        final days = int.tryParse(record.dueDate.split(' ')[0]) ?? 0;
        final dueDate = record.issuedDate.add(Duration(days: days));
        dueDateDisplay = 'Due date ${DateFormat('dd.MM.yy').format(dueDate)}';
      }
    }

    // Avatar initials
    final String initials = record.clientName.isNotEmpty
        ? record.clientName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join('')
              .toUpperCase()
        : 'C';

    return GestureDetector(
      onTap: () {
        // Populate controller with this record's details to preview it
        controller.invoiceNumberController.text = record.invoiceNumber;
        controller.invoiceAmountController.text = record.totalAmount
            .toStringAsFixed(2);
        controller.clientNameController.text = record.clientName;
        controller.clientEmailController.text = record.clientEmail;
        controller.issuedDate.value = record.issuedDate;
        controller.selectedCurrency.value =
            '${record.currency} - ${record.currency}';

        controller.clientBusinessNameController.text =
            record.clientBusinessName;
        controller.clientPhoneController.text = record.clientPhone;
        controller.clientStreetAddressController.text =
            record.clientStreetAddress;
        controller.clientCityController.text = record.clientCity;
        controller.clientStateController.text = record.clientState;
        controller.clientZipController.text = record.clientZip;
        controller.clientCountry.value = record.clientCountry;
        controller.messageToClientController.text = record.messageToClient;
        controller.selectedDueDateOption.value = record.dueDate;

        controller.businessNameController.text = record.businessName;
        controller.businessEmailController.text = record.businessEmail;
        controller.businessPhoneController.text = record.businessPhone;
        controller.businessAddressController.text = record.businessAddress;
        controller.businessLogoPath.value = record.businessLogoPath;

        Get.to(() => const InvoicePreviewView());
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF111111), // Dark premium card background
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Client Avatar/Initials
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFF27272A),
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // Middle: Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.clientName,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    record.invoiceNumber,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFA1A1A1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: const Color(0xFFA1A1A1),
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        dueDateDisplay,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFA1A1A1),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right: Status & Amount Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    record.status.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: badgeColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                // Amount
                Text(
                  '${record.currency == 'USD' ? '\$' : '${record.currency} '}${record.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFBBF24), // Amber/Yellow
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
