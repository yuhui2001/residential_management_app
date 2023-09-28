import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_app/Model/UserData.dart';

class VisitorInviteController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("Invited Visitor List");

  Future invite(
    String visitorName,
    int phoneNumber,
    String invitationDate,
    String invitationTime,
  ) async {
    try {
      final userID = userData.userid;
      final postData = {
        "User_ID": userID,
        "Invitation_Date": invitationDate,
        "Invitation_Time": invitationTime,
        "Visitor_Name": visitorName,
        "Visitor_Contact": phoneNumber,
        "QR": "",
      };

      await collection.add(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }
}
