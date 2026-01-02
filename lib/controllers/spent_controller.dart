import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  void submitExpense() async {
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

    try {
      // Save to Firestore
      await FirebaseFirestore.instance.collection(dotenv.env['EXPENSES_COLLECTION'] ?? 'expenses').add({
        'member': selectedMember,
        'category': selectedCategory,
        'amount': double.parse(amountController.text),
        'date': DateTime.now().toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });

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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add expense: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}