import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transaction history page"),
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [Text("Welcome to file transaction history page")],
          )),
        ));
  }
}
