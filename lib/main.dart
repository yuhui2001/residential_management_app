import 'package:flutter/material.dart';
import 'package:residential_management_app/View/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:residential_management_app/Controller/CreateUserController.dart';

// if change divice, remember to do flutterfire configure and override directory.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ////////////////////////////////////////////
  //// This block of code is just to create a encrypted user, it will not included in the actual app.
  // const String documentName = "encrypted User";
  // const String username = "encrypt";
  // const String password = "20004156";
  // const String userid = "USR1000";
  // const String name = "Encrypted User";
  // const String address = "Big home";
  // CreateUserController()
  //     .addUser(documentName, username, password, userid, name, address);
  /////////////////////////////////////////////
  ///
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SMART Jiran',
        theme: ThemeData(),
        home: LoginPage());
  }
}
