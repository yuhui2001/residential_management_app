import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageController {
  final String userId;
  HomePageController(this.userId);

  final collection = FirebaseFirestore.instance.collection("user");

  Future<List<String>> getMonthlyStatus() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('userid', isEqualTo: userId).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String monthlyStatus = doc['monthlyPaymentStatus'];
        return monthlyStatus;
      }).toList();
    } catch (e) {
      print("Error user: $e");
      return [];
    }
  }
}
