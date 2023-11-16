import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';

class MaintenanceController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("Maintenance Request History");

  Future<void> makeRequest(
      String requestDate, String maintenanceType, String description) async {
    try {
      final userId = userData.userid;

      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      final documentName = "Booking ${documentCount + 1}";

      String requestID = "MAI${documentCount + 1}";

      final postData = {
        "Request_Date": requestDate,
        "User_ID": userId,
        "Maintenance_ID": requestID,
        "Maintenance_Type": maintenanceType,
        "Description": description,
        "Request_Status": "Pending",
        "Worker_Name": "Pending...",
        "Worker_Contact": "Pending...",
      };

      await collection.doc(documentName).set(postData);
    } catch (e) {
      // ignore: avoid_print
      print("Error adding data to Firestore: $e");
    }
  }
}
