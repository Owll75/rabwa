import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment_form.dart'; // Make sure this import is correct
import 'package:rabwa/features/commonFeature/data/patient_repository.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class PatientPage extends StatefulWidget {
  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final PatientsDatasource patientsDatasourceDatasource = PatientsDatasource();

  FirebaseFirestore? instance;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Patients'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: patientsDatasourceDatasource.getMyPatients(user!.uid),
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
          showAddDialog(context, "add", addToMyPatient);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  addToMyPatient(String id) async {
    String? patientDocID =
        await patientsDatasourceDatasource.getDocIDPatientById(id);
    if (patientDocID != null)
      patientsDatasourceDatasource.updatePatientDoctorID(
          patientDocID, user!.uid);
    setState(() {
      // This will trigger a rebuild of the widget, so it can reflect the updated data
    });
  }

  void showAddDialog(
      BuildContext context, String actionLabel, Function(String) onAddAction) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String inputId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add $actionLabel"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: '$actionLabel ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ID';
                }
                return null;
              },
              onSaved: (value) {
                inputId = value!;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Call the provided action with the input ID
                  onAddAction(inputId);
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
