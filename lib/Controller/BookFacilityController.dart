import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_app/Model/UserData.dart';

class BookFacilityController {
  final userData = UserData.user!;
  final collection = FirebaseFirestore.instance.collection("Booking History");

  Future<bool> checkAvailable(String facilityId, DateTime bookingDate,
      TimeOfDay startTime, TimeOfDay endTime) async {
    try {
      DateTime startDateTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        startTime.hour,
        startTime.minute,
      );
      DateTime endDateTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        endTime.hour,
        endTime.minute,
      );

      // Query to check for overlapping bookings
      QuerySnapshot querySnapshot = await collection
          .where('Facility_ID', isEqualTo: facilityId)
          .where('Booking_Date', isEqualTo: Timestamp.fromDate(bookingDate))
          .get();

      List<DocumentSnapshot> overlappingBookings =
          querySnapshot.docs.where((doc) {
        DateTime docStartTime =
            (doc['Start_Time'] as Timestamp).toDate(); // Change this line
        DateTime docEndTime = (doc['End_Time'] as Timestamp).toDate();

        // Check for overlap
        return !(endDateTime.isBefore(docStartTime) ||
            startDateTime.isAfter(docEndTime));
      }).toList();

      // If there are overlapping bookings, return false (not available)
      return overlappingBookings.isEmpty;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
      // Return false in case of an error
      return false;
    }
  }

  Future bookFacility(DateTime bookingDate, TimeOfDay startTime,
      TimeOfDay endTime, String facilityID, String description) async {
    try {
      final userID = userData.userid;

      // Get the current count of documents in the collection
      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      // generate the next Favourite_ID
      String eventID = "EVN${documentCount + 1}";

      final postData = {
        "Booking_Date": Timestamp.fromDate(bookingDate),
        "Start_Time": DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          startTime.hour,
          startTime.minute,
        ),
        "End_Time": DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          endTime.hour,
          endTime.minute,
        ),
        "User_ID": userID,
        "Event_ID": eventID,
        "Facility_ID": facilityID,
        "Description": description
      };

      await collection.add(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }
}
