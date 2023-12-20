import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rabwa/features/commonFeature/domain/patient.dart';

import '../domain/user.dart';

class UsersDatasource {
  final CollectionReference UsersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<UserData?> getUserByDocId(String docId) async {
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
        UserData user =
            UserData.fromMap(docId, snapshot.data()! as Map<String, dynamic>);
        return user;
      } else {
        print('No data found for user with ID $docId');
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null; // Return null if the user is not found or an error occurs
  }

  Future<void> updateUser(UserData updatedUser) async {
    try {
      await UsersCollection.doc(updatedUser.docId).update(updatedUser.toMap());
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> createUser(UserData newUser) async {
    try {
      await UsersCollection.doc(newUser.docId).set(newUser.toMap());
      print('User created successfully with ID: ${newUser.docId}');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<bool> checkUserExists(String docId) async {
    try {
      DocumentSnapshot<Object?> snapshot =
          await UsersCollection.doc(docId).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
