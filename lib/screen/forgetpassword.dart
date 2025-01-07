import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/forgetpassword.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController _controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instruction text
            Text(
              'Enter your email address to receive a password reset link:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Email input field
            Obx(() {
              return TextField(
                onChanged: (value) => _controller.updateEmail(value),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  errorText: _controller.email.value.isEmpty ? 'Email is required' : null,
                ),
                keyboardType: TextInputType.emailAddress,
              );
            }),
            SizedBox(height: 20),

            // Reset Password button
            Obx(() {
              return ElevatedButton(
                onPressed: _controller.isLoading.value ? null : _controller.resetPassword,
                child: _controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Reset Password'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 18),
                ),
              );
            }),
            SizedBox(height: 20),

            // Message feedback
            Obx(() {
              return Text(
                _controller.message.value,
                style: TextStyle(
                  fontSize: 14,
                  color: _controller.message.value.contains('sent') ? Colors.green : Colors.red,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
