import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rabwa/features/commonFeature/presentation/appointments_page.dart';
import 'package:rabwa/features/commonFeature/presentation/doctors_page.dart';
import 'package:rabwa/features/commonFeature/presentation/home_page.dart';
import 'package:rabwa/features/commonFeature/presentation/medicines_page.dart';
import 'package:rabwa/features/commonFeature/presentation/patients_page.dart';
import 'package:rabwa/theme.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
final themeProvider = StateNotifierProvider<RiverThemeDarkModel, bool>(
    (ref) => RiverThemeDarkModel());

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkValueModel = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Rabwa',
      theme: darkValueModel
          ? ThemeData.dark()
          : ThemeData.light(),
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
