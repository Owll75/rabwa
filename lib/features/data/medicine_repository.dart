import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/domain/medicine.dart';

class MedicinesDatasource {
  final CollectionReference DoctorsCollection =
      FirebaseFirestore.instance.collection('Medicines');
  Future<List<Medicine>> getMedicines() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Medicines').get();
      final List<Medicine> doctors = snapshot.docs.map((doc) {
        
        final data = doc.data();

        return Medicine(
          usages: data['usages'] ?? '',
          price: data['price'] ?? 0.0,
          name:data['name'] ?? '',
          // patient:data['patient'] ?? '',
          instructions:data['instructions'] ?? '',
          dose:data['dose'] ?? '',
        );
      }).toList();
      return doctors;
    } catch (e) {
      print('Error fetching medicine: $e');
      return [];
    }
  }
}