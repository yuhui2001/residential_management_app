// ignore: file_names
import 'package:flutter/material.dart';
import 'package:residential_management_app/Controller/BookFacilityHistoryController.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/View/BookingHistoryContentPage.dart';

final userData = UserData.user!;

class BookingHistory {
  final String facilityName;
  final String bookingDate;

  BookingHistory({
    required this.facilityName,
    required this.bookingDate,
  });

  factory BookingHistory.fromMap(Map<String, dynamic> map) {
    return BookingHistory(
      facilityName: map['Facility_Name'],
      bookingDate: map['Booking_Date'],
    );
  }
}

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({Key? key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final userName = userData.name;
  final String userId = userData.userid;
  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!;
    final userId = userData.userid;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking history page"),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: BookFacilityHistoryController(userId).getBookingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<List<dynamic>> inviteHistory = snapshot.data ?? [];

            return SingleChildScrollView(
              child: Column(
                children: inviteHistory.map(
                  (data) {
                    String bookingDate = data[0];
                    String startTime = data[1];
                    String endTime = data[2];
                    String facilityName = data[3];
                    String encryptedBookingInfo = data[4];

                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Facility name:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(facilityName),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            "Booking Date:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(bookingDate),
                          SizedBox(height: screenHeight * 0.01),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingHistoryContentPage(
                                          bookingUser: userName,
                                          startTime: startTime,
                                          endTime: endTime,
                                          facilityName: facilityName,
                                          userBookedDate: bookingDate,
                                          encryptedBookingInfo:
                                              encryptedBookingInfo),
                                ),
                              );
                            },
                            child: const Text("View"),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
