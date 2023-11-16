import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceHistoryController {
  final String userId;

  MaintenanceHistoryController(this.userId);

  final collection =
      FirebaseFirestore.instance.collection("Maintenance Request History");
  Future<List<List<String>>> getMaintenanceHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .where('User_ID', isEqualTo: userId)
          .orderBy("Maintenance_ID", descending: true)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String requestId = doc['Maintenance_ID'];
        String requestDate = doc['Request_Date'];
        String status = doc['Request_Status'];
        String description = doc['Description'];
        String maintenanceType = doc['Maintenance_Type'];
        String workerContact = doc['Worker_Contact'];
        String workerName = doc['Worker_Name'];

        return [
          requestId,
          requestDate,
          status,
          description,
          maintenanceType,
          workerContact,
          workerName
        ];
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching Maintenance Request history: $e");
      return [];
    }
  }
}
