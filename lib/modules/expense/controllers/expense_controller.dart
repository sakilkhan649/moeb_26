import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  var expenses = <ExpenseModel>[].obs;

  // Input fields controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // Selected state for form
  var selectedCategory = 'Fuel'.obs;
  var selectedDate = DateTime.now().obs;
  var selectedImage = Rxn<File>();

  // Filter states
  var filterPeriod = 'Monthly'.obs; // 'Monthly' or 'Yearly'
  var filterDate = DateTime.now().obs; // Tracks the selected month/year

  final ImagePicker _picker = ImagePicker();

  // Updated categories according to client requirements
  final List<String> categories = [
    'Fuel',
    'Oil Changes',
    'Tires',
    'Maintenance & Repairs',
    'Car Washes & Detailing',
    'Insurance',
    'Toll Expenses',
    'Parking',
    'Vehicle Payments',
    'Phone & Internet',
    'Water & Snacks for Clients',
    'Client Amenities',
    'Cleaning Supplies',
    'Licenses & Permits',
    'Business Insurance',
    'Marketing',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    populateMockExpenses();
  }

  void populateMockExpenses() {
    expenses.assignAll([
      ExpenseModel(
        id: '1',
        userId: 'user_1',
        category: 'Fuel',
        amount: 85.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Fuel up Mercedes S-Class',
      ),
      ExpenseModel(
        id: '2',
        userId: 'user_1',
        category: 'Toll Expenses',
        amount: 15.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Bridge toll on highway',
      ),
      ExpenseModel(
        id: '3',
        userId: 'user_1',
        category: 'Maintenance & Repairs',
        amount: 120.00,
        date: DateTime.now().subtract(const Duration(days: 15)),
        description: 'Regular maintenance at service center',
      ),
      ExpenseModel(
        id: '4',
        userId: 'user_1',
        category: 'Parking',
        amount: 25.00,
        date: DateTime.now().subtract(const Duration(days: 20)),
        description: 'Airport VIP parking lot',
      ),
    ]);
  }

  IconData getCategoryIcon(String category) {
    switch (category.trim()) {
      case 'Fuel':
        return Icons.local_gas_station_outlined;
      case 'Oil Changes':
        return Icons.opacity_outlined;
      case 'Tires':
        return Icons.album_outlined;
      case 'Maintenance & Repairs':
        return Icons.build_circle_outlined;
      case 'Car Washes & Detailing':
        return Icons.local_car_wash_outlined;
      case 'Insurance':
      case 'Business Insurance':
        return Icons.shield_outlined;
      case 'Toll Expenses':
        return Icons.toll_outlined;
      case 'Parking':
        return Icons.local_parking_outlined;
      case 'Vehicle Payments':
        return Icons.credit_card_outlined;
      case 'Phone & Internet':
        return Icons.phone_android_outlined;
      case 'Water & Snacks for Clients':
        return Icons.local_drink_outlined;
      case 'Client Amenities':
        return Icons.card_giftcard_outlined;
      case 'Cleaning Supplies':
        return Icons.cleaning_services_outlined;
      case 'Licenses & Permits':
        return Icons.assignment_outlined;
      case 'Marketing':
        return Icons.campaign_outlined;
      case 'Other':
      default:
        return Icons.receipt_outlined;
    }
  }

  // Filtered expenses based on selection
  List<ExpenseModel> get filteredExpenses {
    return expenses.where((e) {
      if (filterPeriod.value == 'Monthly') {
        return e.date.year == filterDate.value.year &&
            e.date.month == filterDate.value.month;
      } else {
        return e.date.year == filterDate.value.year;
      }
    }).toList();
  }

  // Filtered total amount
  double get filteredTotalAmount {
    return filteredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void toggleFilterPeriod() {
    if (filterPeriod.value == 'Monthly') {
      filterPeriod.value = 'Yearly';
    } else {
      filterPeriod.value = 'Monthly';
    }
  }

  void previousPeriod() {
    if (filterPeriod.value == 'Monthly') {
      filterDate.value = DateTime(
        filterDate.value.year,
        filterDate.value.month - 1,
      );
    } else {
      filterDate.value = DateTime(filterDate.value.year - 1);
    }
  }

  void nextPeriod() {
    if (filterPeriod.value == 'Monthly') {
      filterDate.value = DateTime(
        filterDate.value.year,
        filterDate.value.month + 1,
      );
    } else {
      filterDate.value = DateTime(filterDate.value.year + 1);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        imageQuality: 80,
        source: source,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory.value = categories.first;
    selectedDate.value = DateTime.now();
    selectedImage.value = null;
  }

  void loadExpenseForEdit(ExpenseModel expense) {
    amountController.text = expense.amount.toString();
    descriptionController.text = expense.description;
    selectedCategory.value = expense.category;
    selectedDate.value = expense.date;
    if (expense.receiptImageUrl != null &&
        expense.receiptImageUrl!.isNotEmpty) {
      selectedImage.value = File(expense.receiptImageUrl!);
    } else {
      selectedImage.value = null;
    }
  }

  void addExpense() {
    final amountText = amountController.text.trim();
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid amount",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newExpense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_1',
      category: selectedCategory.value,
      amount: amount,
      date: selectedDate.value,
      description: descriptionController.text.trim(),
      receiptImageUrl: selectedImage.value?.path,
    );

    expenses.insert(0, newExpense);
    clearForm();
    Get.back(); // close modal

    Get.snackbar(
      "Success",
      "Expense added successfully",
      backgroundColor: const Color(0xFFD08700),
      colorText: Colors.white,
    );
  }

  void updateExpense(ExpenseModel oldExpense) {
    final amountText = amountController.text.trim();
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid amount",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final updatedExpense = ExpenseModel(
      id: oldExpense.id,
      userId: oldExpense.userId,
      category: selectedCategory.value,
      amount: amount,
      date: selectedDate.value,
      description: descriptionController.text.trim(),
      receiptImageUrl: selectedImage.value?.path ?? oldExpense.receiptImageUrl,
    );

    final idx = expenses.indexWhere((e) => e.id == oldExpense.id);
    if (idx != -1) {
      expenses[idx] = updatedExpense;
    }
    clearForm();
    Get.back(); // close modal

    Get.snackbar(
      "Success",
      "Expense updated successfully",
      backgroundColor: const Color(0xFFD08700),
      colorText: Colors.white,
    );
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    Get.snackbar(
      "Deleted",
      "Expense deleted successfully",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  Future<void> exportToCSV() async {
    try {
      final csvContent = StringBuffer();
      csvContent.writeln('ID,Date,Category,Description,Amount');
      for (var e in filteredExpenses) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(e.date);
        final cleanCategory = e.category.replaceAll('"', '""');
        final cleanDesc = e.description.replaceAll('"', '""');
        csvContent.writeln(
          '${e.id},"$formattedDate","$cleanCategory","$cleanDesc",${e.amount}',
        );
      }

      final tempDir = Directory.systemTemp;
      final file = File(
        '${tempDir.path}/expense_report_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
      await file.writeAsString(csvContent.toString());

      await Printing.sharePdf(
        bytes: await file.readAsBytes(),
        filename:
            'expense_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      );
    } catch (e) {
      Get.snackbar(
        "Export Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _sanitizeForPdf(String text) {
    final buffer = StringBuffer();
    for (var char in text.runes) {
      if ((char >= 32 && char <= 126) ||
          (char >= 160 && char <= 255) ||
          char == 10 ||
          char == 13 ||
          char == 9) {
        buffer.writeCharCode(char);
      }
    }
    return buffer.toString().trim();
  }

  Future<void> exportToPDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Expense Tracker Report",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Category', 'Description', 'Amount (\$)'],
                data: filteredExpenses
                    .map(
                      (e) => [
                        DateFormat('dd MMM yyyy').format(e.date),
                        _sanitizeForPdf(e.category),
                        _sanitizeForPdf(e.description),
                        '\$${e.amount.toStringAsFixed(2)}',
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: \$${filteredTotalAmount.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name:
            'expense_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        "Export Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
