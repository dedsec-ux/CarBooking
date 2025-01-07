import 'package:cloud_firestore/cloud_firestore.dart';

class CarController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCar(Map<String, dynamic> carData) async {
    try {
      await _firestore.collection('cars').add(carData);
      print('Car added successfully');
    } catch (e) {
      print('Error adding car: $e');
    }
  }

  Future<void> editCar(String carId, Map<String, dynamic> carData) async {
    try {
      await _firestore.collection('cars').doc(carId).update(carData);
      print('Car updated successfully');
    } catch (e) {
      print('Error updating car: $e');
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
      print('Car deleted successfully');
    } catch (e) {
      print('Error deleting car: $e');
    }
  }

  Stream<QuerySnapshot> getCarsStream() {
    return _firestore.collection('cars').snapshots();
  }
}
