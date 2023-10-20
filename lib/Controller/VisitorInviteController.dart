import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:encrypt/encrypt.dart';

class VisitorInviteController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("Invited Visitor List");

  Encrypted encrypt(String plainText) {
    const keyString = "CreatedbYyeeehUI";
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    return encrypter.encrypt(plainText, iv: initVector);
  }

  Future invite(String visitorName, int phoneNumber, String invitationDate,
      String invitationTime, String arrivalDate, String arrivalTime) async {
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
        "Arrival_Date": arrivalDate,
        "Arrival_Time": arrivalTime,
        "Encrypted_Visitor_Info": encrypt(visitorName).base64
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
}
