import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabwa/main.dart';

import '../data/user_repository.dart';
import '../domain/user.dart';
import 'widgets/info_card.dart';
import 'widgets/settings_menu.dart';

class ProfilePage extends ConsumerWidget {
  FirebaseFirestore? instance;
  User? user = FirebaseAuth.instance.currentUser;

  final UsersDatasource usersDatasource = UsersDatasource();

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
              })
        ],
      ),
      body: FutureBuilder<UserData?>(
        future: usersDatasource.getUserByDocId(
            //user.uid---------------------------------------------------------------------------------------------------
            'XyrunKrrnsgkiRbSdph5dgV5xpM2'), // Replace this with the actual user ID
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
            UserData? user = snapshot.data;
            return user != null
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: InfoCard(user: user),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: SettingsMenu(user: user),
                      ),
                    ],
                  )
                : const Text('User not found.');
          }
        },
      ),
    );
  }
}
