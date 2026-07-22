import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../controllers/invoice_controller.dart';

class InvoicePreviewView extends GetView<InvoiceController> {
  const InvoicePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
              'Customize',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulated A4 PDF Sheet Card (with strict A4 aspect ratio 1:1.414)
            AspectRatio(
              aspectRatio: 1 / 1.414,
              child: Obx(() {
                final templateIndex = controller.selectedTemplateIndex.value;
                final colorIndex = controller.selectedColorIndex.value;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFF27272A),
                      width: 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: PdfPreview(
                    build: (format) async {
                      final doc = pw.Document();

                      // Prepare logo image if available
                      pw.ImageProvider? logoImage;
                      final logoPath = controller.businessLogoPath.value;
                      if (logoPath != null &&
                          logoPath.isNotEmpty &&
                          File(logoPath).existsSync()) {
                        try {
                          logoImage = pw.MemoryImage(
                            File(logoPath).readAsBytesSync(),
                          );
                        } catch (e) {
                          debugPrint('Error loading logo: $e');
                        }
                      }

                      final selectedColor =
                          controller.templateColors[colorIndex];
                      final pdfAccentColor = PdfColor.fromInt(
                        selectedColor.toARGB32(),
                      );

                      doc.addPage(
                        pw.Page(
                          pageFormat: PdfPageFormat.a4,
                          margin: const pw.EdgeInsets.all(40),
                          build: (pw.Context context) {
                            if (templateIndex == 0) {
                              return _buildDeltaPdfLayout(
                                logoImage,
                                pdfAccentColor,
                              );
                            } else if (templateIndex == 1) {
                              return _buildModernPdfLayout(
                                logoImage,
                                pdfAccentColor,
                              );
                            } else {
                              return _buildSplitPdfLayout(
                                logoImage,
                                pdfAccentColor,
                              );
                            }
                          },
                        ),
                      );
                      return doc.save();
                    },
                    useActions: false,
                    allowPrinting: false,
                    allowSharing: false,
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    canDebug: false,
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD08700),
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Template Selector Row Label
            SizedBox(height: 12.h),
            _buildSectionHeader('Template Options'),
            SizedBox(height: 12.h),

            // Horizontal Template Previews
            _buildTemplateSelector(),
            SizedBox(height: 24.h),

            // Color Selector Row Label
            _buildSectionHeader('Theme Accent Color'),
            SizedBox(height: 12.h),

            // Horizontal Color Selector Row
            _buildColorSelector(),
            SizedBox(height: 30.h),
          ],
        ),
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
            onTap: () => _downloadPdf(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFD08700), // Bright orange-yellow
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD08700).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Send Invoice',
                style: GoogleFonts.inter(
                  color: Colors.black, // Dark text for contrast
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

  // --- COMPONENT HEADERS ---
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // --- TEMPLATE SELECTOR LIST ---
  Widget _buildTemplateSelector() {
    final templates = ['Delta', 'Modern', 'Split'];
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: templates.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final name = templates[index];
          return Obx(() {
            final isSelected = controller.selectedTemplateIndex.value == index;
            final activeColor =
                controller.templateColors[controller.selectedColorIndex.value];
            return GestureDetector(
              onTap: () => controller.selectedTemplateIndex.value = index,
              child: Container(
                width: 110.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD08700) // Bright orange-yellow
                        : const Color(0xFF27272A),
                    width: isSelected ? 1.w : .5.w,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.12,
                        child: _buildMiniTemplatePreview(index, activeColor),
                      ),
                    ),
                    Center(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFD5C4AB),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMiniTemplatePreview(int index, Color color) {
    if (index == 0) {
      return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 16.w, height: 16.w, color: Colors.white),
                Container(width: 24.w, height: 8.h, color: Colors.white),
              ],
            ),
            SizedBox(height: 6.h),
            Container(width: 40.w, height: 6.h, color: Colors.white30),
            Container(width: 30.w, height: 6.h, color: Colors.white30),
          ],
        ),
      );
    } else if (index == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 12.h, width: double.infinity, color: color),
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 36.w, height: 6.h, color: Colors.white),
                SizedBox(height: 4.h),
                Container(width: 24.w, height: 6.h, color: Colors.white30),
              ],
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(6.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 14.w, height: 14.w, color: Colors.white),
                  SizedBox(height: 4.h),
                  Container(width: 24.w, height: 6.h, color: Colors.white30),
                ],
              ),
            ),
            Container(width: 2.w, height: double.infinity, color: color),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 24.w, height: 6.h, color: Colors.white),
                  SizedBox(height: 4.h),
                  Container(width: 16.w, height: 6.h, color: Colors.white30),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // --- COLOR SELECTOR ROW ---
  Widget _buildColorSelector() {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: controller.templateColors.length,
        separatorBuilder: (context, index) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          final color = controller.templateColors[index];
          return Obx(() {
            final isSelected = controller.selectedColorIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectedColorIndex.value = index,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: color == Colors.black ? Colors.white : color,
                  borderRadius: BorderRadius.circular(8.r),
                  border: isSelected
                      ? Border.all(
                          color: const Color(0xFFD08700),
                          width: 1.w,
                        ) // Bright orange-yellow
                      : Border.all(color: const Color(0xFF374151), width: .5.w),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // --- DYNAMIC PDF GENERATOR ENGINE ---
  void _downloadPdf(BuildContext context) async {
    final doc = pw.Document();

    // Prepare logo image if available
    pw.ImageProvider? logoImage;
    final logoPath = controller.businessLogoPath.value;
    if (logoPath != null &&
        logoPath.isNotEmpty &&
        File(logoPath).existsSync()) {
      try {
        logoImage = pw.MemoryImage(File(logoPath).readAsBytesSync());
      } catch (e) {
        debugPrint('Error loading logo: $e');
      }
    }

    final selectedColor =
        controller.templateColors[controller.selectedColorIndex.value];
    final pdfAccentColor = PdfColor.fromInt(selectedColor.toARGB32());
    final templateIndex = controller.selectedTemplateIndex.value;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          if (templateIndex == 0) {
            return _buildDeltaPdfLayout(logoImage, pdfAccentColor);
          } else if (templateIndex == 1) {
            return _buildModernPdfLayout(logoImage, pdfAccentColor);
          } else {
            return _buildSplitPdfLayout(logoImage, pdfAccentColor);
          }
        },
      ),
    );

    final pdfBytes = await doc.save();

    // Open direct native share dialog (which includes download, share, print options)
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename:
          'invoice_${controller.invoiceNumberController.text.isNotEmpty ? controller.invoiceNumberController.text.replaceAll(RegExp(r'\s+'), '_') : "999"}.pdf',
    );

    // Save to history and display success
    controller.submitInvoice();
  }

  // PDF LAYOUT 0: Delta (Classic)
  pw.Widget _buildDeltaPdfLayout(
    pw.ImageProvider? logoImage,
    PdfColor accentColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfLogo(logoImage),
                  pw.Text(
                    controller.savedBusinessName.value,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    controller.businessEmailController.text.isNotEmpty
                        ? controller.businessEmailController.text
                        : 'info@business.com',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Text(
                    controller.businessPhoneController.text.isNotEmpty
                        ? controller.businessPhoneController.text
                        : '000 000 0000',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  controller.invoiceNumberController.text.isNotEmpty
                      ? controller.invoiceNumberController.text.toUpperCase()
                      : 'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Container(height: 1.5, color: accentColor),
        pw.SizedBox(height: 20),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('DATE ISSUED'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.formattedIssuedDate,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (controller.selectedDueDateOption.value != 'No Due Date') ...[
                    pw.SizedBox(height: 16),
                    _buildPdfMetadataLabel('DUE DATE'),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      controller.formattedDueDate,
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('BILLED TO'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.clientNameController.text.isNotEmpty
                        ? controller.clientNameController.text
                        : 'Client Name',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  _buildPdfOptionalText(
                    controller.clientBusinessNameController.text,
                  ),
                  _buildPdfOptionalText(controller.clientEmailController.text),
                  _buildPdfOptionalText(controller.clientPhoneController.text),
                  _buildPdfOptionalText(controller.clientWebsiteController.text),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        _buildPdfBillingAddress(),
        pw.Spacer(flex: 1),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 12),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey300, width: 1.5),
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 1.5),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Amount Due',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${controller.selectedCurrency.value.split(" ")[0]} ${controller.invoiceAmountController.text}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        _buildPdfNotes(),
        pw.Spacer(flex: 2),
        _buildPdfSignatureSection(),
        pw.Spacer(flex: 2),
        _buildPdfFooter(),
      ],
    );
  }

  // PDF LAYOUT 1: Modern
  // PDF LAYOUT 1: Modern Minimalist
  pw.Widget _buildModernPdfLayout(
    pw.ImageProvider? logoImage,
    PdfColor accentColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildPdfLogo(logoImage),
                pw.SizedBox(width: 10),
                pw.Container(width: 3, height: 40, color: accentColor),
                pw.SizedBox(width: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      controller.savedBusinessName.value,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      controller.businessEmailController.text.isNotEmpty
                          ? controller.businessEmailController.text
                          : 'info@business.com',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  controller.invoiceNumberController.text.isNotEmpty
                      ? controller.invoiceNumberController.text.toUpperCase()
                      : 'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Container(height: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 20),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('FROM'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.savedBusinessName.value,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  _buildPdfOptionalText(
                    controller.businessPhoneController.text,
                  ),
                  pw.SizedBox(height: 12),
                  _buildPdfMetadataLabel('DATES'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Issued: ${controller.formattedIssuedDate}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  if (controller.selectedDueDateOption.value != 'No Due Date')
                    pw.Text(
                      'Due: ${controller.formattedDueDate}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('BILLED TO'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.clientNameController.text.isNotEmpty
                        ? controller.clientNameController.text
                        : 'Client Name',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  _buildPdfOptionalText(
                    controller.clientBusinessNameController.text,
                  ),
                  _buildPdfOptionalText(controller.clientEmailController.text),
                  _buildPdfOptionalText(controller.clientPhoneController.text),
                  _buildPdfOptionalText(controller.clientWebsiteController.text),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        _buildPdfBillingAddress(),
        pw.Spacer(flex: 1),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(color: accentColor, width: 3),
            ),
            color: PdfColors.grey100,
          ),
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Amount Due',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${controller.selectedCurrency.value.split(" ")[0]} ${controller.invoiceAmountController.text}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        _buildPdfNotes(),
        pw.Spacer(flex: 2),
        _buildPdfSignatureSection(),
        pw.Spacer(flex: 2),
        _buildPdfFooter(),
      ],
    );
  }

  // PDF LAYOUT 2: Centered Classic
  pw.Widget _buildSplitPdfLayout(
    pw.ImageProvider? logoImage,
    PdfColor accentColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Column(
            children: [
              _buildPdfLogo(logoImage),
              pw.Text(
                controller.savedBusinessName.value.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                controller.invoiceNumberController.text.isNotEmpty
                    ? controller.invoiceNumberController.text.toUpperCase()
                    : 'INVOICE',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Container(height: 1, color: accentColor),
        pw.SizedBox(height: 20),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('BILLED TO'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.clientNameController.text.isNotEmpty
                        ? controller.clientNameController.text
                        : 'Client Name',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  _buildPdfOptionalText(
                    controller.clientBusinessNameController.text,
                  ),
                  _buildPdfOptionalText(controller.clientEmailController.text),
                  _buildPdfOptionalText(controller.clientPhoneController.text),
                  _buildPdfOptionalText(controller.clientWebsiteController.text),
                  pw.SizedBox(height: 12),
                  _buildPdfBillingAddress(),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPdfMetadataLabel('INVOICE DETAILS'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Issued: ${controller.formattedIssuedDate}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  if (controller.selectedDueDateOption.value != 'No Due Date')
                    pw.Text(
                      'Due: ${controller.formattedDueDate}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  pw.SizedBox(height: 12),
                  _buildPdfMetadataLabel('CONTACT INFO'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    controller.businessEmailController.text.isNotEmpty
                        ? controller.businessEmailController.text
                        : 'info@business.com',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                  _buildPdfOptionalText(
                    controller.businessPhoneController.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Spacer(flex: 1),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: accentColor, width: 1),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'TOTAL AMOUNT DUE',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                '${controller.selectedCurrency.value.split(" ")[0]} ${controller.invoiceAmountController.text}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        _buildPdfNotes(),
        pw.Spacer(flex: 2),
        _buildPdfSignatureSection(),
        pw.Spacer(flex: 2),
        _buildPdfFooter(),
      ],
    );
  }

  // --- PDF SUB-COMPONENT BUILDERS ---

  pw.Widget _buildPdfLogo(pw.ImageProvider? logoImage) {
    if (logoImage != null) {
      return pw.Container(
        width: 80,
        height: 80,
        margin: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Image(logoImage, fit: pw.BoxFit.cover),
      );
    } else {
      return pw.Container(
        width: 80,
        height: 80,
        color: PdfColors.black,
        margin: const pw.EdgeInsets.only(bottom: 8),
        alignment: pw.Alignment.center,
        child: pw.Text(
          controller.savedBusinessName.value.isNotEmpty
              ? controller.savedBusinessName.value.substring(0, 1).toUpperCase()
              : 'K',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
    }
  }

  pw.Widget _buildPdfMetadataLabel(String label) {
    return pw.Text(
      label,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey600,
      ),
    );
  }

  pw.Widget _buildPdfOptionalText(String text) {
    if (text.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 2),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
      ),
    );
  }

  pw.Widget _buildPdfBillingAddress() {
    final street = controller.clientStreetAddressController.text;
    final city = controller.clientCityController.text;
    final state = controller.clientStateController.text;
    final zip = controller.clientZipController.text;
    final country = controller.clientCountry.value;

    if (street.isEmpty && city.isEmpty && state.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfMetadataLabel('BILLING ADDRESS'),
        pw.SizedBox(height: 4),
        pw.Text(
          '$street${street.isNotEmpty ? ", " : ""}$city${city.isNotEmpty ? ", " : ""}$state${state.isNotEmpty ? " " : ""}$zip\n$country',
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
            lineSpacing: 1.4,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfNotes() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfMetadataLabel('NOTE / MESSAGE TO CLIENT'),
        pw.SizedBox(height: 4),
        pw.Text(
          controller.messageToClientController.text.isNotEmpty
              ? controller.messageToClientController.text
              : 'Thank you for doing business with us! Please pay the invoice before the due date.',
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey800,
            fontStyle: pw.FontStyle.italic,
            lineSpacing: 1.4,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfSignatureSection() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            controller.savedBusinessName.value,
            style: pw.TextStyle(
              fontSize: 14,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey700,
            ),
          ),
          pw.Container(
            width: 150,
            height: 1,
            color: PdfColors.grey400,
            margin: const pw.EdgeInsets.symmetric(vertical: 4),
          ),
          pw.Text(
            'Authorized Signature',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooter() {
    final number = controller.invoiceNumberController.text.isNotEmpty
        ? controller.invoiceNumberController.text
        : "999";
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
        ),
      ),
      child: pw.Text(
        'Receipt $number   Page 1 of 1',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }
}
