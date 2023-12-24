
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/doctor_repository.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';

class DoctorsPage extends StatelessWidget {
  final DoctorDatasource doctorDatasourceDatasource = DoctorDatasource();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: doctorDatasourceDatasource.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'No doctor found'));
          } else {
            // If data is available, display it
            List<Doctor> doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = doctors[index];
                return ListTile(
                  title: Text(doctor.name ?? 'Unnamed doctor'),
                  subtitle: Text(
                      'name: ${doctor.name} | age: ${doctor.age}'),
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
