import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class BookingHistoryContentPage extends StatelessWidget {
  final String bookingUser;
  final String userBookedDate;
  final String startTime;
  final String endTime;
  final String facilityName;
  final String encryptedBookingInfo;

  const BookingHistoryContentPage(
      {super.key,
      required this.bookingUser,
      required this.userBookedDate,
      required this.startTime,
      required this.endTime,
      required this.facilityName,
      required this.encryptedBookingInfo});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Facility booked page")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: Container(
                height: screenWidth * 0.7,
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: QrImageView(
                  data: encryptedBookingInfo,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(bookingUser),
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    "Facility:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(facilityName),
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    "Start time:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(startTime),
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    "End time:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(endTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
