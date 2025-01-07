import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookNowController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> saveOrder(
    BuildContext context, {
    required String carName,
    required String carModel,
    required String carImageUrl,
  }) async {
    try {
      final name = nameController.text;
      final age = int.tryParse(ageController.text) ?? 0;
      final phone = phoneController.text;
      final address = addressController.text;

      if (name.isEmpty || age <= 0 || phone.isEmpty || address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields correctly.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('orders').add({
        'name': name,
        'age': age,
        'phone': phone,
        'address': address,
        'car_name': carName,
        'car_model': carModel,
        'car_image_url': carImageUrl,
        'order_date': Timestamp.now(),
        'delivery_status': 'Pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      nameController.clear();
      ageController.clear();
      phoneController.clear();
      addressController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }
}

class BookNowPage extends StatelessWidget {
  final BookNowController _controller = BookNowController();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final carName = arguments['car_name'] ?? 'Unknown Car';
    final carModel = arguments['car_model'] ?? 'Unknown Model';
    final carImageUrl = arguments['car_image_url'] ?? 'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Now'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car: $carName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Model: $carModel',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Image.network(carImageUrl),
            SizedBox(height: 16),
            TextFormField(
              controller: _controller.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _controller.ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _controller.phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _controller.addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _controller.saveOrder(
                  context,
                  carName: carName,
                  carModel: carModel,
                  carImageUrl: carImageUrl,
                );
              },
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
