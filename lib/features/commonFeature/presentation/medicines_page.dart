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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'No medicines found for this child'));
          } else {
            List<Medicine> medicines = snapshot.data!;
            return ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                Medicine medicine = medicines[index];
                return Card(
                  elevation: 4.0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.medical_services, size: 48),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicine.name}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                  '${medicine.dose}  |  ${medicine.price} SAR'),
                              SizedBox(height: 4),
                              Text('Instructions: ${medicine.instructions}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
