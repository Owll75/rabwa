import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  DateTime? submitDate;
  DateTime? appointmentDate;
  String? doctorId;
  String? location;
  String? patientId;
  String? time;
  String? title;
  String? parentName;
  String? parentId;
  String? patientName;
  int? patientAge;
  String? patientGender;
  double? patientWeight;
  double? patientHeight;
  String? ac1;
  String? ac2;
  String? ac3;
  String? ac4;
  String? ac5;
  String? ac6;
  String? report;
  bool? active;

  Appointment(
      {this.id = '',
      this.submitDate,
      this.appointmentDate,
      this.doctorId,
      this.location,
      this.patientId,
      this.time,
      this.title,
      this.parentName,
      this.patientName,
      this.patientAge,
      this.patientGender,
      this.patientWeight,
      this.patientHeight,
      this.ac1,
      this.ac2,
      this.ac3,
      this.ac4,
      this.ac5,
      this.ac6,
      this.report,
      this.active,
      this.parentId});

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      submitDate: (map['submit_date'] as Timestamp?)?.toDate(),
      appointmentDate: (map['appointment_date'] as Timestamp?)?.toDate(),
      doctorId: map['doctor_id'] as String?,
      location: map['location'] as String?,
      patientId: map['patient_id'] as String?,
      parentId: map['perent_id'] as String?,
      time: map['time'] as String?,
      title: map['title'] as String?,
      parentName: map['parent_name'] as String?,
      patientName: map['patient_name'] as String?,
      patientAge: map['patient_age'] as int?,
      patientGender: map['patient_gender'] as String?,
      patientWeight: (map['patient_weight'] as num?)?.toDouble(),
      patientHeight: (map['patient_height'] as num?)?.toDouble(),
      ac1: map['ac1'] as String?,
      ac2: map['ac2'] as String?,
      ac3: map['ac3'] as String?,
      ac4: map['ac4'] as String?,
      ac5: map['ac5'] as String?,
      ac6: map['ac6'] as String?,
      report: map['report'] as String?,
      active: map['active'] as bool?,
    );
  }
  void addParentID(String newParentID) {
    this.parentId = newParentID;
  }

  Map<String, dynamic> toMap() {
    return {
      'submit_date': Timestamp.fromDate(submitDate ?? DateTime.now()),
      'appointment_date': Timestamp.fromDate(appointmentDate ?? DateTime.now()),
      'doctor_id': doctorId,
      'location': location,
      'patient_id': patientId,
      'time': time,
      'title': title,
      'parent_name': parentName,
      'patient_name': patientName,
      'patient_age': patientAge,
      'patient_gender': patientGender,
      'patient_weight': patientWeight,
      'patient_height': patientHeight,
      'ac1': ac1,
      'ac2': ac2,
      'ac3': ac3,
      'ac4': ac4,
      'ac5': ac5,
      'ac6': ac6,
      'report': report,
      'active': active,
    };
  }
  int calculateAsthmaControlScore() {
    int score = 0;
    score += ac1 == "Yes" ? 1 : 0;
    score += ac2 == "Yes" ? 1 : 0;
    score += ac3 == "Yes" ? 1 : 0;
    score += ac4 == "Yes" ? 1 : 0;
    return score;
  }

  String getAsthmaControlLevel() {
    int score = calculateAsthmaControlScore();
    if (score == 0) {
      return 'Controlled';
    } else if (score > 0 && score <= 2) {
      return 'Partially Controlled';
    } else {
      return 'Uncontrolled';
    }
  }

  bool shouldContinueSurvey() {
    int score = calculateAsthmaControlScore();
    return score >= 3;
  }

  String getQuestionsAnswered() {
    List<String> questionsAnswered = [];
    if (ac1 == "Yes") questionsAnswered.add("AC1: Yes");
    if (ac2 == "Yes") questionsAnswered.add("AC2: Yes");
    if (ac3 == "Yes") questionsAnswered.add("AC3: Yes");
    if (ac4 == "Yes") questionsAnswered.add("AC4: Yes");
    if (shouldContinueSurvey()) {
      if (ac5 != null) questionsAnswered.add("AC5: $ac5");
      if (ac6 != null) questionsAnswered.add("AC6: $ac6");
    }
    return questionsAnswered.join('\n');
  }
}
