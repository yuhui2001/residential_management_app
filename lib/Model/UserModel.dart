import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      // Reference to the "user" collection
      CollectionReference users = _firestore.collection('user');

      // Query for a specific document using the "username" field
      QuerySnapshot querySnapshot =
          await users.where('username', isEqualTo: username).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Return the data from the first document found (assuming usernames are unique)
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        // No document found with the specified username
        return null;
      }
    } catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }
}
