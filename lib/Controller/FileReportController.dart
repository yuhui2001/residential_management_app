import 'package:cloud_firestore/cloud_firestore.dart';

class FileReportController {
  final collection = FirebaseFirestore.instance.collection("File Report List");

  Future<void> fileReport(String title, String description) async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      final documentName = "Report ${documentCount + 1}";

      String reportId = "REP${documentCount + 1}";

      final postData = {
        "Title": title,
        "Description": description,
        "Report_ID": reportId
      };

      await collection.doc(documentName).set(postData);
    } catch (e) {
      // ignore: avoid_print
      print("Error adding data to Firestore: $e");
    }
  }
}
