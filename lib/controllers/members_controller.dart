import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../widgets/snack_bar.dart';

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

  double perPersonAmount = 5000.0; // Default value
  double totalPaid = 0.0;

  @override
  void onInit() {
    super.onInit();
    // Only initialize controllers if they haven't been created yet
    if (amountControllers.isEmpty) {
      for (var member in members) {
        amountControllers[member] = TextEditingController();
        paidAmounts[member] = 0.0; // Initialize paid amounts
      }
    }
    loadSettings();
  }

  void updateAmountController(String member) {
    final paidAmount = paidAmounts[member] ?? 0.0;
    final remaining = perPersonAmount - paidAmount;
    if (remaining > 0) {
      amountControllers[member]?.text = remaining.toStringAsFixed(0);
    } else {
      amountControllers[member]?.text = perPersonAmount.toStringAsFixed(0);
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
        }
        if (data['paidAmounts'] != null) {
          final paidData = data['paidAmounts'] as Map<String, dynamic>;
          for (var member in members) {
            paidAmounts[member] = (paidData[member] ?? 0.0).toDouble();
          }
        }
        totalPaid = (data['totalPaid'] ?? 0.0).toDouble();
        // Update amount controllers with remaining amounts
        for (var member in members) {
          updateAmountController(member);
        }
        update();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  void refreshData() {
    loadSettings();
    // Update all amount controllers after refresh
    for (var member in members) {
      updateAmountController(member);
    }
  }

  void submitPayment(dynamic context, String member) async {
    final controller = amountControllers[member];
    if (controller!.text.isEmpty) {
      AppSnackBar.error(context, 'Please enter an amount');
      return;
    }

    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) {
      AppSnackBar.error(context, 'Please enter a valid amount');
      return;
    }

    final roomAmount = perPersonAmount;
    final currentPaid = paidAmounts[member] ?? 0.0;
    final newPaid = currentPaid + amount;

    if (newPaid > roomAmount) {
      AppSnackBar.error(context, 'Amount cannot exceed room amount');
      return;
    }

    // Get current date and time
    final now = DateTime.now();
    final date = DateFormat('dd/MM/yyyy').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    // Add payment record to Firebase
    try {
      await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_MEMBER_AMOUNT_COLLECTION'] ?? 'room_member_amount')
          .add({
        'memberName': member,
        'date': date,
        'time': time,
        'perPersonAmount': perPersonAmount,
        'paidAmount': amount, // The amount paid in this transaction
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppSnackBar.error(context, 'Failed to record payment: $e');
      return;
    }

    paidAmounts[member] = newPaid;
    totalPaid += amount; // Add the payment amount to total paid
    updateAmountController(member); // Update the controller with remaining amount

    // Save updated paidAmounts and totalPaid to Firebase
    try {
      await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .set({
        'paidAmounts': paidAmounts,
        'totalPaid': totalPaid,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      AppSnackBar.error(context, 'Failed to save payment: $e');
      return;
    }

    update();

    AppSnackBar.success(context, 'Payment recorded successfully!');
  }

  @override
  void onClose() {
    // Don't dispose controllers here as they may be reused during hot reload
    // GetX will handle the disposal when the controller is actually destroyed
    super.onClose();
  }
}