import 'package:app/screen/forgetpassword.dart'; // Import the ForgotPassword screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login.dart';
import 'signupscreen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController()); // Initialize controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextField(
              onChanged: (value) => _loginController.updateEmail(value),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Password input field with visibility toggle
            Obx(() {
              return TextField(
                onChanged: (value) => _loginController.updatePassword(value),
                obscureText: !_loginController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_loginController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _loginController.togglePasswordVisibility,
                  ),
                ),
              );
            }),
            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () => _loginController.login(),
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Forgot Password button
            TextButton(
              onPressed: () {
                Get.to(ForgotPasswordScreen()); // Navigate to ForgotPasswordScreen
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),

            // Sign Up button
            TextButton(
              onPressed: () {
                // Navigate to Sign Up Screen
                Get.to(SignUpScreen());
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
