import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var message = ''.obs;
  var isLoading = false.obs;

  void updateEmail(String value) {
    email.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  // Sign-up method
  Future<void> signUp() async {
    if (email.value.isEmpty || password.value.isEmpty || confirmPassword.value.isEmpty) {
      message.value = 'Please fill in all fields';
      return;
    }

    if (password.value != confirmPassword.value) {
      message.value = 'Passwords do not match';
      return;
    }

    isLoading.value = true;

    try {
      // Sign up user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Add the user to Firestore with the 'admin' field set to false
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email.value,
        'admin': false, // Default admin value
        'createdAt': FieldValue.serverTimestamp(), // Optional: Timestamp for when the user was created
      });

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      isLoading.value = false;
      message.value = 'Sign-up successful! Please verify your email';

      // Show feedback to the user
      Get.snackbar('Success', 'Verify your email to complete registration');

      // Delay and navigate to the Login screen
      Future.delayed(Duration(seconds: 2), () {
        Get.toNamed('/login'); // Navigate to the Login screen
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      // Handle errors
      if (e.code == 'email-already-in-use') {
        message.value = 'The email is already in use';
      } else if (e.code == 'weak-password') {
        message.value = 'The password is too weak';
      } else {
        message.value = 'An error occurred: ${e.message}';
      }
    } catch (e) {
      isLoading.value = false;
      message.value = 'An unexpected error occurred: $e';
    }
  }
}
