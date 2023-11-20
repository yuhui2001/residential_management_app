// ignore: file_names
import 'package:flutter/material.dart';
import 'package:residential_management_app/Controller/PaymentHistoryController.dart';
import 'package:residential_management_app/Model/UserData.dart';

class TransactionHistory {
  final String paymentAmount;
  final String paymentDate;
  final String paymentId;
  final String paymentType;

  TransactionHistory({
    required this.paymentAmount,
    required this.paymentDate,
    required this.paymentId,
    required this.paymentType,
  });

  factory TransactionHistory.fromMap(Map<String, dynamic> map) {
    return TransactionHistory(
      paymentAmount: map['Payment_Amount'],
      paymentDate: map['Payment_Date'],
      paymentId: map['Payment_ID'],
      paymentType: map['Payment_Type'],
    );
  }
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!;
    final userId = userData.userid;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction history page"),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: PaymentHistoryController(userId).getPaymentHistory(),
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
                    String paymentAmount = data[0];
                    String paymentDate = data[1];
                    String paymentId = data[2];
                    String paymentType = data[3];

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
                            "Payment ID:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(paymentId),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            "Payment type:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(paymentType),
                          SizedBox(height: screenHeight * 0.01),

                          const Text("Payment Amount:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(paymentAmount),
                          SizedBox(height: screenHeight * 0.01),

                          ///
                          const Text(
                            "Payment Date:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(paymentDate),
                          SizedBox(height: screenHeight * 0.01),
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
