import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Badminton Court A',
  'Badminton Court B',
  'Basketball Court',
  'Tennis Court'
];

class MaintenanceRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Maintenance request page"),
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [Text("Welcome to maintenance request page")],
          )),
        ));
  }
}
