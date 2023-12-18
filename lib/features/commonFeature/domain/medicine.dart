// ignore_for_file: public_member_api_docs, sort_constructors_first
class Medicine {
  String? dose;
  String? instructions;
  String? name;
  String? patient;
  double? price;
  String? usages;
  String? patientId;

  Medicine(
      {this.dose,
      this.instructions,
      this.name,
      this.patient,
      this.price,
      this.usages,
      this.patientId});

  factory Medicine.fromMap(Map<String, dynamic> data, String documentId) {
    return Medicine(
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      dose: data['dose'] ?? '',
      instructions: data['instructions'] ?? '',
      usages: data['usages'] ?? '',
      patientId: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'dose': dose,
      'instructions': instructions,
      'usages': usages,
      'patientId': patientId,
    };
  }
}
