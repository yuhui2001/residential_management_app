import 'package:flutter/material.dart';

class BookFacilityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Book a facility page"),
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [Text("Welcome to book facility page")],
          )),
        ));
  }
}
