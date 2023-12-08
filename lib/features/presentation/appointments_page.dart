import 'package:flutter/material.dart';
import 'package:rabwa/features/data/appointment_repository.dart';

import '../domain/appointment.dart';

class AppointmentsPage extends StatelessWidget {
  final AppointmentDatasource appointmentDatasource = AppointmentDatasource();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: appointmentDatasource.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data
            return Text('No appointment found.');
          } else {
            // If data is available, display it
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return ListTile(
                  title: Text(appointment.title ?? 'Unnamed appointment'),
                  subtitle: Text(
                      'doctor: ${appointment.doctor} | location: ${appointment.location} | patient: ${appointment.patient} | date: ${appointment.date}'),
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
