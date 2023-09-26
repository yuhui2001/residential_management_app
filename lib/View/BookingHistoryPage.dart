import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Booking history page"),
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [Text("Welcome to Booking history page")],
          )),
        ));
  }
}
