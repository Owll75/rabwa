import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';

class AppointmentsDatasource {
  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('Appointments');
  User? userID = FirebaseAuth.instance.currentUser;
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
          .where('doctorId', isEqualTo: doctorID)
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

  Future<List<Appointment>> _(String parentId) async {
    try {
      final QuerySnapshot<Object?> snapshot = await appointmentsCollection
          .where('parentId', isEqualTo: parentId)
          .where('active', isEqualTo: false)
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

  Future<List<Appointment>> getAppointmentsByParentId_(String parentId) async {
    try {
      final QuerySnapshot<Object?> snapshot = await appointmentsCollection
          .where('parentId', isEqualTo: parentId)
          .where('active', isEqualTo: false)
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

  Future<List<Appointment>> getAppointmentsByParentId(String parentId) async {
    try {
      final QuerySnapshot<Object?> snapshot = await appointmentsCollection
          .where('parentId', isEqualTo: parentId)
          .where('active', isEqualTo: true)
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
      appointment.addParentID(userID?.uid ?? "");
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

  Future<void> _reqAppointment(Appointment appointment) async {
    await FirebaseFirestore.instance.collection('Appointments').add({
      'active': appointment.active,
      'submitDate': appointment.submitDate,
      'doctorId': appointment.doctorId,
      'parentName': appointment.parentName,
      'parentId': appointment.parentId,
      'patientId': appointment.patientId,
      'patientName': appointment.patientName,
      'patientAge': appointment.patientAge,
      'patientWeight': appointment.patientWeight,
      'patientHeight': appointment.patientHeight,
      // Include other fields as needed
    });
  }
}
