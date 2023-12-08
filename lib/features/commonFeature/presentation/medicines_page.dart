

import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/medicine_repository.dart';
import 'package:rabwa/features/commonFeature/domain/medicine.dart';

class MedicinePage extends StatelessWidget {
  final MedicinesDatasource placeDatasource = MedicinesDatasource();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines'),
      ),
      body: FutureBuilder<List<Medicine>>(
        future: placeDatasource.getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data
            return Text('No medicines found.');
          } else {
            // If data is available, display it
            List<Medicine> medicines = snapshot.data!;
            return ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                Medicine medicine = medicines[index];
                return ListTile(
                  title: Text(medicine.name ?? 'Unnamed appointment'),
                  subtitle: Text(
                      'price: ${medicine.price} | dose: ${medicine.dose} | usages: ${medicine.usages}'),
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
