import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/medicine.dart';

class MedicinesDatasource {
  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('Medicines');
  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('Patient');

  Future<List<Medicine>> getMedicinesForPatient(String patientId) async {
    try {
      // Explicitly type the snapshot to avoid type mismatch
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await medicinesCollection
              .where(
                  'patient',
                  isEqualTo: FirebaseFirestore.instance
                      .collection('Patient')
                      .doc(patientId))
              .get() as QuerySnapshot<Map<String, dynamic>>; // Cast the result

      return snapshot.docs
          .map((doc) => Medicine.fromMap(doc.data(), doc.id))
          .toList(); // Use non-null assertion for data
    } catch (e) {
      print('Error fetching medicines for patient: $e');
      return [];
    }
  }

  Future<List<Medicine>> getMedicinesForChildren(String parentId) async {
    List<Medicine> allMedicines = [];

    try {
      // Explicitly type the snapshot to avoid type mismatch
      final QuerySnapshot<Map<String, dynamic>> patientsSnapshot =
          await patientsCollection.where('parent_id', isEqualTo: parentId).get()
              as QuerySnapshot<Map<String, dynamic>>; // Cast the result

      for (var patientDoc in patientsSnapshot.docs) {
        final String patientId = patientDoc.id;
        final List<Medicine> medicines =
            await getMedicinesForPatient(patientId);
        allMedicines.addAll(medicines);
      }

      return allMedicines;
    } catch (e) {
      print('Error fetching medicines for children: $e');
      return [];
    }
  }
}
