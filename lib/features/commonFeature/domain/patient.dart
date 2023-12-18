class Patient {
  String? docId;
  double? hight;
  String? parentID;
  String name;
  int? age;
  double? weight;
  String? doctor;

  Patient(
      {required this.hight,
      required this.age,
      this.docId,
      required this.parentID,
      required this.name,
      required this.weight,
      this.doctor});

  Map<String, dynamic> toMap() {
    return {
      'hight': hight,
      'age': age,
      'name': name,
      'weight': weight,
      'parent_id': parentID,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> data, String documentId) {
    return Patient(
      name: data['name'],
      age: data['age'],
      hight: data['hight'],
      parentID: data['parent_id'],
      weight: data['weight'],
      docId: documentId,
      doctor: data['doctor_id'],
    );
  }
}
