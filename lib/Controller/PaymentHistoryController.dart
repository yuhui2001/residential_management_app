import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryController {
  final String userId;

  PaymentHistoryController(this.userId);

  final collection = FirebaseFirestore.instance.collection("Payment History");
  Future<List<List<String>>> getPaymentHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .where('User_ID', isEqualTo: userId)
          .orderBy("Payment_ID", descending: true)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String paymentAmount = doc['Payment_Amount'];
        String paymentDate = doc['Payment_Date'];
        String paymentId = doc['Payment_ID'];
        String paymentType = doc['Payment_Type'];

        return [
          paymentAmount,
          paymentDate,
          paymentId,
          paymentType,
        ];
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching Payment Request history: $e");
      return [];
    }
  }
}
