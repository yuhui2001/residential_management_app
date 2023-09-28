import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      // reference to the "user" collection
      CollectionReference users = _firestore.collection('user');

      // Query for a username only
      QuerySnapshot querySnapshot =
          await users.where('username', isEqualTo: username).get();

      // check if any document match the query thing
      if (querySnapshot.docs.isNotEmpty) {
        // return the data from the first document found
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
