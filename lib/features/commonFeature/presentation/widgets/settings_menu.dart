import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabwa/features/firebase_auth/presentation/login_page.dart';

import '../../domain/user.dart';
import '../children_page.dart';
import '../my_account.dart';
import 'settings_tile.dart';

class SettingsMenu extends StatelessWidget {
  final UserData user;
  FirebaseFirestore? instance;

  SettingsMenu({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SettingsTile(
              icon: Icons.person,
              title: 'My Account',
              subtitle: 'View info',
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyAccountPage(user: user)),
                )
              },
            ),
            SettingsTile(
              icon: Icons.child_care,
              title: 'Children',
              subtitle: 'Manage your linked Children',
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildrenPage(parentID: user.docId)),
                )
              },
            ),
            SettingsTile(
              icon: Icons.logout,
              title: 'Log out',
              subtitle: '',
              onTap: () {
                FirebaseAuth.instance.signOut();

                Navigator.push(
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
