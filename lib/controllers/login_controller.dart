import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController extends GetxController {
  String phoneNumber = '';
  bool isLoggedIn = false;

  // Get admin phone numbers from environment variables
  List<String> get allowedPhoneNumbers {
    final adminPhonesString = dotenv.env['ADMIN_PHONE_NUMBERS'] ?? '';
    return adminPhonesString.split(',').map((e) => e.trim()).toList();
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('logged_in_phone');
    if (savedPhone != null && allowedPhoneNumbers.contains(savedPhone)) {
      phoneNumber = '+$savedPhone'; // Add + prefix for consistency
      isLoggedIn = true;
      Get.put(this, permanent: true);
      Get.offNamed('/home');
    }
  }

  void login() {
    // Extract the number without country code for comparison
    final numberWithoutCode = phoneNumber.replaceAll('+91', '').replaceAll('+', '');

    if (allowedPhoneNumbers.contains(numberWithoutCode)) {
      // Save login status
      _saveLoginStatus(numberWithoutCode);

      // Make this controller permanent so it can be accessed from other controllers
      Get.put(this, permanent: true);
      Get.offNamed('/home');
    } else {
      Get.snackbar('Error', 'This phone number is not authorized to access the app');
    }
  }

  Future<void> _saveLoginStatus(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_phone', phone);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_phone');
    phoneNumber = '';
    isLoggedIn = false;
    Get.offNamed('/login');
  }
}