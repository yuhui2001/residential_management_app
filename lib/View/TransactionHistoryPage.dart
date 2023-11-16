// ignore: file_names
import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transaction history page"),
        ),
        body: const Center(
            child: Column(
          children: [Text("Welcome to file transaction history page")],
        )));
  }
}
