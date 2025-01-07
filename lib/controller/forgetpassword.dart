import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  var email = ''.obs; // Observable email field
  var isLoading = false.obs; // Observable loading state
  var message = ''.obs; // Observable message for feedback

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to update email
  void updateEmail(String value) {
    email.value = value;
  }

  // Method to send password reset email
  Future<void> resetPassword() async {
    if (email.value.isEmpty) {
      message.value = 'Please enter a valid email address.';
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.value);
      message.value = 'Password reset email sent! Check your inbox.';
    } catch (e) {
      message.value = 'Error: ${e.toString()}';
    }
    isLoading.value = false;
  }
}
