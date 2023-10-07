import 'package:cloud_firestore/cloud_firestore.dart';

class LoginModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data along with the salt
  Future<Map<String, dynamic>?> getUserDataWithSalt(String username) async {
    try {
      // Reference to the "user" collection
      CollectionReference users = _firestore.collection('user');

      // Query for a username and get the salt along with other data
      QuerySnapshot querySnapshot =
          await users.where('username', isEqualTo: username).get();

      // Check if any document matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // Return the data from the first document found
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        // no matching username
        return null;
      }
    } catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }
}