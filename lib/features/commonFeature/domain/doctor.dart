class Doctor {
  String? name;
  int? age;
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
}
