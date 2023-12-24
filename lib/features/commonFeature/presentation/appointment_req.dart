import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';
import 'appointment_form.dart'; // Update this import as needed
import 'package:rabwa/features/commonFeature/data/appointment_repository.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';
import 'package:intl/intl.dart';

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
        future: fetchUserId(user!.uid).then((userId) {
          if (userId != null) {
            return AppointmentsDatasource()
                .getAppointmentsByParentId_(user?.uid ?? "");
          } else {
            throw Exception('User ID not found.');
          }
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Yoe have no waiting requests');
          } else {
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                // Turn it to widget **
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(appointment.patientName![0]),
                    ),
                    title: Text(
                        '${appointment.patientName} - (${appointment.patientId})'),
                    subtitle: Text(
                      'Age: ${appointment.patientAge}\n'
                      'Submitted on: ${appointment.submitDate}',
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

// Check that the user is Signed In
  void _validateAndNavigate(BuildContext context) async {
    if (user == null) {
      _showValidationAlert(context,
          'You are not logged in. Please log in to add and manage patients.');
      return;
    }

    try {
      // Retrieve all patients related to the user (Father).
      var patientDocs = await firestore
          .collection('Patient')
          .where('parent_id', isEqualTo: user!.uid)
          .get();

      if (patientDocs.docs.isEmpty) {
        _showValidationAlert(context,
            'You have not added any children yet. Please add your children to proceed.');
      } else if (patientDocs.docs.any((doc) =>
          // Check if there i a doctor
          doc.data()['doctor_id'] == null || doc.data()['doctor_id'].isEmpty)) {
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

  ///
  Future<String?> fetchUserId(String userUid) async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userUid).get();

    if (docSnapshot.exists && docSnapshot.data()!.containsKey('id')) {
      return docSnapshot.data()!['id'] as String?;
    } else {
      return null;
    }
  }
}
