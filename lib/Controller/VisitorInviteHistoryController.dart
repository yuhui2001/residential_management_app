// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorInviteHistoryController {
  final String userId;

  VisitorInviteHistoryController(this.userId);

  final collection = FirebaseFirestore.instance
      .collection("Invited Visitor List")
      .orderBy("Invitation_ID", descending: true);

  Future<List<List<String>>> getInviteHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('User_ID', isEqualTo: userId).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String visitorName = doc['Visitor_Name'];
        String arrivalTime = doc['Arrival_Time'];
        String arrivalDate = doc['Arrival_Date'];
        int visitorNumber = doc['Visitor_Contact'];
        String invitationTime = doc['Invitation_Time'];
        String invitationDate = doc['Invitation_Date'];
        String encryptedUser = doc['Encrypted_Visitor_Info'];

        return [
          visitorName,
          arrivalDate,
          arrivalTime,
          visitorNumber.toString(),
          invitationDate,
          invitationTime,
          encryptedUser
        ];
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching invite history: $e");
      return [];
    }
  }
}
