import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/invoice_controller.dart';

class CreateInvoiceView extends GetView<InvoiceController> {
  const CreateInvoiceView({super.key});

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
              onPressed: () => controller.previousStep(),
            ),
            title: Text(
              'Create Invoice',
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
      body: Obx(() {
        return Column(
          children: [
            // Progress Bar / Step Info
            _buildProgressBar(),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: _buildStepContent(context),
              ),
            ),

            // Bottom Buttons
            _buildBottomButtons(context),
          ],
        );
      }),
    );
  }

  // --- PROGRESS BAR ---
  Widget _buildProgressBar() {
    double progress = 0.33;
    String stepTitle = 'Basic Information';
    int percentage = 33;

    if (controller.currentStep.value == 2) {
      progress = 0.66;
      stepTitle = 'Client Details';
      percentage = 66;
    } else if (controller.currentStep.value == 3) {
      progress = 1.0;
      stepTitle = 'Message Details';
      percentage = 100;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${controller.currentStep.value} of 3 - $stepTitle',
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD08700), // Bright orange-yellow
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP CONTENTS ---
  Widget _buildStepContent(BuildContext context) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildStep1(context);
      case 2:
        return _buildStep2(context);
      case 3:
        return _buildStep3(context);
      default:
        return _buildStep1(context);
    }
  }

  // STEP 1: Basic Information
  Widget _buildStep1(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Invoice Number
        _buildFieldLabel('Invoice number*'),
        _buildInputField(
          controller: controller.invoiceNumberController,
          hint: 'e.g. Invoice 001',
          suffixIcon: Icon(
            Icons.notes,
            color: const Color(0xFFD5C4AB),
            size: 20.sp,
          ),
        ),
        SizedBox(height: 20.h),

        // Invoice Amount
        _buildFieldLabel('Invoice amount*'),
        _buildInputField(
          controller: controller.invoiceAmountController,
          hint: '0.00',
          prefixText: 'USD ',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: 20.h),

        // Issued Date
        _buildFieldLabel('Issued'),
        GestureDetector(
          onTap: () => controller.pickIssuedDate(context),
          child: AbsorbPointer(
            child: _buildInputField(
              controller: TextEditingController(
                text: controller.formattedIssuedDate,
              ),
              hint: 'Select Date',
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: const Color(0xFFD5C4AB),
                size: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Due Date
        _buildFieldLabel('Due date'),
        _buildDueDateSection(context),
        SizedBox(height: 20.h),

        // Currency
        _buildFieldLabel('Currency'),
        _buildCurrencyDropdown(context),
        SizedBox(height: 10.h),
      ],
    );
  }

  // STEP 2: Client Details
  Widget _buildStep2(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- CLIENT INFORMATION ---
        Text(
          'CLIENT INFORMATION',
          style: GoogleFonts.inter(
            color: const Color(0xFFD5C4AB),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16.h),

        // Client Name
        _buildFieldLabel('Client Name*'),
        _buildInputField(
          controller: controller.clientNameController,
          hint: 'e.g. Johnathan Smith',
        ),
        SizedBox(height: 16.h),

        // Business Name
        _buildFieldLabel('Business Name (Optional)'),
        _buildInputField(
          controller: controller.clientBusinessNameController,
          hint: 'e.g. Smith & Associates',
        ),
        SizedBox(height: 16.h),

        // Email Address
        _buildFieldLabel('Email Address*'),
        _buildInputField(
          controller: controller.clientEmailController,
          hint: 'client@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),

        // Phone Number
        _buildFieldLabel('Phone Number (Optional)'),
        _buildInputField(
          controller: controller.clientPhoneController,
          hint: 'e.g. 555-000-0000',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 24.h),

        // --- BILLING ADDRESS ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BILLING ADDRESS',
              style: GoogleFonts.inter(
                color: const Color(0xFFD5C4AB),
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Icon(
              Icons.map_outlined,
              color: const Color(0xFFD5C4AB),
              size: 20.sp,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Street Address
        _buildFieldLabel('Street Address'),
        _buildInputField(
          controller: controller.clientStreetAddressController,
          hint: '123 Luxury Avenue',
        ),
        SizedBox(height: 16.h),

        // City & State Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('City'),
                  _buildInputField(
                    controller: controller.clientCityController,
                    hint: 'Beverly Hills',
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('State/Province'),
                  _buildInputField(
                    controller: controller.clientStateController,
                    hint: 'CA',
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Zip & Country Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('ZIP/Postal Code'),
                  _buildInputField(
                    controller: controller.clientZipController,
                    hint: '90210',
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Country'),
                  _buildCountryDropdown(context),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  // STEP 3: Message to Client
  Widget _buildStep3(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Message to Client Card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Optional',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD5C4AB),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                height: 180.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: controller.messageToClientController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Briefly describe the work or add a personal note to your client...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF4B5563),
                      fontSize: 14.sp,
                    ),
                    contentPadding: EdgeInsets.all(14.w),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- REUSABLE UI BUILDERS ---

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFD5C4AB),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111), // Dark container background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixStyle: GoogleFonts.inter(
            color: const Color(0xFFD5C4AB),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF4B5563),
            fontSize: 15.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: maxLines > 1 ? 12.h : 16.h,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildDueDateSection(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: controller.dueDateOptions.map((option) {
        final isSelected = controller.selectedDueDateOption.value == option;

        // Label logic for Custom Due Date representation
        String displayLabel = option;
        if (option == 'Custom Due Date' &&
            controller.customDueDate.value != null) {
          displayLabel = controller.formattedDueDate;
        }

        return GestureDetector(
          onTap: () => controller.selectDueDateOption(option, context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFEDB9B) : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFEDB9B)
                    : const Color(0xFF1E1E1E),
                width: 1.5,
              ),
            ),
            child: Text(
              displayLabel,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedCurrency.value,
          dropdownColor: const Color(0xFF111111),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: const Color(0xFFD5C4AB),
            size: 24.sp,
          ),
          isExpanded: true,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (newValue) {
            if (newValue != null) {
              controller.selectedCurrency.value = newValue;
            }
          },
          items: controller.currencyOptions.map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.clientCountry.value,
          dropdownColor: const Color(0xFF111111),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: const Color(0xFFD5C4AB),
            size: 24.sp,
          ),
          isExpanded: true,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (newValue) {
            if (newValue != null) {
              controller.clientCountry.value = newValue;
            }
          },
          items: controller.countryOptions.map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  // --- BOTTOM BUTTONS ---
  Widget _buildBottomButtons(BuildContext context) {
    final bool isLastStep = controller.currentStep.value == 3;
    final String nextButtonText = isLastStep ? 'Preview' : 'Next';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      child: Row(
        children: [
          // Back Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.previousStep(),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF1E1E1E),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),

          // Next/Create Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.nextStep(),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16.h),
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
                  nextButtonText,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
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
