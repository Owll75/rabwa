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

  Future<void> createDoctor(Doctor doctor) async {
    try {
      await DoctorsCollection.doc(doctor.docId).set(doctor.toMap());
      print('Doctor created successfully with ID: ${doctor.docId}');
    } catch (e) {
      print('Error creating doctor: $e');
    }
  }

  Future<Doctor?> getDoctorByDocId(String docId) async {
    try {
      // Get a reference to the 'Users' collection
      CollectionReference doctors =
          FirebaseFirestore.instance.collection('Doctors');

      // Get the document reference by the specific document ID
      DocumentReference userDoc = doctors.doc(docId);

      // Get the document snapshot
      DocumentSnapshot<Object?> snapshot = await userDoc.get();

      // Check if the snapshot contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Create a User object from the data
        Doctor doctor = Doctor.fromMap(snapshot.data() as Map<String, dynamic>);
        return doctor;
      } else {
        print('No data found for user with ID $docId');
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null; // Return null if the user is not found or an error occurs
  }
}
