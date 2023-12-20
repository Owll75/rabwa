class Patient {
  String? doctor;
  String? docId;
  String? parentID;
  String name;
  int? age;
  double? weight;
  double? height;

  Patient(
      {required this.height,
      required this.age,
      this.docId,
      required this.parentID,
      required this.name,
      required this.weight,
      this.doctor});

  Map<String, dynamic> toMap() {
    return {
      'height': height,
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
      height: data['hight'],
      parentID: data['parent_id'],
      weight: data['weight'],
      docId: documentId,
      doctor: data['doctor_id'],
    );
  }
}
