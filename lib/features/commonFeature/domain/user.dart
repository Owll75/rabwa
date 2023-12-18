class UserData {
  final String id;
  String name;
  final String email;
  final String docId;
  String phone;
  // Add other fields that you expect to have in your Firestore 'Users' collection

  UserData({
    required this.docId,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    // Initialize other fields here
  });

  setName(String newName) {
    this.name = newName;
  }

  setPhone(String newPhone) {
    this.phone = newPhone;
  }

  factory UserData.fromMap(String id, Map<String, dynamic> data) {
    return UserData(
      phone: data['phone'],
      docId: id,
      id: data['id'],
      name: data['name'],
      email: data['email'],
      // Assign other fields here
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'phone': phone,
    };
  }
}
