import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final inputUsername = usernameController.text.trim();
    final inputPassword = passwordController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username') ?? 'admin';
    final storedPassword = prefs.getString('password') ?? 'Pass@123';

    if (inputUsername == storedUsername && inputPassword == storedPassword) {
      // ✅ Save login data again if needed
      await prefs.setBool('isLoggedIn', true);

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Login Failed',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed(AppRoutes.login);
  }

  //FOUCUS NODE
    FocusNode? usernameFocus;
  FocusNode? passwordFocus;
  
  @override
  void onInit() {
    super.onInit();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
  }
  
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocus?.dispose();
    passwordFocus?.dispose();
    super.onClose();
  }

}
