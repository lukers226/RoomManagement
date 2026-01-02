import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  double perPersonAmount = 5000.0; // Default value

  void setPerPersonAmount() {
    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(amountController.text);
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

    perPersonAmount = amount;
    amountController.clear();
    update();

    Get.snackbar(
      'Success',
      'Per person amount updated to ₹${amount.toStringAsFixed(0)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Here you can add logic to send the message to all users
    // For now, just show a success message
    final message = messageController.text.trim();
    messageController.clear();

    Get.snackbar(
      'Success',
      'Message sent to all users!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // TODO: Implement actual message sending logic
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}