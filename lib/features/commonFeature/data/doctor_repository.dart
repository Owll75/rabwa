import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';

class DoctorDatasource {
  final CollectionReference DoctorsCollection =
      FirebaseFirestore.instance.collection('Doctors');
  Future<List<Doctor>> getDoctors() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Doctors').get();

      final List<Doctor> doctors = snapshot.docs.map((doc) {
        final data = doc.data();
        return Doctor(
          name: data['name'] ?? '',
          age: data['age'] ?? 0,
        );
      }).toList();
      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }
}
