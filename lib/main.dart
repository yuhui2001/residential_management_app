import 'package:flutter/material.dart';
import 'package:residential_management_app/AnnouncementPage.dart';
import 'package:residential_management_app/FileReportPage.dart';
import 'package:residential_management_app/HomePage.dart';
import 'package:residential_management_app/HouseCleaningPage.dart';
import 'package:residential_management_app/LoginPage.dart';
import 'package:residential_management_app/ProfilePage.dart';
import 'package:residential_management_app/VisitorInvitePage.dart';
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
      home: VisitorInvitePage());
  }
}
