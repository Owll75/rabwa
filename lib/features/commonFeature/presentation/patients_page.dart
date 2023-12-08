
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/patient_repository.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class PatientPage extends StatelessWidget {
  final PatientsDatasource patientsDatasourceDatasource = PatientsDatasource();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: patientsDatasourceDatasource.getPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data
            return Text('No patient found.');
          } else {
            // If data is available, display it
            List<Patient> patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                Patient patient = patients[index];
                return ListTile(
                  title: Text(patient.name ?? 'Unnamed patient'),
                  subtitle: Text(
                      'name: ${patient.name} | age: ${patient.age} | weight: ${patient.weight} | hight: ${patient.hight}'),
                  // Add other information as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
