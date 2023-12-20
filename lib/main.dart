import 'package:flutter/material.dart';
import 'package:residential_management_app/View/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:residential_management_app/CreateUser.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// if change divice, remember to do flutterfire configure and override directory.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51OBXVlGUVzRz1fshSDzRO46TASpbvPl7GUy7snSLPQVEsXmvR7tupforRe70cwJQgtdj58MpXpeGtJd4Z356sZXp00sW7LyGkP';
  Stripe.merchantIdentifier = 'hello world';
  ////////////////////////////////////////////
  //// This block of code is just to create a encrypted user, it will not included in the actual app.
  //const String documentName = "user1";
  //const String username = "limeehui";
  //const String password = "20004156";
  //const String userid = "USR1000";
  //const String name = "Lim Ee Hui";
  //const String address =
  //  "23, Jalan Gembira 2, Taman Gembira, 45264, Puchong, Slangor";
  //const String monthlyPaymentStatus = "unpaid";
  //CreateUser().addUser(documentName, username, password, userid, name, address,
  //    monthlyPaymentStatus);
  /////////////////////////////////////////////
  ///
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SMART Jiran',
        theme: ThemeData(),
        home: const LoginPage());
  }
}
