import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersController extends GetxController {
  final List<String> members = [
    'Gokul',
    'Kavi',
    'Venu',
    'Mugil',
    'Kavin',
    'Akilan',
    'Mani'
  ];

  final Map<String, double> paidAmounts = {};
  final Map<String, TextEditingController> amountControllers = {};

  @override
  void onInit() {
    super.onInit();
    for (var member in members) {
      amountControllers[member] = TextEditingController();
      paidAmounts[member] = 0.0; // Initialize paid amounts
    }
  }

  void submitPayment(String member) {
    final controller = amountControllers[member];
    if (controller!.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final roomAmount = 5000.0;
    final currentPaid = paidAmounts[member] ?? 0.0;
    final newPaid = currentPaid + amount;

    if (newPaid > roomAmount) {
      Get.snackbar(
        'Error',
        'Amount cannot exceed room amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    paidAmounts[member] = newPaid;
    controller.clear();
    update();

    Get.snackbar(
      'Success',
      'Payment recorded successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    for (var controller in amountControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}