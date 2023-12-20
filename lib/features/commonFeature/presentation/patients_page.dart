import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment_form.dart'; // Make sure this import is correct
import 'package:rabwa/features/commonFeature/data/patient_repository.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class PatientPage extends StatelessWidget {
  final PatientsDatasource patientsDatasourceDatasource = PatientsDatasource();
  FirebaseFirestore? instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments Requests'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: patientsDatasourceDatasource
            .getMyPatients("wMF0085bfNUZjgzZRohR0p6rtHt1"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No patient found.');
          } else {
            List<Patient> patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                Patient patient = patients[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(patient.name![0]),
                    ),
                    title: Text(patient.name ?? 'Unnamed patient'),
                    subtitle: Text(
                      'Age: ${patient.age} | Weight: ${patient.weight} kg | Height: ${patient.height} cm',
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AppointmentForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
