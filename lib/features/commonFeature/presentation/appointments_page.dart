import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/appointment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabwa/features/commonFeature/presentation/widgets/appointmentCard.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';

import 'widgets/app_drawer.dart';

final selectedAppointmentProvider = StateProvider<Appointment?>((ref) => null);

class AppointmentsPage extends StatelessWidget {
  final AppointmentsDatasource appointmentDatasource = AppointmentsDatasource();
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
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No appointment found.');
          } else {
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return AppointmentCard(appointmentData: appointment);
              },
            );
          }
        },
      ),
    );
  }
}
