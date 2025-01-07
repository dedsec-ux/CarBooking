import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookNowController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Function to save the order to Firebase Firestore
  Future<void> saveOrder(BuildContext context,
      {required String carName,
      required String carModel,
      required String carImageUrl}) async {
    if (_validateForm(context)) {
      try {
        // Get and sanitize user input
        final name = nameController.text.trim();
        final age = int.parse(ageController.text.trim());
        final phone = phoneController.text.trim();
        final address = addressController.text.trim();

        // Default delivery status
        final deliveryStatus = 'Pending';

        // Save order to Firestore
        await _firestore.collection('orders').add({
          'name': name,
          'age': age,
          'phone': phone,
          'address': address,
          'car_name': carName,
          'car_model': carModel,
          'car_image': carImageUrl,
          'order_date': Timestamp.now(),
          'delivery_status': deliveryStatus,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!')),
        );

        // Clear fields
        _clearFields();
      } catch (e) {
        // Handle Firestore save error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    }
  }

  // Validate the form with more robust checks
  bool _validateForm(BuildContext context) {
    final name = nameController.text.trim();
    final ageText = ageController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    // Check for empty fields
    if (name.isEmpty || ageText.isEmpty || phone.isEmpty || address.isEmpty) {
      _showSnackBar(context, 'All fields are required.');
      return false;
    }

    // Check for valid age
    if (int.tryParse(ageText) == null || int.parse(ageText) <= 0) {
      _showSnackBar(context, 'Please enter a valid age.');
      return false;
    }

    // Check for valid phone number
    if (!RegExp(r'^\d{10,15}$').hasMatch(phone)) {
      _showSnackBar(context, 'Please enter a valid phone number (10-15 digits).');
      return false;
    }

    return true;
  }

  // Clear all text fields
  void _clearFields() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    addressController.clear();
  }

  // Show a SnackBar with the provided message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
