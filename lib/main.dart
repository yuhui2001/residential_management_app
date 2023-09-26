import 'package:flutter/material.dart';
import 'package:residential_management_app/View/AnnouncementPage.dart';
import 'package:residential_management_app/View/FileReportPage.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/View/HouseCleaningPage.dart';
import 'package:residential_management_app/View/LoginPage.dart';
import 'package:residential_management_app/View/ProfilePage.dart';
import 'package:residential_management_app/View/VisitorInvitePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// if change divice, remember to do flutterfire configure and override directory.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
