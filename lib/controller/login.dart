import 'package:app/screen/adminpanel.dart';
import 'package:app/screen/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = '';
  var password = '';
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to update email value
  void updateEmail(String value) {
    email = value;
  }

  // Function to update password value
  void updatePassword(String value) {
    password = value;
  }

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to handle login logic
  Future<void> login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoading.value = true;
      update();

      try {
        // Firebase login method
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the logged-in user
        User? user = userCredential.user;

        if (user != null) {
          // Check if the email is verified
          if (!user.emailVerified) {
            isLoading.value = false;
            update();
            Get.snackbar('Email Not Verified', 'Please verify your email before logging in.',
                snackPosition: SnackPosition.BOTTOM);
            // Optionally, you can send the user an email verification link
            await user.sendEmailVerification();
            return;
          }

          // Check if the user is an admin in Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          
          if (userDoc.exists) {
            bool isAdmin = userDoc.get('admin') ?? false; // Default to false if no 'admin' field exists

            isLoading.value = false;
            update();

            if (isAdmin) {
              // If admin, navigate to the admin screen
              Get.offAll(AdminPanelPage()); // Replace the login screen with the admin screen
            } else {
              // If not admin, navigate to the home screen
              Get.offAll(HomePage()); // Replace the login screen with the home screen
            }
          } else {
            // Handle case where user document is not found
            isLoading.value = false;
            update();
            Get.snackbar('Error', 'User data not found in Firestore', snackPosition: SnackPosition.BOTTOM);
          }
        }
      } catch (e) {
        isLoading.value = false;
        update();

        // On error
        Get.snackbar('Error', 'Invalid email or password', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', 'Please enter email and password', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
