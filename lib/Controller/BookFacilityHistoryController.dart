import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookFacilityHistoryController {
  final String userId;

  BookFacilityHistoryController(this.userId);

  final collection = FirebaseFirestore.instance
      .collection("Booking History")
      .orderBy("Booking_Date", descending: true);

  Future<List<List<String>>> getBookingHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('User_ID', isEqualTo: userId).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      return documents.map((doc) {
        Timestamp bookingDateTimestamp = doc['Booking_Date'];
        DateTime bookingDate = bookingDateTimestamp.toDate();

        // Convert start time and end time from Timestamp to DateTime
        Timestamp startTimeTimestamp = doc['Start_Time'];
        DateTime startTime = startTimeTimestamp.toDate();

        Timestamp endTimeTimestamp = doc['End_Time'];
        DateTime endTime = endTimeTimestamp.toDate();

        String facilityName = doc['Facility_Name'];
        String encryptedBookingInfo = doc['Encrypted_Info'];

        String formattedBookingDate =
            DateFormat('yyyy-MM-dd').format(bookingDate);
        String formattedStartTime = DateFormat('HH:mm').format(startTime);
        String formattedEndTime = DateFormat('HH:mm').format(endTime);

        return [
          formattedBookingDate,
          formattedStartTime,
          formattedEndTime,
          facilityName,
          encryptedBookingInfo
        ];
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching invite history: $e");
      return [];
    }
  }
}
