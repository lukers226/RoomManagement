import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_controller.dart';

class SettingsController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  double perPersonAmount = 5000.0; // Default value

  // Get admin phone numbers from environment variables
  List<String> get adminPhoneNumbers {
    final adminPhonesString = dotenv.env['ADMIN_PHONE_NUMBERS'] ?? '';
    return adminPhonesString.split(',').map((e) => e.trim()).toList();
  }

  bool _isAdmin = false;

  @override
  void onInit() {
    super.onInit();
    checkAdminStatus();
    loadSettings();
  }

  void checkAdminStatus() {
    try {
      final loginController = Get.find<LoginController>();
      // Extract number without country code for comparison
      final numberWithoutCode = loginController.phoneNumber
          .replaceAll('+91', '')
          .replaceAll('+', '');
      _isAdmin = adminPhoneNumbers.contains(numberWithoutCode);
      print('Admin status checked: $_isAdmin, Phone: ${loginController.phoneNumber}');
    } catch (e) {
      _isAdmin = false;
      print('LoginController not found during init: $e');
    }
  }

  Future<void> loadSettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['perPersonAmount'] != null) {
          perPersonAmount = data['perPersonAmount'].toDouble();
          update();
        }
      }
    } catch (e) {
      // If loading fails, keep the default value
      print('Error loading settings: $e');
    }
  }

  void setPerPersonAmount() async {
    // Check if user is admin
    if (!_isAdmin) {
      Get.snackbar(
        'Access Denied',
        'Only the admin can update the per person amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

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

    try {
      // Save to Firebase Firestore
      await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .set({
        'perPersonAmount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': _getCurrentPhoneNumber(),
      }, SetOptions(merge: true)); // Use merge to update only this field

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
        'Failed to update amount: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void sendMessage() async {
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

    try {
      final message = messageController.text.trim();

      // Save message to Firebase Firestore
      await FirebaseFirestore.instance.collection(dotenv.env['MESSAGES_COLLECTION'] ?? 'messages').add({
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'sender': 'admin', // You can replace this with actual user info
        'type': 'room_announcement',
      });

      messageController.clear();

      Get.snackbar(
        'Success',
        'Message sent to all users!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _getCurrentPhoneNumber() {
    try {
      final loginController = Get.find<LoginController>();
      return loginController.phoneNumber;
    } catch (e) {
      return 'unknown';
    }
  }

  bool isCurrentUserAdmin() {
    return _isAdmin;
  }
}