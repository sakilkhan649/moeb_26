import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/modules/invoice/views/invoice_preview_view.dart';

class InvoiceHistoryRecord {
  final String invoiceNumber;
  final String clientName;
  final String clientEmail;
  final DateTime issuedDate;
  final String currency;
  final String status; // 'Paid', 'Unpaid'
  final double totalAmount;

  // New fields to preserve full invoice details
  final String clientBusinessName;
  final String clientPhone;
  final String clientStreetAddress;
  final String clientCity;
  final String clientState;
  final String clientZip;
  final String clientCountry;
  final String messageToClient;
  final String dueDate;
  final String businessName;
  final String businessEmail;
  final String businessPhone;
  final String businessAddress;
  final String businessLogoPath;

  InvoiceHistoryRecord({
    required this.invoiceNumber,
    required this.clientName,
    required this.clientEmail,
    required this.issuedDate,
    required this.currency,
    required this.status,
    required this.totalAmount,
    required this.clientBusinessName,
    required this.clientPhone,
    required this.clientStreetAddress,
    required this.clientCity,
    required this.clientState,
    required this.clientZip,
    required this.clientCountry,
    required this.messageToClient,
    required this.dueDate,
    required this.businessName,
    required this.businessEmail,
    required this.businessPhone,
    required this.businessAddress,
    required this.businessLogoPath,
  });

  InvoiceHistoryRecord copyWith({String? status}) {
    return InvoiceHistoryRecord(
      invoiceNumber: invoiceNumber,
      clientName: clientName,
      clientEmail: clientEmail,
      issuedDate: issuedDate,
      currency: currency,
      status: status ?? this.status,
      totalAmount: totalAmount,
      clientBusinessName: clientBusinessName,
      clientPhone: clientPhone,
      clientStreetAddress: clientStreetAddress,
      clientCity: clientCity,
      clientState: clientState,
      clientZip: clientZip,
      clientCountry: clientCountry,
      messageToClient: messageToClient,
      dueDate: dueDate,
      businessName: businessName,
      businessEmail: businessEmail,
      businessPhone: businessPhone,
      businessAddress: businessAddress,
      businessLogoPath: businessLogoPath,
    );
  }
}

class InvoiceController extends GetxController {
  // Navigation / Page Step
  var currentStep = 1.obs;
  var editingRecordIndex = (-1).obs;

  // Step 1: Basic Information
  late TextEditingController invoiceNumberController;
  late TextEditingController invoiceAmountController;
  var issuedDate = DateTime.now().obs;
  var selectedDueDateOption = 'On Receipt'.obs;
  var customDueDate = Rxn<DateTime>();
  var selectedCurrency = 'USD - US Dollar'.obs;

  // Step 2: Client Details
  late TextEditingController clientNameController;
  late TextEditingController clientBusinessNameController;
  late TextEditingController clientEmailController;
  late TextEditingController clientPhoneController;

  // Billing Address
  late TextEditingController clientStreetAddressController;
  late TextEditingController clientCityController;
  late TextEditingController clientStateController;
  late TextEditingController clientZipController;
  var clientCountry = 'United States'.obs;

  // Step 3: Message to Client
  late TextEditingController messageToClientController;

  // --- PROFILE SETTING FIELDS ---
  late TextEditingController businessNameController;
  late TextEditingController businessEmailController;
  late TextEditingController businessPhoneController;
  late TextEditingController businessAddressController;
  var businessLogoPath = RxnString();
  var savedBusinessName = 'Kali Ride LLC'.obs;

  // --- INVOICE HISTORY ---
  var invoiceHistory = <InvoiceHistoryRecord>[].obs;
  var selectedFilter = 'All'.obs;
  var selectedTemplateIndex = 0.obs;
  var selectedColorIndex = 0.obs;

  final List<Color> templateColors = [
    Colors.black, // White/Black theme
    const Color(0xFF2563EB), // Blue
    const Color(0xFF16A34A), // Green
    const Color(0xFFEA580C), // Orange
    const Color(0xFF7C3AED), // Purple
    const Color(0xFF0D9488), // Teal
    const Color(0xFF78350F), // Brown
  ];

  // Available options
  final List<String> dueDateOptions = ['On Receipt', 'Custom Due Date'];

  final List<String> currencyOptions = ['USD - US Dollar'];

  final List<String> countryOptions = [
    'United States',
    'Bangladesh',
    'United Kingdom',
    'Canada',
    'Germany',
    'India',
    'United Arab Emirates',
  ];

  @override
  void onInit() {
    super.onInit();
    invoiceNumberController = TextEditingController(text: 'Invoice 004');
    invoiceAmountController = TextEditingController(text: '0.00');

    // Step 2: Client Details
    clientNameController = TextEditingController();
    clientBusinessNameController = TextEditingController();
    clientEmailController = TextEditingController();
    clientPhoneController = TextEditingController();

    // Billing Address
    clientStreetAddressController = TextEditingController();
    clientCityController = TextEditingController();
    clientStateController = TextEditingController();
    clientZipController = TextEditingController();

    // Step 3: Message
    messageToClientController = TextEditingController();

    // Profile Settings controllers
    businessNameController = TextEditingController(text: 'Kali Ride LLC');
    businessEmailController = TextEditingController(text: 'Info@kaliride.com');
    businessPhoneController = TextEditingController(text: '5617793674');
    businessAddressController = TextEditingController(text: '');

    // Add mock invoice history records
    invoiceHistory.addAll([
      InvoiceHistoryRecord(
        invoiceNumber: 'Invoice 002',
        clientName: 'Acme Corp',
        clientEmail: 'billing@acme.com',
        issuedDate: DateTime.now().subtract(const Duration(days: 10)),
        currency: 'USD',
        status: 'Paid',
        totalAmount: 450.00,
        clientBusinessName: 'Acme Corp',
        clientPhone: '561-555-0199',
        clientStreetAddress: '100 Industrial Parkway',
        clientCity: 'Metropolis',
        clientState: 'NY',
        clientZip: '10001',
        clientCountry: 'United States',
        messageToClient: 'Thank you for your business!',
        dueDate: '15 days',
        businessName: 'Kali Ride LLC',
        businessEmail: 'Info@kaliride.com',
        businessPhone: '5617793674',
        businessAddress: '123 Luxury Road, Palm Beach, FL 33480',
        businessLogoPath: '',
      ),
      InvoiceHistoryRecord(
        invoiceNumber: 'Invoice 001',
        clientName: 'Globex Inc',
        clientEmail: 'accounts@globex.com',
        issuedDate: DateTime.now().subtract(const Duration(days: 25)),
        currency: 'USD',
        status: 'Paid',
        totalAmount: 120.00,
        clientBusinessName: 'Globex Inc',
        clientPhone: '800-555-0144',
        clientStreetAddress: '500 Corporate Blvd',
        clientCity: 'Gotham',
        clientState: 'NJ',
        clientZip: '07001',
        clientCountry: 'United States',
        messageToClient: 'Services rendered for month of May.',
        dueDate: '30 days',
        businessName: 'Kali Ride LLC',
        businessEmail: 'Info@kaliride.com',
        businessPhone: '5617793674',
        businessAddress: '123 Luxury Road, Palm Beach, FL 33480',
        businessLogoPath: '',
      ),
    ]);
  }

  @override
  void onClose() {
    invoiceNumberController.dispose();
    invoiceAmountController.dispose();
    clientNameController.dispose();
    clientBusinessNameController.dispose();
    clientEmailController.dispose();
    clientPhoneController.dispose();
    clientStreetAddressController.dispose();
    clientCityController.dispose();
    clientStateController.dispose();
    clientZipController.dispose();
    messageToClientController.dispose();

    businessNameController.dispose();
    businessEmailController.dispose();
    businessPhoneController.dispose();
    businessAddressController.dispose();
    super.onClose();
  }

  // Getters
  String get formattedIssuedDate =>
      DateFormat('MMM dd, yyyy').format(issuedDate.value);

  String get formattedDueDate {
    if (selectedDueDateOption.value == 'No Due Date') {
      return 'No Due Date';
    } else if (selectedDueDateOption.value == 'On Receipt') {
      return 'On Receipt';
    } else if (selectedDueDateOption.value == 'Custom Due Date') {
      if (customDueDate.value != null) {
        return DateFormat('MMM dd, yyyy').format(customDueDate.value!);
      }
      return 'Select Date';
    } else {
      // Days options like '10 days'
      final days = int.tryParse(selectedDueDateOption.value.split(' ')[0]) ?? 0;
      final dueDate = issuedDate.value.add(Duration(days: days));
      return DateFormat('MMM dd, yyyy').format(dueDate);
    }
  }

  // Actions
  void selectDueDateOption(String option, BuildContext context) async {
    selectedDueDateOption.value = option;
    if (option == 'Custom Due Date') {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            customDueDate.value ??
            issuedDate.value.add(const Duration(days: 1)),
        firstDate: issuedDate.value,
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFEDB9B), // Soft peach-yellow
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
              dialogTheme: const DialogThemeData(
                backgroundColor: Color(0xFF1E1E1E),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        customDueDate.value = picked;
      } else {
        // Fallback if cancelled
        selectedDueDateOption.value = 'On Receipt';
      }
    }
  }

  void pickIssuedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: issuedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFEDB9B), // Soft peach-yellow
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      issuedDate.value = picked;
      // Reset custom due date if it becomes before the issued date
      if (customDueDate.value != null &&
          customDueDate.value!.isBefore(issuedDate.value)) {
        customDueDate.value = null;
        selectedDueDateOption.value = 'On Receipt';
      }
    }
  }

  void nextStep() {
    if (currentStep.value == 1) {
      currentStep.value = 2;
    } else if (currentStep.value == 2) {
      currentStep.value = 3;
    } else if (currentStep.value == 3) {
      // submitInvoice();
      Get.to(() => const InvoicePreviewView());
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  // --- PROFILE ACTIONS ---
  Future<void> pickBusinessLogo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        businessLogoPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not access gallery: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveProfileSettings() {
    if (businessNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Business name is required.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    savedBusinessName.value = businessNameController.text.trim();

    Get.snackbar(
      'Success',
      'Profile settings saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFEDB9B), // Soft peach-yellow
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );

    Get.back(); // Return to settings page
  }

  void populateFromRecord(InvoiceHistoryRecord record) {
    invoiceNumberController.text = record.invoiceNumber;
    invoiceAmountController.text = record.totalAmount.toStringAsFixed(2);
    clientNameController.text = record.clientName;
    clientEmailController.text = record.clientEmail;
    issuedDate.value = record.issuedDate;
    final matchingCurrency = currencyOptions.firstWhere(
      (opt) => opt.startsWith(record.currency),
      orElse: () => currencyOptions.first,
    );
    selectedCurrency.value = matchingCurrency;

    clientBusinessNameController.text = record.clientBusinessName;
    clientPhoneController.text = record.clientPhone;
    clientStreetAddressController.text = record.clientStreetAddress;
    clientCityController.text = record.clientCity;
    clientStateController.text = record.clientState;
    clientZipController.text = record.clientZip;
    clientCountry.value = record.clientCountry;
    messageToClientController.text = record.messageToClient;
    selectedDueDateOption.value = record.dueDate;

    businessNameController.text = record.businessName;
    businessEmailController.text = record.businessEmail;
    businessPhoneController.text = record.businessPhone;
    businessAddressController.text = record.businessAddress;
    businessLogoPath.value = record.businessLogoPath;
  }

  void prepareNewInvoice() {
    editingRecordIndex.value = -1;
    invoiceAmountController.text = '0.00';
    clientNameController.clear();
    clientBusinessNameController.clear();
    clientEmailController.clear();
    clientPhoneController.clear();
    clientStreetAddressController.clear();
    clientCityController.clear();
    clientStateController.clear();
    clientZipController.clear();
    messageToClientController.clear();

    // Generate next invoice number based on history count
    final nextNum = invoiceHistory.isEmpty ? 1 : (invoiceHistory.length + 1);
    invoiceNumberController.text =
        'Invoice ${nextNum.toString().padLeft(3, '0')}';

    issuedDate.value = DateTime.now();
    selectedDueDateOption.value = 'On Receipt';
    customDueDate.value = null;
    currentStep.value = 1;
  }

  void deleteInvoice() {
    final wasEditing = editingRecordIndex.value != -1;
    if (wasEditing) {
      invoiceHistory.removeAt(editingRecordIndex.value);
    }
    
    // Reset fields for the next invoice
    invoiceAmountController.text = '0.00';
    clientNameController.clear();
    clientBusinessNameController.clear();
    clientEmailController.clear();
    clientPhoneController.clear();
    clientStreetAddressController.clear();
    clientCityController.clear();
    clientStateController.clear();
    clientZipController.clear();
    messageToClientController.clear();

    invoiceNumberController.text =
        'Invoice ${int.parse(invoiceNumberController.text.replaceAll(RegExp(r'\D'), '')) + 1}';
    currentStep.value = 1;
    editingRecordIndex.value = -1;

    Get.back(); // close preview screen
    Get.back(); // close create screen
    if (wasEditing) {
      Get.back(); // close details view screen
    }
    Get.snackbar(
      'Deleted',
      'Invoice has been deleted.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void submitInvoice() {
    final wasEditing = editingRecordIndex.value != -1;
    final double amount = double.tryParse(invoiceAmountController.text) ?? 0.0;

    final record = InvoiceHistoryRecord(
      invoiceNumber: invoiceNumberController.text.trim(),
      clientName: clientNameController.text.trim(),
      clientEmail: clientEmailController.text.trim(),
      issuedDate: issuedDate.value,
      currency: selectedCurrency.value.split(' ')[0],
      status: wasEditing
          ? invoiceHistory[editingRecordIndex.value].status
          : 'Unpaid',
      totalAmount: amount,
      clientBusinessName: clientBusinessNameController.text.trim(),
      clientPhone: clientPhoneController.text.trim(),
      clientStreetAddress: clientStreetAddressController.text.trim(),
      clientCity: clientCityController.text.trim(),
      clientState: clientStateController.text.trim(),
      clientZip: clientZipController.text.trim(),
      clientCountry: clientCountry.value,
      messageToClient: messageToClientController.text.trim(),
      dueDate: selectedDueDateOption.value,
      businessName: businessNameController.text.trim(),
      businessEmail: businessEmailController.text.trim(),
      businessPhone: businessPhoneController.text.trim(),
      businessAddress: businessAddressController.text.trim(),
      businessLogoPath: businessLogoPath.value ?? '',
    );

    if (wasEditing) {
      invoiceHistory[editingRecordIndex.value] = record;
    } else {
      invoiceHistory.insert(0, record);
    }

    // Success dialog
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF364153)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFD08700), // Bright orange-yellow
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                  size: 45,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                wasEditing ? 'Invoice Updated!' : 'Invoice Created!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                wasEditing
                    ? '${invoiceNumberController.text} has been successfully updated for ${clientNameController.text}.'
                    : '${invoiceNumberController.text} has been successfully created for ${clientNameController.text}.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Delete logic
                        if (wasEditing) {
                          invoiceHistory.removeAt(editingRecordIndex.value);
                        } else {
                          invoiceHistory.removeAt(0);
                        }

                        // Reset fields for the next invoice
                        invoiceAmountController.text = '0.00';
                        clientNameController.clear();
                        clientBusinessNameController.clear();
                        clientEmailController.clear();
                        clientPhoneController.clear();
                        clientStreetAddressController.clear();
                        clientCityController.clear();
                        clientStateController.clear();
                        clientZipController.clear();
                        messageToClientController.clear();

                        invoiceNumberController.text =
                            'Invoice ${int.parse(invoiceNumberController.text.replaceAll(RegExp(r'\D'), '')) + 1}';
                        currentStep.value = 1;
                        editingRecordIndex.value = -1;

                        Get.back(); // close dialog
                        Get.back(); // close preview screen
                        Get.back(); // close create screen (returns to history/detail screen)
                        if (wasEditing) {
                          Get.back(); // close details view screen
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C), // Dark gray
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save (Same as Done)
                        // Reset fields for the next invoice
                        invoiceAmountController.text = '0.00';
                        clientNameController.clear();
                        clientBusinessNameController.clear();
                        clientEmailController.clear();
                        clientPhoneController.clear();
                        clientStreetAddressController.clear();
                        clientCityController.clear();
                        clientStateController.clear();
                        clientZipController.clear();
                        messageToClientController.clear();

                        invoiceNumberController.text =
                            'Invoice ${int.parse(invoiceNumberController.text.replaceAll(RegExp(r'\D'), '')) + 1}';
                        currentStep.value = 1;
                        editingRecordIndex.value = -1;

                        Get.back(); // close dialog
                        Get.back(); // close preview screen
                        Get.back(); // close create screen (returns to history/detail screen)
                        if (wasEditing) {
                          Get.back(); // close details view screen
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD08700), // Bright orange-yellow
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
