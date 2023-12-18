class User {
  final String id;
  final String name;
  final String email;
  final String docId;
  // Add other fields that you expect to have in your Firestore 'Users' collection

  User({
    required this.docId,
    required this.id,
    required this.name,
    required this.email,
    // Initialize other fields here
  });

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      docId: id,
      id: data['id'],
      name: data['name'],
      email: data['email'],
      // Assign other fields here
    );
  }
}
