import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/bottom_nav_screen.dart';
import 'controllers/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = '/splash';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('logged_in_phone');

    // Get admin phone numbers from environment variables
    final adminPhonesString = dotenv.env['ADMIN_PHONE_NUMBERS'] ?? '';
    final allowedPhoneNumbers = adminPhonesString.split(',').map((e) => e.trim()).toList();

    if (savedPhone != null && allowedPhoneNumbers.contains(savedPhone)) {
      // Create and register LoginController for logged-in users
      final loginController = LoginController();
      loginController.phoneNumber = '+$savedPhone';
      loginController.isLoggedIn = true;
      Get.put(loginController, permanent: true);

      setState(() {
        initialRoute = '/home';
      });
    } else {
      setState(() {
        initialRoute = '/login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Room App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/splash', page: () => const SplashView()),
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/home', page: () => const BottomNavScreen()),
      ],
    );
  }
}
