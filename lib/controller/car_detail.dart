import 'package:cloud_firestore/cloud_firestore.dart';

class CarDetailController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch car details from Firestore
  Future<DocumentSnapshot> getCarDetails(String carId) async {
    try {
      // Fetch the car document from the 'cars' collection using carId
      DocumentSnapshot carDoc = await _firestore.collection('cars').doc(carId).get();
      return carDoc;
    } catch (e) {
      throw Exception('Failed to fetch car details: $e');
    }
  }
}
