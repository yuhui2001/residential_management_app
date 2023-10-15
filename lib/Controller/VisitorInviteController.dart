import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:qr_flutter/qr_flutter.dart';

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
      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;
      String invitationID = "INV${documentCount + 1}";

      final userID = userData.userid;
      final documentName = "INV ${documentCount + 1}";

      final postData = {
        "User_ID": userID,
        "Invitation_ID": invitationID,
        "Invitation_Date": invitationDate,
        "Invitation_Time": invitationTime,
        "Visitor_Name": visitorName,
        "Visitor_Contact": phoneNumber,
      };

      await collection.doc(documentName).set(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }

  // Function to generate a unique identifier
  String generateUniqueIdentifier(String userID, String documentName) {
    return "$userID-$documentName";
  }

  // Function to encrypt visitor name
  String encryptVisitorName(String visitorName, String uniqueIdentifier) {
    final keyString = "CreatedbYyeeehUI"; // Replace with your secret key
    final key = encrypt.Key.fromUtf8(keyString);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final initVector = encrypt.IV.fromUtf8(keyString.substring(0, 16));

    final encryptedVisitorName =
        encrypter.encrypt(visitorName + uniqueIdentifier, iv: initVector);
    return encryptedVisitorName
        .base64; // Return the base64-encoded encrypted data
  }
}
