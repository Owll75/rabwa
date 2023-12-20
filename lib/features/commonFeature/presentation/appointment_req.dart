import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';
import 'appointment_form.dart'; // Update this import as needed
import 'package:rabwa/features/commonFeature/data/appointment_repository.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class AppointmentreqPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  AppointmentreqPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments Requests'),
      ),
      body: FutureBuilder<List<Appointment>>(
        // Changed to List<Appointment>
        future: AppointmentsDatasource().getMyAppointments(
            user!.uid), // Ensure that AppointmentsDatasource is instantiated
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No appointments found.');
          } else {
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // Modify this part to display appointment details
                    // For example, using appointment.title or appointment.time
                    leading: CircleAvatar(
                      child: Text(appointment
                          .patientName![0]), // Assuming patientName is not null
                    ),
                    title: Text(appointment.patientName ?? 'Unnamed patient'),
                    subtitle: Text(
                      'Appointment Date: ${appointment.appointmentDate} | Location: ${appointment.location}',
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _validateAndNavigate(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _validateAndNavigate(BuildContext context) async {
    if (user == null) {
      _showValidationAlert(context,
          'You are not logged in. Please log in to add and manage patients.');
      return;
    }

    try {
      var patientDocs = await firestore
          .collection('Patients')
          .where('parentID', isEqualTo: user!.uid)
          .get();

      if (patientDocs.docs.isEmpty) {
        _showValidationAlert(context,
            'You have not added any children yet. Please add your children to proceed.');
      } else if (patientDocs.docs.any((doc) =>
          doc.data()['docid'] == null || doc.data()['docid'].isEmpty)) {
        _showValidationAlert(
            context, 'A doctor has not been assigned to any of your children.');
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AppointmentForm()));
      }
    } catch (e) {
      _showValidationAlert(
          context, 'An error occurred while retrieving patient data: $e');
    }
  }

  void _showValidationAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
