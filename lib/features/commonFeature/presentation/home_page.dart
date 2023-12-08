
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabwa/main.dart';



class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),        actions: [
          IconButton(
              icon: Icon(ref.read(themeProvider.notifier).isDark
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleDark();
                print(
                    "change theme button");
              })
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Medicines');
              },
              child: Text('Medicines'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Appointments');
              },
              child: Text('appointments'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Doctors');
              },
              child: Text('doctors'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Patient');
              },
              child: Text('patients'),
            ),
          ],
          
        ),
      ),
    );
  }
}
