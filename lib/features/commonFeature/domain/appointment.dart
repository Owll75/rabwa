import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

class Appointment {
  String? submit_date;
  String? appointment_date;
  Doctor? doctor_id;
  String? location;
  Patient? patient_id;
  String? time;
  String? title;
  String? parent_name;
  String? patient_name;
  String? patient_age;
  String? patient_gender;
  String? patient_weight;
  String? patient_height;
  String? ac1;
  String? ac2;
  String? ac3;
  String? ac4;
  String? ac5;
  String? ac6;
  String? report;
  bool? active;

  Appointment({
    this.submit_date,
    this.appointment_date,
    this.doctor_id,
    this.location,
    this.patient_id,
    this.time,
    this.title,
    this.parent_name,
    this.patient_name,
    this.patient_age,
    this.patient_gender,
    this.patient_weight,
    this.patient_height,
    this.ac1,
    this.ac2,
    this.ac3,
    this.ac4,
    this.ac5,
    this.ac6,
    this.report,
  });
}
