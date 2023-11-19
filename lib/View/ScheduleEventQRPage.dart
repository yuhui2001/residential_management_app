import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class ScheduleEventQRPage extends StatelessWidget {
  final String bookingUser;
  final String encryptedBookingUser;
  final String userAddress;
  final String userBookedDate;
  final String startTime;
  final String endTime;
  final String facilityId;

  const ScheduleEventQRPage(
      {super.key,
      required this.bookingUser,
      required this.encryptedBookingUser,
      required this.userAddress,
      required this.userBookedDate,
      required this.startTime,
      required this.endTime,
      required this.facilityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facility booked page")),
    );
  }
}
