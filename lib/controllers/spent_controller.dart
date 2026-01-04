import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/snack_bar.dart';

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

  void submitExpense(dynamic context) async {
    if (selectedMember == null || selectedCategory == null || amountController.text.isEmpty) {
      AppSnackBar.error(context, 'Please fill all fields');
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

      // Update totalPaid by subtracting the expense amount
      final expenseAmount = double.parse(amountController.text);
      await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .update({
        'totalPaid': FieldValue.increment(-expenseAmount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppSnackBar.success(context, 'Expense added successfully!');

      // Reset form
      selectedMember = null;
      selectedCategory = null;
      amountController.clear();
      update();
    } catch (e) {
      AppSnackBar.error(context, 'Failed to add expense: $e');
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}