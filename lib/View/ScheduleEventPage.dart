import 'package:flutter/material.dart';

class ScheduleEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Schedule an event page"),
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [Text("Welcome to schedule an event page")],
          )),
        ));
  }
}
