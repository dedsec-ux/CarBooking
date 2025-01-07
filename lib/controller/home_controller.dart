import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch cars stream from the 'cars' collection
  Stream<List<Map<String, dynamic>>> getCarsStream() {
    return _firestore.collection('cars').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          // ignore: unnecessary_cast
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }
}
