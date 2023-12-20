import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';

class AppointmentsDatasource {
  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('Appointments');

  Future<List<Appointment>> getAppointments() async {
    try {
      final QuerySnapshot<Object?> snapshot =
          await appointmentsCollection.get();

      return snapshot.docs
          .map((doc) => Appointment.fromMap(
              doc.data() as Map<String, dynamic>? ?? {}, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  Future<List<Appointment>> getMyAppointments(String doctorID) async {
    try {
      final QuerySnapshot<Object?> snapshot = await appointmentsCollection
          .where('doctor_id', isEqualTo: doctorID)
          .get();

      return snapshot.docs
          .map((doc) => Appointment.fromMap(
              doc.data() as Map<String, dynamic>? ?? {}, doc.id))
          .toList(); // toList() should be here, after the map operation.
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  Future<List<Appointment>> getAppointmentsByParentId(String parentId) async {
    try {
      final QuerySnapshot<Object?> snapshot = await appointmentsCollection
          .where('parent_id', isEqualTo: parentId)
          .get();

      return snapshot.docs
          .map((doc) => Appointment.fromMap(
              doc.data() as Map<String, dynamic>? ?? {}, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await appointmentsCollection.add(appointment.toMap());
      print('Appointment added successfully');
    } catch (e) {
      print('Error adding appointment: $e');
    }
  }

  Future<bool> doesAppointmentExistWithParentId(String parentId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Appointments')
        .where('parent_id', isEqualTo: parentId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
