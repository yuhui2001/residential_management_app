import 'package:flutter/material.dart';

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
