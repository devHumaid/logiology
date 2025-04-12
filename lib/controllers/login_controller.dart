import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode? usernameFocus;
  FocusNode? passwordFocus;

  @override
  void onInit() {
    super.onInit();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  // LOGIN

  void login() async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 3));

    final inputUsername = usernameController.text.trim();
    final inputPassword = passwordController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username') ?? 'admin';
    final storedPassword = prefs.getString('password') ?? 'Pass@123';

    if (inputUsername == storedUsername && inputPassword == storedPassword) {
      await prefs.setBool('isLoggedIn', true);
      final homeController = Get.find<HomeController>();
      homeController.loadProducts();
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Login Failed',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoading.value = false; // Set to false when login is finished
  }
  // void login() async {
  //   isLoading.value = true; // Start loading

  //   // Simulate a delay (for example, 3 seconds)
  //   await Future.delayed(Duration(seconds: 3));

  //   // Perform the actual login logic here
  //   final inputUsername = usernameController.text.trim();
  //   final inputPassword = passwordController.text.trim();

  //   final prefs = await SharedPreferences.getInstance();
  //   final storedUsername = prefs.getString('username') ?? 'admin';
  //   final storedPassword = prefs.getString('password') ?? 'Pass@123';

  //   if (inputUsername == storedUsername && inputPassword == storedPassword) {
  //     // Save login data again if needed
  //     await prefs.setBool('isLoggedIn', true);

  //     // After a successful login, stop loading and navigate
  //     isLoading.value = false;
  //     Get.offAllNamed(AppRoutes.home);
  //   } else {
  //     // If login fails, stop loading and show error
  //     isLoading.value = false;
  //     Get.snackbar(
  //       'Login Failed',
  //       'Invalid credentials',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.delete<LoginController>();

    // Navigation will now happen after a delay, so no need to do it here
    Get.offAllNamed(AppRoutes.login);
  }
}
