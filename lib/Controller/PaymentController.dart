import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentController {
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
}
