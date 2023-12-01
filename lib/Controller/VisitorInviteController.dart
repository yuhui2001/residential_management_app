import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_app/Model/UserData.dart';
import '../Model/EncryptingModel.dart';

class VisitorInviteController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("Invited Visitor List");

  Future invite(String visitorName, int visitorContact, String invitationDate,
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
        "Visitor_Contact": visitorContact,
        "Arrival_Date": arrivalDate,
        "Arrival_Time": arrivalTime,
        "Encrypted_Visitor_Info": EncryptingModel()
            .encrypt(
                "Visitor name: $visitorName \nVisitor contact: $visitorContact \nArrival Date: $arrivalDate \nInvitation date: $invitationDate \nInvitation time: $invitationTime \nInvitor: $userData.name \nInvitor address: $userData.address")
            .base64,
        "Document_Count": documentCount
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
