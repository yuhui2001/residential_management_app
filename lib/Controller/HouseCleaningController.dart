import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';

class HouseCleaningController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("House Cleaning History");

  Future<void> makeRequest(String requestDate, String cleaningType) async {
    try {
      final userId = userData.userid;

      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      final documentName = "Booking ${documentCount + 1}";

      String requestID = "HCL${documentCount + 1}";

      final postData = {
        "Request_Date": requestDate,
        "User_ID": userId,
        "Request_ID": requestID,
        "Cleaning_Type": cleaningType,
        "Request_Status": "Incomplete",
        "Document_Count": documentCount
      };

      await collection.doc(documentName).set(postData);
    } catch (e) {
      // ignore: avoid_print
      print("Error adding data to Firestore: $e");
    }
  }
}
