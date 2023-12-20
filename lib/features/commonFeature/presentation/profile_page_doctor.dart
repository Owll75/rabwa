import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabwa/features/commonFeature/data/doctor_repository.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/presentation/widgets/info_card_doctor.dart';
import 'package:rabwa/features/commonFeature/presentation/widgets/settings_menu_doctor.dart';
import 'package:rabwa/main.dart';

class ProfilePageDoctor extends ConsumerWidget {
  FirebaseFirestore? instance;
  User? user = FirebaseAuth.instance.currentUser;

  final DoctorDatasource doctorDatasource = DoctorDatasource();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(ref.read(themeProvider.notifier).isDark
                ? Icons.nightlight_round
                : Icons.wb_sunny),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleDark();
              print("change theme button");
            },
          ),
        ],
      ),
      body: FutureBuilder<Doctor?>(
        future: doctorDatasource.getDoctorByDocId(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            // If there is no data
            return const Text('No user found.');
          } else {
            // If data is available, display it
            Doctor? doctor = snapshot.data;
            print("==============================================");
            print(doctor);

            return user != null
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: InfoCardDoctor(doctor: doctor!),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: SettingsMenuDoctor(doctor: doctor),
                      ),
                      //Display user ID
                      Text('User ID: ${doctor.docId}'),
                    ],
                  )
                : const Text('User not found.d');
          }
        },
      ),
    );
  }
}
