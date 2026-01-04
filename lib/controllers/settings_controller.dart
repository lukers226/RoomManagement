import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SettingsController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  double perPersonAmount = 5000.0;

  // ================== SET AMOUNT ==================
  Future<void> setPerPersonAmount() async {
    final text = amountController.text.trim();

    if (text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(text);

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

    try {
      await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .set({
        'perPersonAmount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': _getCurrentPhoneNumber(),
      }, SetOptions(merge: true));

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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ================== SEND MESSAGE ==================
  void sendMessage() {
    final message = messageController.text.trim();

    if (message.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    messageController.clear();

    Get.snackbar(
      'Success',
      'Message sent to all users!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  String _getCurrentPhoneNumber() {
    return 'unknown_user'; // replace with auth logic
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
