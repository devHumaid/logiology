import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logiology/controllers/home_controller.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  // Create focus nodes in the controller instead
  LoginScreen({super.key}) {
    // Initialize focus nodes if they don't exist in the controller
    if (loginController.usernameFocus == null) {
      loginController.usernameFocus = FocusNode();
    }
    if (loginController.passwordFocus == null) {
      loginController.passwordFocus = FocusNode();
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: NotificationListener<ScrollNotification>(
          // This prevents scroll notification from causing keyboard dismissal
          onNotification: (ScrollNotification notification) {
            return true;
          },
          child: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4267B2),
                      Color(0xFF8BB3F4),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/background1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Scrollable content with form
              Center(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: w * 0.9,
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: w * 0.5,
                                height: 100,
                                child: SvgPicture.asset(
                                  'assets/logo2.svg',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 30),

                            // Username field
                            TextFormField(
                              controller: loginController.usernameController,
                              focusNode: loginController.usernameFocus,
                              textInputAction: TextInputAction
                                  .next, // Important for keyboard behavior
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                    loginController.passwordFocus);
                              },
                              decoration: InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF4267B2), width: 2),
                                ),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.grey),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Password field
                            TextFormField(
                              controller: loginController.passwordController,
                              focusNode: loginController.passwordFocus,
                              obscureText: true,
                              textInputAction: TextInputAction
                                  .done, // Important for keyboard behavior
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF4267B2), width: 2),
                                ),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.grey),
                              ),
                            ),

                            SizedBox(height: 45),

                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    loginController.login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4267B2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
