import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:http/http.dart' as http;

class PaymentController {
  final userData = UserData.user!;
  final collection = FirebaseFirestore.instance.collection("Payment History");
  static const String _stripeSecretKey =
      'sk_test_51OBXVlGUVzRz1fshV5NxJop2M4zzP1YLAioVaSdXhPisYU0MnrVSBDF2I36QpqO9ArYWCMG4GYT4mwtFxPqQpdUq00fN3IkNr8';

  static Future<Map<String, dynamic>> createPaymentIntent(int amount) async {
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': amount.toString(),
          'currency': 'myr',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (error) {
      throw Exception('Error creating payment intent: $error');
    }
  }

  Future donePayment(
      String amount, String paymentDate, String paymentType) async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;
      String paymentId = "PAY${documentCount + 1}";

      final userID = userData.userid;
      final documentName = "Payment ${documentCount + 1}";

      final postData = {
        "User_ID": userID,
        "Payment_ID": paymentId,
        "Payment_Date": paymentDate,
        "Payment_Type": paymentType,
        "Payment_Amount": amount
      };

      await collection.doc(documentName).set(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }
}
