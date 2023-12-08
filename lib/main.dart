import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rabwa/features/presentation/appointments_page.dart';
import 'package:rabwa/features/presentation/doctors_page.dart';
import 'package:rabwa/features/presentation/home_page.dart';
import 'package:rabwa/features/presentation/medicines_page.dart';
import 'package:rabwa/features/presentation/patients_page.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/Appointments': (context) => AppointmentsPage(),
        '/Medicines':(context) =>MedicinePage(),
        '/Doctors':(context) =>DoctorsPage(),
        '/Patient':(context) =>PatientPage(),
      },
    );
  }
}
