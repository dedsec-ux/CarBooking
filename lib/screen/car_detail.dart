import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/car_detail.dart';
import 'booknow.dart';

class CarDetailPage extends StatelessWidget {
  final CarDetailController _carDetailController = CarDetailController();

  @override
  Widget build(BuildContext context) {
    // Retrieve carId from Get.arguments
    final carId = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _carDetailController.getCarDetails(carId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Safely check if data exists
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Car details not found.'));
          }

          // Extract car details safely
          final carDetails = snapshot.data!.data() as Map<String, dynamic>?;

          if (carDetails == null) {
            return Center(child: Text('Car details are missing.'));
          }

          // Extract car attributes
          final carName = carDetails['name'] ?? 'Unknown Car';
          final carModel = carDetails['model'] ?? 'Unknown Model';
          final carPrice = carDetails['price'] ?? 'N/A';
          final carImageUrl = carDetails['image_url'] ?? 'https://via.placeholder.com/500';
          final carDescription = carDetails['description'] ?? 'No description available.';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      carImageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Car Name
                  Text(
                    carName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Car Model
                  Text(
                    'Model: $carModel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Car Price
                  Text(
                    'Price: \$${carPrice.toString()}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Car Description Title
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Car Description
                  Text(
                    carDescription,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      // "Book Now" Button at the Bottom
      bottomNavigationBar: FutureBuilder<DocumentSnapshot>(
        future: _carDetailController.getCarDetails(carId),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox.shrink(); // Return an empty widget when no data
          }

          // Extract car details safely
          final carDetails = snapshot.data!.data() as Map<String, dynamic>?;

          final carName = carDetails?['name'] ?? 'Unknown Car';
          final carModel = carDetails?['model'] ?? 'Unknown Model';
          final carImageUrl = carDetails?['image_url'] ?? 'https://via.placeholder.com/500';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to BookNowPage and pass car details
                Get.to(
                  () => BookNowPage(),
                  arguments: {
                    'car_name': carName,
                    'car_model': carModel,
                    'car_image_url': carImageUrl,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Book Now'),
            ),
          );
        },
      ),
    );
  }
}
