import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

import '../domain/user.dart';

class UsersDatasource {
  final CollectionReference UsersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<User?> getUserByDocId(String docId) async {
    try {
      // Get a reference to the 'Users' collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      // Get the document reference by the specific document ID
      DocumentReference userDoc = users.doc(docId);

      // Get the document snapshot
      DocumentSnapshot<Object?> snapshot = await userDoc.get();

      // Check if the snapshot contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Create a User object from the data
        User user =
            User.fromMap(docId, snapshot.data()! as Map<String, dynamic>);
        return user;
      } else {
        print('No data found for user with ID $docId');
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null; // Return null if the user is not found or an error occurs
  }
}
