import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';

class VisitorInviteModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final userData = UserData.user;

      final userId = userData?.userid;

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Convert the Firestore document data to a Map
        final userDataMap = userDoc.data() as Map<String, dynamic>;
        return userDataMap;
      } else {
        // Handle the case where the user document doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching user data: $e");
      return null;
    }
  }
}
