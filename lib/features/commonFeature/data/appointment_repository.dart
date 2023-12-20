import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rabwa/features/commonFeature/domain/appointment.dart';

import 'package:rabwa/features/commonFeature/domain/doctor.dart';

class AppointmentDatasource {
  final CollectionReference AppointmentsCollection =
      FirebaseFirestore.instance.collection('Appointments');
  Future<List<Appointment>> getAppointments() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Appointments').get();

      final List<Appointment> appointments = snapshot.docs.map((doc) {
        final data = doc.data();

        return Appointment(
            appointment_date: data['date'] ?? '',
            location: data['location'] ?? '',
            time: data['time'] ?? '',
            title: (data['title'] ?? ''));
      }).toList();
      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }
}
