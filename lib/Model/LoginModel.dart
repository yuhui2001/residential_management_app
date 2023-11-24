import 'package:cloud_firestore/cloud_firestore.dart';

class LoginModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // fetch user data along with the salt
  Future<Map<String, dynamic>?> getUserDataWithSalt(String username) async {
    try {
      // reference to the "user" collection
      CollectionReference users = _firestore.collection('user');

      // query for a username and get the salt along with other data
      QuerySnapshot querySnapshot =
          await users.where('username', isEqualTo: username).get();

      // check if any document matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // return the data from the first document found
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        // if no matching username
        return null;
      }
    } catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }
}