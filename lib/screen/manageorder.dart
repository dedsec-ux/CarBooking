import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting dates

class ManageOrdersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              // Retrieve car and user details
              final carName = order['car_name'] ?? 'Unknown Car';
              final carModel = order['car_model'] ?? 'Unknown Model';
              final carImageUrl = order['car_image_url'] ?? 'https://via.placeholder.com/150'; // Fallback image
              final userName = order['name'] ?? 'N/A';
              final userAge = order['age']?.toString() ?? 'N/A';
              final userPhone = order['phone'] ?? 'N/A';
              final userAddress = order['address'] ?? 'N/A';
              final orderDate = _formatDate(order['order_date'] as Timestamp);

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          carImageUrl, // Car image
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Car Details
                      Text(
                        'Car Name: $carName',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Car Model: $carModel',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),

                      // User Details
                      Text(
                        'User Details:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Name: $userName'),
                      SizedBox(height: 8),
                      Text('Age: $userAge'),
                      SizedBox(height: 8),
                      Text('Phone: $userPhone'),
                      SizedBox(height: 8),
                      Text('Address: $userAddress'),
                      SizedBox(height: 16),

                      // Order Date
                      Text('Order Date: $orderDate'),
                      SizedBox(height: 16),

                      // Action Buttons: Reject or Deliver
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _handleOrder(context, orderId, 'Rejected'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text('Reject'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _handleOrder(context, orderId, 'Delivered'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text('Deliver'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to handle order (delete and show confirmation)
  Future<void> _handleOrder(BuildContext context, String orderId, String status) async {
    try {
      // Delete the order from Firestore
      await _firestore.collection('orders').doc(orderId).delete();

      // Show a snackbar with the status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $status successfully.'),
          backgroundColor: status == 'Delivered' ? Colors.green : Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error handling order: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Helper function to format Firestore Timestamp
  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(date); // Example: 2025-01-06 15:30
  }
}
