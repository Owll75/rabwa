import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.appointmentData,
  }) : super(key: key);

  final Appointment appointmentData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListTile(
          title: Text(
            'Doctor: ${appointmentData.doctor}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[400], // Modern color
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                'Title: ${appointmentData.title}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Modern color
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Date: ${appointmentData.date}, Time: ${appointmentData.time}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Modern color
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
