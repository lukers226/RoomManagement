import 'package:get/get.dart';

class LoginController extends GetxController {
  String phoneNumber = '';

  void login() {
    if (phoneNumber == '+919629923343') { // Example: India code +91 and the number
      Get.offNamed('/home');
    } else {
      Get.snackbar('Error', 'Invalid phone number');
    }
  }
}