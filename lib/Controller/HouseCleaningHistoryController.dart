import 'package:cloud_firestore/cloud_firestore.dart';

class HouseCleaningHistoryController {
  final String userId;

  HouseCleaningHistoryController(this.userId);

  final collection =
      FirebaseFirestore.instance.collection("House Cleaning History");
  Future<List<List<String>>> getRequestHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .where('User_ID', isEqualTo: userId)
          .orderBy("Document_Count", descending: true)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String requestId = doc['Request_ID'];
        String requestDate = doc['Request_Date'];
        String status = doc['Request_Status'];
        String maintenanceType = doc['Cleaning_Type'];

        return [
          requestId,
          requestDate,
          status,
          maintenanceType,
        ];
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching Maintenance Request history: $e");
      return [];
    }
  }
}
