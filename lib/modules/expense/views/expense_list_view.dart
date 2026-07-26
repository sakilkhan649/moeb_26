import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomTextGary.dart';
import '../controllers/expense_controller.dart';
import '../models/expense_model.dart';
import 'add_expense_sheet.dart';
import 'expense_detail_sheet.dart';

class ExpenseListView extends GetView<ExpenseController> {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = controller.currentTheme;

      return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.borderColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: theme.backgroundColor,
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
                'Expense Tracker',
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
        body: SafeArea(
          child: Column(
            children: [
              // Top Summary Card
              _buildSummaryCard(theme),

              SizedBox(height: 10.h),

              // List title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "History",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextgray(
                      text: "${controller.expenses.length} records",
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),

              // Expense List
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (controller.expenses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: AppColors.gray100,
                              size: 60.sp,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "No expenses tracked yet",
                              style: GoogleFonts.inter(
                                color: AppColors.gray100,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = controller.expenses[index];
                        return _buildExpenseCard(context, expense, theme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Bottom Button to add new expense
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: CustomButton(
            text: "Track New Expense",
            backgroundColor: const Color(0xFFD08700),
            textColor: Colors.black,
            onPressed: () {
              controller.clearForm();
              Get.bottomSheet(
                AddExpenseSheet(),
                isScrollControlled: true,
                ignoreSafeArea: false,
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildSummaryCard(ExpenseThemeData theme) {
    return Container(
      margin: EdgeInsets.all(20.r),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, theme.cardColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Monthly Expenses",
                style: GoogleFonts.inter(
                  color: AppColors.gray100,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: GoogleFonts.inter(
                    color: theme.accentColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            "\$${controller.totalMonthlyExpenses.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: theme.accentColor,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  "All records kept locally on device",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(
    BuildContext context,
    ExpenseModel expense,
    ExpenseThemeData theme,
  ) {
    final dateStr = DateFormat('dd MMM yyyy').format(expense.date);

    // Category icon mapper
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

    return GestureDetector(
      onTap: () => Get.bottomSheet(
        ExpenseDetailSheet(expense: expense),
        isScrollControlled: true,
        ignoreSafeArea: false,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icon
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: theme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                getIcon(expense.category),
                color: theme.accentColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 15.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense.category,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${expense.amount.toStringAsFixed(2)}",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    dateStr,
                    style: GoogleFonts.inter(
                      color: AppColors.gray100,
                      fontSize: 11.sp,
                    ),
                  ),
                  if (expense.description.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      expense.description,
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (expense.receiptImageUrl != null) ...[
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: theme.accentColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Receipt attached",
                          style: GoogleFonts.inter(
                            color: theme.accentColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
