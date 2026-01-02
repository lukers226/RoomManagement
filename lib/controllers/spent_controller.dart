import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpentController extends GetxController {
  String? selectedMember;
  String? selectedCategory;
  final TextEditingController amountController = TextEditingController();

  final List<String> members = [
    'Gokul',
    'Kavi',
    'Venu',
    'Mugil',
    'Kavin',
    'Akilan',
    'Mani'
  ];

  final List<String> categories = [
    'Vegetables',
    'Rice',
    'Masala',
    'Others',
    'Chicken'
  ];

  void submitExpense() {
    if (selectedMember == null || selectedCategory == null || amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Here you can add logic to save the expense
    // For now, just show a success message
    Get.snackbar(
      'Success',
      'Expense added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Reset form
    selectedMember = null;
    selectedCategory = null;
    amountController.clear();
    update();
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}