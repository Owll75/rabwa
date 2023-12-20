import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rabwa/features/commonFeature/data/user_repository.dart';
import 'package:rabwa/features/commonFeature/presentation/profile_page_doctor.dart';
import 'package:rabwa/features/firebase_auth/firebase_auth_services.dart';
import 'package:rabwa/features/firebase_auth/presentation/login_page.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
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
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is authenticated, determine if the user is a doctor
      return FutureBuilder<bool>(
        future: UsersDatasource()
            .checkUserExists(user.uid), // Asynchronous operation
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Waiting for the future to complete
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle any errors here
            return Text('Error: ${snapshot.error}');
          } else {
            // Once data is available, show the main app with bottom navigation
            bool isUser = snapshot.data ?? false;
            bool isDoctor = !isUser;
            return BottomNavigationBarDemo();
          }
        },
      );
    } else {
      // User is not authenticated, redirect to the login page
      return const LoginPage();
    }
  }
}

class BottomNavigationBarDemo extends StatefulWidget {
  BottomNavigationBarDemo({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarDemoState createState() =>
      _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfUserIsDoctor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          bool isDoctor = snapshot.data ?? false;

          return _buildScaffold(isDoctor);
        }
      },
    );
  }

  Future<bool> _checkIfUserIsDoctor() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (await UsersDatasource().checkUserExists(user.uid)) {
        return false;
      }
      return true;
    }
    return false;
  }

  Scaffold _buildScaffold(bool isDoctor) {
    List<Widget> _pages = isDoctor
        ? [
            AppointmentsPage(),
            PatientPage(),
            ProfilePageDoctor(),
          ]
        : [
            /* Other pages for regular users */ AppointmentsPage(),
            ProfilePage()
          ];

    List<BottomNavigationBarItem> _navItems = isDoctor
        ? [
            const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Appointments'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Patients'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile')
          ]
        : [
            const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Appointments'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
