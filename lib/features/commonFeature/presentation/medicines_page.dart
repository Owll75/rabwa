import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/medicine_repository.dart';
import 'package:rabwa/features/commonFeature/domain/medicine.dart';

class MedicinePage extends StatelessWidget {
  final String patientId;
  final MedicinesDatasource medicinesDatasource = MedicinesDatasource();

  MedicinePage({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines for Children'),
      ),
      body: FutureBuilder<List<Medicine>>(
        future: medicinesDatasource.getMedicinesForPatient(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
                'No medicines found for the children of this parent.');
          } else {
            List<Medicine> medicines = snapshot.data!;
            return ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                Medicine medicine = medicines[index];
                return ListTile(
                  title: Text('Name: ${medicine.name}'),
                  subtitle: Text(
                      'Dose: ${medicine.dose} - Instructions: ${medicine.instructions}'),
                  trailing: Text('\$${medicine.price}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
