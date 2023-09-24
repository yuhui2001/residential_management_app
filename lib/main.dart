import 'package:flutter/material.dart';
import 'package:residential_management_app/AnnouncementPage.dart';
import 'package:residential_management_app/FileReportPage.dart';
import 'package:residential_management_app/HomePage.dart';
import 'package:residential_management_app/HouseCleaningPage.dart';
import 'package:residential_management_app/LoginPage.dart';
import 'package:residential_management_app/ProfilePage.dart';
import 'package:residential_management_app/VisitorInvitePage.dart';

void main() {
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
      home: FileReportPage(),
    );
  }
}
