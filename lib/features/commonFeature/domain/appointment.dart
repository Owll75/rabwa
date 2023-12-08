import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class Appointment {
  String? date;
  Doctor? doctor;
  String? location;
  Patient? patient;
  String? time;
  String? title;

  Appointment({
    this.date,
    this.doctor,
    this.location,
    this.patient,
    this.title,
    this.time,
  });
}