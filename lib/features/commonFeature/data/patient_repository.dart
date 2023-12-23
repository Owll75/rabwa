import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/domain/medicine.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';



class PatientsDatasource {
  final CollectionReference PatientsCollection =
      FirebaseFirestore.instance.collection('Patient');
  final CollectionReference appointmentsCollection =
    FirebaseFirestore.instance.collection('Appointment');
  final CollectionReference medicinesCollection =
    FirebaseFirestore.instance.collection('Medicine');

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
      patientData['id'] = uniqueId.toString();

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
  Future<RichText> reviewAppointmentDetails(String patientId) async {
    try {
      // Fetch the appointment details
      final QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await FirebaseFirestore
          .instance
          .collection('Appointments')
          .where('patient_id', isEqualTo: patientId)
          .limit(1)
          .get();

      if (appointmentSnapshot.docs.isEmpty) {
        throw Exception("Appointment for this patient is not found");
      }

      final Appointment appointment = Appointment.fromMap(appointmentSnapshot.docs.first.data() as Map<String, dynamic>, appointmentSnapshot.docs.first.id);

      final QuerySnapshot medicineSnapshot = await medicinesCollection.where('patient_id', isEqualTo: appointment.patientId).get();
      final List<Medicine> medicines = medicineSnapshot.docs.map((doc) => Medicine.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      String medicationDetails = medicines.map((med) => "${med.name} (${med.dose})").join(", ");
      String asthmaControlLevel = appointment.getAsthmaControlLevel();
      String questionsAnsweredYes = appointment.getQuestionsAnswered();

      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: '${appointment.patientAge} year old ${appointment.patientGender} patient, known case of asthma, currently on $medicationDetails.',
            ),
            TextSpan(
              text: '\n\nFollowing up for asthma assessment and management.\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: questionsAnsweredYes,
            ),
            TextSpan(
              text: '\n\nAssessment:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' $asthmaControlLevel asthma',
            ),
            TextSpan(
              text: '\n\nPlan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' - As per the guidelines\n',
            ),
            // Here you would include additional details as needed
            // For example, location, time of appointment, doctor's notes, etc.
            // These details would need to be part of the Appointment object or retrieved from the database
          ],
        ),
      );
    } catch (e) {
      print('Error reviewing appointment details: $e');
      // Handle the error state, perhaps return an error widget
      return RichText(
        text: TextSpan(
          text: 'Error: Could not load appointment details.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
