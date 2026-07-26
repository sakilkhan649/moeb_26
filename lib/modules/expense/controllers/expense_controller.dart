import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/expense_model.dart';

class ExpenseThemeData {
  final String name;
  final Color backgroundColor;
  final Color cardColor;
  final Color borderColor;
  final Color accentColor;

  const ExpenseThemeData({
    required this.name,
    required this.backgroundColor,
    required this.cardColor,
    required this.borderColor,
    required this.accentColor,
  });
}

class ExpenseController extends GetxController {
  var expenses = <ExpenseModel>[].obs;

  var selectedThemeIndex = 0.obs;

  final List<ExpenseThemeData> themes = [
    const ExpenseThemeData(
      name: 'Black & Gold',
      backgroundColor: Color(0xFF000000),
      cardColor: Color(0xFF161618),
      borderColor: Color(0xFF364153),
      accentColor: Color(0xFFD5C4AB),
    ),
    const ExpenseThemeData(
      name: 'Monochrome',
      backgroundColor: Color(0xFF000000),
      cardColor: Color(0xFF121212),
      borderColor: Color(0xFF444444),
      accentColor: Colors.white,
    ),
    const ExpenseThemeData(
      name: 'Amber Night',
      backgroundColor: Color(0xFF0D0B00),
      cardColor: Color(0xFF1F1B00),
      borderColor: Color(0xFFFFB703),
      accentColor: Color(0xFFFFB703),
    ),
    const ExpenseThemeData(
      name: 'Executive Navy',
      backgroundColor: Color(0xFF070E1A),
      cardColor: Color(0xFF0F1B2E),
      borderColor: Color(0xFF3A506B),
      accentColor: Color(0xFFE5C158),
    ),
    const ExpenseThemeData(
      name: 'Crimson VIP',
      backgroundColor: Color(0xFF140306),
      cardColor: Color(0xFF260A10),
      borderColor: Color(0xFF800F2F),
      accentColor: Color(0xFFFF4D6D),
    ),
  ];

  ExpenseThemeData get currentTheme => themes[selectedThemeIndex.value];

  // Input fields controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedCategory = 'Fuel'.obs;
  var selectedDate = DateTime.now().obs;
  var selectedImage = Rxn<File>();

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Add some sample mock expenses so that the list is populated when the user opens it
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
        category: 'Tolls',
        amount: 15.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Bridge toll on highway',
      ),
      ExpenseModel(
        id: '3',
        userId: 'user_1',
        category: 'Oil Change',
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

  // Calculate monthly total
  double get totalMonthlyExpenses {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
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
    selectedCategory.value = 'Fuel';
    selectedDate.value = DateTime.now();
    selectedImage.value = null;
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

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
