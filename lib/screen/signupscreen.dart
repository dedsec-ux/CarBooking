import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/signup.dart'; // Import the SignUpController

class SignUpScreen extends StatelessWidget {
  final SignUpController _controller = Get.put(SignUpController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            Obx(() {
              return TextField(
                onChanged: (value) => _controller.updateEmail(value),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  errorText: _controller.email.value.isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
              );
            }),
            SizedBox(height: 20),

            // Password input field
            Obx(() {
              return TextField(
                onChanged: (value) => _controller.updatePassword(value),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  errorText: _controller.password.value.isEmpty
                      ? 'Please enter your password'
                      : null,
                ),
              );
            }),
            SizedBox(height: 20),

            // Confirm Password input field
            Obx(() {
              return TextField(
                onChanged: (value) => _controller.updateConfirmPassword(value),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  errorText: _controller.confirmPassword.value.isEmpty
                      ? 'Please confirm your password'
                      : null,
                ),
              );
            }),
            SizedBox(height: 20),

            // Sign-Up button
            Obx(() {
              return ElevatedButton(
                onPressed: _controller.isLoading.value ? null : () {
                  // Validate fields before sign-up
                  if (_controller.email.value.isEmpty || _controller.password.value.isEmpty || _controller.confirmPassword.value.isEmpty) {
                    // Show error message
                    _controller.message.value = 'Please fill in all fields';
                  } else {
                    _controller.signUp(); // Proceed with sign-up
                  }
                },
                child: _controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 18),
                ),
              );
            }),
            SizedBox(height: 20),

            // Feedback message
            Obx(() {
              if (_controller.message.value.isNotEmpty) {
                return Text(
                  _controller.message.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: _controller.message.value.contains('successfully')
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              }
              return Container(); // Empty container when there's no message
            }),
          ],
        ),
      ),
    );
  }
}
