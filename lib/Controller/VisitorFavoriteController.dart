import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_app/Model/UserData.dart';

class VisitorFavoriteController {
  final userData = UserData.user!;
  final collection =
      FirebaseFirestore.instance.collection("Favourite Visitor List");

  Future addFav(String visitorName, phoneNumber) async {
    try {
      final userID = userData.userid;

      // Get the current count of documents in the collection
      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      // generate the next Favourite_ID
      String favouriteID = "FAV${documentCount + 1}";

      final postData = {
        "Favourite_ID": favouriteID,
        "User_ID": userID,
        "Visitor_Name": visitorName,
        "Visitor_Contact": phoneNumber,
      };

      await collection.add(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }
}

class VisitorFavListController {
  final String userId;

  VisitorFavListController(this.userId);

  final collection =
      FirebaseFirestore.instance.collection("Favourite Visitor List");

  Future<List<List<String>>> getFavList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('User_ID', isEqualTo: userId).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        String visitorName = doc['Visitor_Name'];
        dynamic visitorNumber = doc['Visitor_Contact'];

        return [visitorName, visitorNumber.toString()];
      }).toList();
    } catch (e) {
      print("Error fetching invite history: $e");
      return [];
    }
  }
}
