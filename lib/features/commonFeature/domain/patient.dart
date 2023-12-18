class Patient {
  String? docId;
  double hight;
  String parentID;
  String name;
  int age;
  double weight;
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
}
