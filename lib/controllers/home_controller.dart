import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  double totalPaid = 0.0;
  List<Map<String, dynamic>> expenses = [];
  int daysToShow = 10;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([loadTotalPaid(), loadExpenses()]);
  }

  Future<void> loadTotalPaid() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(dotenv.env['ROOM_SETTINGS_COLLECTION'] ?? 'room_settings')
          .doc('main_settings')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        totalPaid = (data['totalPaid'] ?? 0.0).toDouble();
      }
      update();
    } catch (e) {
      debugPrint('Error loading totalPaid: $e');
    }
  }

  Future<void> loadExpenses() async {
    try {
      final now = DateTime.now();
      final cutoffDate = now.subtract(Duration(days: daysToShow));

      final querySnapshot = await FirebaseFirestore.instance
          .collection(dotenv.env['EXPENSES_COLLECTION'] ?? 'expenses')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoffDate))
          .orderBy('timestamp', descending: true)
          .get();

      expenses = querySnapshot.docs.map((doc) => doc.data()).toList();
      update();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    }
  }

  void loadMoreExpenses() {
    daysToShow += 10;
    loadExpenses();
  }

  void refreshData() {
    loadData();
  }
}