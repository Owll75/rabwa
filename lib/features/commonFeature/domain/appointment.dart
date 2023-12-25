import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String? id; // created by firebase
  bool? active; // assign it false
  String? submitDate; // the current date at the time of submission
  String? doctorId; // The assigned Doctor to the patient in databse
  String? parentName; // the user "name" field saved in users collection
  String? parentId; // the user "id" field saved in users collection

  String? patientId; // the "id" field saveed in the "Patient" Collection
  String? patientName; // the "name" field saveed in the "Patient" Collection
  int? patientAge; // the "age" field saveed in the "Patient" Collection
  double?
      patientWeight; // the "weight" field saveed in the "Patient" Collection
  double?
      patientHeight; // the "height" field saveed in the "Patient" Collection

  String? ac1; // question 1
  String? ac2; // question 2
  String? ac3; // question 3
  String? ac4; // question 4
  String? ac5; // question 5
  String? ac6; // question 6

  String? patientGender; // the "id" field saveed in the "Patient" Collection

  String? appointmentDate; // Abdulellah
  String? location; // Abdulellah
  String? time; // Abdullellah
  String? title; // ??
  String? report;

  Appointment(
      {this.id,
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
      submitDate: map['submitDate'] as String?,
      appointmentDate: map['submitDate'] as String?,
      doctorId: map['doctorId'] as String?,
      location: map['location'] as String?,
      patientId: map['patientid'] as String?,
      parentId: map['parentId'] as String?,
      time: map['time'] as String?,
      title: map['title'] as String?,
      parentName: map['parentName'] as String?,
      patientName: map['patientName'] as String?,
      patientAge: map['patientAge'] as int?,
      patientGender: map['patientGender'] as String?,
      patientWeight: (map['patient_weight'] as num?)?.toDouble(),
      patientHeight: (map['patient_height'] as num?)?.toDouble(),
      ac1: map['AC1'] as String?,
      ac2: map['AC2'] as String?,
      ac3: map['AC3'] as String?,
      ac4: map['AC4'] as String?,
      ac5: map['AC5'] as String?,
      ac6: map['AC6'] as String?,
      report: map['report'] as String?,
      active: map['active'] as bool?,
    );
  }
  void addParentID(String newParentID) {
    this.parentId = newParentID;
  }

  Map<String, dynamic> toMap() {
    return {
      'submit_date': submitDate,
      'appointment_date': appointmentDate,
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
      'AC1': ac1,
      'AC2': ac2,
      'AC3': ac3,
      'AC4': ac4,
      'AC5': ac5,
      'AC6': ac6,
      'report': report,
      'active': active,
    };
  }

  int calculateAsthmaControlScore() {
    int score = 0;
    score += ac1 == "true" ? 1 : 0;
    score += ac2 == "true" ? 1 : 0;
    score += ac3 == "true" ? 1 : 0;
    score += ac4 == "true" ? 1 : 0;
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

  String getDoseLevel() {
    int score = calculateAsthmaControlScore();
    if (score == 0) {
      return 'Step down the current medications. Follow up after 3 months.';
    } else {
      return 'Step Up the current medication. Follow up after 2-3 months.';
    }
  }

  bool shouldContinueSurvey() {
    int score = calculateAsthmaControlScore();
    return score >= 3;
  }

  String getQuestionsAnswered() {
    List<String> questionsAnswered = [];
    if (ac1 == "true")
      questionsAnswered.add("More than twice a week daytime symptoms? true\n");
    if (ac2 == "true")
      questionsAnswered.add("Woke up in the night due to symptoms? true\n");
    if (ac3 == "true")
      questionsAnswered
          .add("Used their reliever inhaler more than twice a week? true\n");
    if (ac4 == "true")
      questionsAnswered.add("Activity limitations due to symptoms? true\n");
    if (shouldContinueSurvey()) {
      if (ac5 != null)
        questionsAnswered.add(
            "Did your child adhered to the inhaler regimen as prescribed? $ac5\n");
      if (ac6 != null)
        questionsAnswered.add(
            "Did you make sure your child avoids exposure to their allergic triggers? $ac6");
    }
    return questionsAnswered.join('\n');
  }
}
