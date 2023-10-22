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

  Future<void> bookFacility(DateTime bookingDate, TimeOfDay startTime,
      TimeOfDay endTime, String facilityID, String description) async {
    try {
      final userID = userData.userid;

      QuerySnapshot querySnapshot = await collection.get();
      int documentCount = querySnapshot.docs.length;

      final documentName = "Booking ${documentCount + 1}";

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

      await collection.doc(documentName).set(postData);
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }

  Future<List<String>> getAvailableSlots(
      String facilityId, DateTime bookingDate) async {
    try {
      List<String> allSlots = [
        '08:00 AM',
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '12:00 PM',
        '01:00 PM',
        '02:00 PM',
        '03:00 PM',
        '04:00 PM',
        '05:00 PM',
        '06:00 PM',
        '07:00 PM',
        '08:00 PM',
        '09:00 PM',
        '10:00 PM'
      ];

      // Query to get booked slots for the specified facility and date
      QuerySnapshot querySnapshot = await collection
          .where('Facility_ID', isEqualTo: facilityId)
          .where('Booking_Date', isEqualTo: Timestamp.fromDate(bookingDate))
          .get();

      List<String> bookedSlots = [];

      // Add booked slots to the list
      querySnapshot.docs.forEach((doc) {
        DateTime startDateTime = (doc['Start_Time'] as Timestamp).toDate();
        DateTime endDateTime = (doc['End_Time'] as Timestamp).toDate();

        // Iterate through all slots and mark them as booked if they overlap with any existing booking
        for (String slot in allSlots) {
          DateTime slotStartTime = DateTime(
            bookingDate.year,
            bookingDate.month,
            bookingDate.day,
            int.parse(slot.split(':')[0]),
            int.parse(slot.split(':')[1].split(' ')[0]),
          );

          DateTime slotEndTime = slotStartTime.add(Duration(hours: 1));

          if (!(endDateTime.isBefore(slotStartTime) ||
              startDateTime.isAfter(slotEndTime))) {
            bookedSlots.add(slot);
          }
        }
      });

      // Get the available slots by removing booked slots from all slots
      List<String> availableSlots =
          allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

      return availableSlots;
    } catch (e) {
      print("Error fetching available slots: $e");
      return [];
    }
  }
}
