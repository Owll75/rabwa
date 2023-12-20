import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

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
          parentID: data['parent_id'],
          height: (data['height'] ?? 0.0).toDouble(),
          age: data['age'] ?? 0,
          name: data['name'] ?? '',
          doctor: data['doctor'] ?? '',
          weight: (data['weight'] ?? 0.0).toDouble(),
        );
      }).toList();
      return patients;
    } catch (e) {
      print('Error fetching patient: $e');
      return [];
    }
  }

  Future<List<Patient>> getMyPatients(String doctorID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await PatientsCollection.where('doctor_id', isEqualTo: doctorID).get()
              as QuerySnapshot<Map<String, dynamic>>; // Cast the result

      final List<Patient> patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return Patient(
          docId: doc.id,
          height: (data['height'] ?? 0.0).toDouble(),
          age: data['age'] ?? 0,
          name: data['name'] ?? '',
          doctor: data['doctor'] ?? '',
          weight: (data['weight'] ?? 0.0).toDouble(),
          parentID: data['parent_id'],
        );
      }).toList();
      return patients; // Use non-null assertion for data
    } catch (e) {
      print('Error fetching  patients: $e');
      return [];
    }
  }

  Future<List<Patient>> getPatientsByParentId(String parentId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Patient')
          .where('parent_id',
              isEqualTo:
                  parentId) // This assumes there's a 'parentId' field in the document
          .get();

      final List<Patient> patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return Patient(
          docId: doc.id,
          height: (data['height'] ?? 0.0).toDouble(),
          age: data['age'] ?? 0,
          name: data['name'] ?? '',
          //needs to link with ref
          // doctor:data['doctor'] ?? '',
          weight: (data['weight'] ?? 0.0).toDouble(),
          parentID: data['parent_id'],
        );
      }).toList();
      return patients;
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      await PatientsCollection.add(patient.toMap());
      print('Patient added successfully');
    } catch (e) {
      print('Error adding patient: $e');
    }
  }

  Future<bool> doesPatientExistWithParentId(String parentId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Patients')
        .where('parent_id', isEqualTo: parentId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<String?> getDocIDPatientById(String id) async {
    try {
      print(id);
      print("-------------------------------------------------");
      final querySnapshot = await FirebaseFirestore.instance
          .collection(
              'Patient') // Ensure this matches your actual collection name
          .where('id',
              isEqualTo: id) // 'id' should be the field name in Firestore
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("Document ID: ${querySnapshot.docs.first.id}");
        print("-------------------------------------------------");

        return querySnapshot.docs.first.id;
      } else {
        print("No patient found with ID $id");
        return null; // Return null if no patient is found
      }
    } catch (e) {
      print('Error fetching patient by ID: $e');
      return null; // Return null in case of an error
    }
  }

  Future<void> updatePatientDoctorID(String docId, String doctorDocId) async {
    try {
      print("======================-=================UpdatePatientDoctorID");
      await PatientsCollection.doc(docId).update({'doctor_id': doctorDocId});
      print('Patient age updated successfully');
    } catch (e) {
      print('Error updating patient: $e');
    }
  }
}
