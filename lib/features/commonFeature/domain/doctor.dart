class Doctor {
  String? name;
  String? age;
  String? docId;

  Doctor({
    this.name,
    this.docId,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'docId': docId,
      'age': age,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'],
      docId: map['docId'],
      age: map['age'],
    );
  }
}
