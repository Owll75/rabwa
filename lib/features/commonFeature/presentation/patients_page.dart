import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment_form.dart'; // Update this import as needed
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No patients found.');
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
                      child: Text(patient.name![0]), // Assuming patient name is not null here
                    ),
                    title: Text(patient.name ?? 'Unnamed patient'),
                    subtitle: Text(
                      'Age: ${patient.age} | Weight: ${patient.weight} kg | Height: ${patient.height} cm',
                    ),
                    onTap: () async {
                      // Assuming patient ID is stored in patient.docId
                      // You need to ensure the patient ID is passed correctly here
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Use FutureBuilder to wait for the async operation to complete
                          return FutureBuilder<RichText>(
                            future: patientsDatasourceDatasource.reviewAppointmentDetails(patient.docId!),
                            builder: (BuildContext context, AsyncSnapshot<RichText> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 100,
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Could not load details: ${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                return AlertDialog(
                                  title: Text('Appointment Details'),
                                  content: SingleChildScrollView(child: snapshot.data!),
                                );
                              } else {
                                return AlertDialog(
                                  title: Text('No Data'),
                                  content: Text('No details are available for this patient.'),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
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
