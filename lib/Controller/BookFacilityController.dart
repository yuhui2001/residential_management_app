// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_app/Model/UserData.dart';
import '../Model/EncryptingModel.dart';

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

      // query to check for overlapping bookings
      QuerySnapshot querySnapshot = await collection
          .where('Facility_ID', isEqualTo: facilityId)
          .where('Booking_Date', isEqualTo: Timestamp.fromDate(bookingDate))
          .get();

      // check if the selected time range overlaps with any existing bookings
      bool isOverlapping = querySnapshot.docs.any((doc) {
        DateTime docStartTime = (doc['Start_Time'] as Timestamp).toDate();
        DateTime docEndTime = (doc['End_Time'] as Timestamp).toDate();

        // Check for overlap or adjacency
        return !(endDateTime.isBefore(docStartTime) ||
            startDateTime.isAfter(docEndTime));
      });

      // If there is an overlapping booking, return false (not available)
      return !isOverlapping;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
      // Return false in case of an error
      return false;
    }
  }

  Future<void> bookFacility(
    DateTime bookingDate,
    TimeOfDay startTime,
    TimeOfDay endTime,
    String facilityID,
    String facilityName,
    String description,
  ) async {
    try {
      final userID = userData.userid;
      final userName = userData.name;

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
        "Facility_Name": facilityName,
        "Description": description,
        "Encrypted_Info": EncryptingModel()
            .encrypt(
                "Booking user: $userName \nBooking userId: $userID \nBooking date: $bookingDate \nStart time: $startTime \nEnd time: $endTime Facility Id: $facilityID")
            .base64
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
        '13:00 PM',
        '14:00 PM',
        '15:00 PM',
        '16:00 PM',
        '17:00 PM',
        '18:00 PM',
        '19:00 PM',
        '20:00 PM',
        '21:00 PM',
        '22:00 PM'
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

          DateTime slotEndTime = slotStartTime.add(const Duration(hours: 1));

          if (!(endDateTime.isBefore(slotStartTime) ||
              startDateTime.isAfter(slotEndTime))) {
            bookedSlots.add(slot);
          }
        }
      });

      // get the available slots by removing booked slots from all slots
      List<String> availableSlots = allSlots
          .where((slot) =>
              !bookedSlots.contains(slot) &&
              !bookedSlots.contains(
                  allSlots[(allSlots.indexOf(slot) + 1) % allSlots.length]))
          .toList();

      return availableSlots;
    } catch (e) {
      print("Error fetching available slots: $e");
      return [];
    }
  }
}
