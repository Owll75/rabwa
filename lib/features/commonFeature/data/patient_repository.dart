import 'dart:math';

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
      // Generate a unique ID starting from 10000
      int uniqueId = 10000 + Random().nextInt(90000); // Random number between 10000 and 99999

      // Add the unique ID to the patient data
      Map<String, dynamic> patientData = patient.toMap();
      patientData['id'] = uniqueId;

      // Use the custom ID when adding the patient to the collection
      await PatientsCollection.doc(uniqueId.toString()).set(patientData);
      
      print('Patient added successfully with ID: $uniqueId');
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
}
