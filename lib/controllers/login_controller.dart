import 'package:get/get.dart';
import 'package:room/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController extends GetxController {
  String phoneNumber = '';
  bool isLoggedIn = false;
  String userType = 'normal';

  // Get admin phone numbers from environment variables
  List<String> get allowedPhoneNumbers {
    final adminPhonesString = dotenv.env['ADMIN_PHONE_NUMBERS'] ?? '';
    return adminPhonesString.split(',').map((e) => e.trim()).toList();
  }

  // Get normal user phone numbers from environment variables
  List<String> get normalUserPhoneNumbers {
    final normalPhonesString = dotenv.env['NORMAL_USER_PHONE_NUMBERS'] ?? '';
    return normalPhonesString.split(',').map((e) => e.trim()).toList();
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('logged_in_phone');
    final savedType = prefs.getString('user_type') ?? 'normal';
    if (savedPhone != null && (allowedPhoneNumbers.contains(savedPhone) || normalUserPhoneNumbers.contains(savedPhone))) {
      phoneNumber = '+$savedPhone'; // Add + prefix for consistency
      userType = savedType;
      isLoggedIn = true;
      Get.put(this, permanent: true);
      Get.offNamed('/home');
    }
  }

  void login() {
    // Extract the number without country code for comparison
    final numberWithoutCode = phoneNumber.replaceAll('+91', '').replaceAll('+', '');

    if (allowedPhoneNumbers.contains(numberWithoutCode)) {
      userType = 'admin';
    } else if (normalUserPhoneNumbers.contains(numberWithoutCode)) {
      userType = 'normal';
    } else {
      AppSnackBar.error(Get.context!, 'This phone number is not authorized to access the app');
      return;
    }

    // Save login status
    _saveLoginStatus(numberWithoutCode, userType);

    // Make this controller permanent so it can be accessed from other controllers
    Get.put(this, permanent: true);
    Get.offNamed('/home');
  }

  Future<void> _saveLoginStatus(String phone, String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_phone', phone);
    await prefs.setString('user_type', type);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_phone');
    await prefs.remove('user_type');
    phoneNumber = '';
    userType = 'normal';
    isLoggedIn = false;
    Get.offNamed('/login');
  }
}