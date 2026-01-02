import 'package:get/get.dart';

class SplashController extends GetxController {
  double opacity = 0.0;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity = 1.0;
      update();
    });

    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
  }
}