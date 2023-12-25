import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/presentation/patients_page.dart';
import 'package:rabwa/features/firebase_auth/presentation/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/user.dart';
import '../children_page.dart';
import '../my_account.dart';
import 'settings_tile.dart';

class SettingsMenuDoctor extends StatelessWidget {
  final Doctor doctor;
  FirebaseFirestore? instance;

  SettingsMenuDoctor({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SettingsTile(
              icon: Icons.face,
              title: 'My Patient',
              subtitle: 'Manage My Patient',
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientPage()),
                )
              },
            ),
            SettingsTile(
              icon: Icons.book,
              title: 'Doses Guidelines',
              subtitle: 'View dosage information',
              onTap: () async {
                const url =
                    'https://drive.google.com/file/d/11Xne7K9XOl6kfykE8_UAB0wz90_NT4ni/view?usp=sharing';
                try {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not launch the document'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to launch URL: $e'),
                    ),
                  );
                }
              },
            ),
            SettingsTile(
              icon: Icons.logout,
              title: 'Log out',
              subtitle: '',
              onTap: () {
                FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
