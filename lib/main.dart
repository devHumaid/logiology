import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logiology/routes/app_routes.dart';
import 'package:logiology/screens/home_screen.dart';
import 'package:logiology/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = await _getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOGIOLOGY',
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: AppRoutes.login, page: () => LoginScreen()),
        GetPage(name: AppRoutes.home, page: () => HomeScreen()),
        GetPage(name: AppRoutes.profile, page: () => ProfileScreen()),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

Future<String> _getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn ? AppRoutes.home : AppRoutes.login;
}
