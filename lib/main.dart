import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';
import 'package:rabwa/features/commonFeature/presentation/appointments_page.dart';
import 'package:rabwa/features/commonFeature/presentation/doctors_page.dart';
import 'package:rabwa/features/commonFeature/presentation/medicines_page.dart';
import 'package:rabwa/features/commonFeature/presentation/patients_page.dart';
import 'package:rabwa/features/commonFeature/presentation/profile_page.dart';
import 'package:rabwa/theme.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final themeProvider = StateNotifierProvider<RiverThemeDarkModel, bool>(
  (ref) => RiverThemeDarkModel(),
);
final selectedAppointmentProvider = StateProvider<Appointment?>((ref) => null);

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkValueModel = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Rabwa',
      theme: darkValueModel ? ThemeData.dark() : ThemeData.light(),
      // initialRoute: '/Appointments',
      routes: {
        '/Appointments': (context) => AppointmentsPage(),
        //'/Medicines': (context) => MedicinePage(),
        '/Doctors': (context) => DoctorsPage(),
        '/Patient': (context) => PatientPage(),
      },
      home: BottomNavigationBarDemo(),
    );
  }
}

class BottomNavigationBarDemo extends StatefulWidget {
  @override
  _BottomNavigationBarDemoState createState() =>
      _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // HomePage(),
    AppointmentsPage(),
    // MedicinePage(),
    // DoctorsPage(),
    PatientPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PatientPage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        showUnselectedLabels:
            true, // Set to false if you don't want to show labels for unselected items
      ),
    );
  }
}
