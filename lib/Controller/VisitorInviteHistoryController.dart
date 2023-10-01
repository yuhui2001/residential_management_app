import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorInviteHistoryController {
  final String userId;

  VisitorInviteHistoryController(this.userId);

  final collection =
      FirebaseFirestore.instance.collection("Invited Visitor List");

  Future<List<List<String>>> getInviteHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('User_ID', isEqualTo: userId).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String visitorName = doc['Visitor_Name'];
        String visitorDate = doc['Invitation_Date'];
        int visitorNumber = doc['Visitor_Contact'];

        return [visitorName, visitorDate, visitorNumber.toString()];
      }).toList();
    } catch (e) {
      print("Error fetching invite history: $e");
      return [];
    }
  }
}
