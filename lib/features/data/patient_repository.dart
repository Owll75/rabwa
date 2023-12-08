
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/domain/patient.dart';

class PatientsDatasource {
  final CollectionReference PatientsCollection =
      FirebaseFirestore.instance.collection('Patient');
  Future<List<Patient>> getPatients() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Patient').get();
          
      final List<Patient> patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return Patient(
          hight:  (data['hight'] ?? 0.0).toDouble(),
          age: data['age'] ?? 0,
          name:data['name'] ?? '',
          //needs to link with ref
          // doctor:data['doctor'] ?? '',
          weight:(data['weight'] ?? 0.0).toDouble(),
        );
      }).toList();
      return patients;
    } catch (e) {
      print('Error fetching patient: $e');
      return [];
    }
  }
}
