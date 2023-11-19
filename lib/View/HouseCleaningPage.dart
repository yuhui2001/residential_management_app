// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/PaymentController.dart';
import 'package:residential_management_app/View/HouseCleaningTermsPage.dart';
import 'package:residential_management_app/View/TransactionHistoryPage.dart';

const List<String> list = <String>[
  'Basic cleaning',
  'Move in cleaning',
  'Spring cleaning'
];

const Map<String, double> prices = {
  'Basic cleaning': 50.00,
  'Move in cleaning': 200.00,
  'Spring cleaning': 270.00,
};

DateTime currentDate = DateTime.now();

class HouseCleaningPage extends StatefulWidget {
  const HouseCleaningPage({Key? key}) : super(key: key);

  @override
  _HouseCleaningPageState createState() => _HouseCleaningPageState();
}

class _HouseCleaningPageState extends State<HouseCleaningPage> {
  String dropDownValue = list.first;
  DateTime? date;
  TimeOfDay? startTime;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final int _interval = 60;

  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);

  Future<void> makePayment() async {
    try {
      double servicePrice = prices[dropDownValue] ?? 0.0;

      if (servicePrice <= 0) {
        // handle invalid service price
        return;
      }

      int amountInCents = (servicePrice * 100).toInt();

      // Fetch Payment Intent from the server
      Map<String, dynamic>? paymentIntent =
          await PaymentController.createPaymentIntent(amountInCents);

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.dark,
          merchantDisplayName: 'Smart Jiran',
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntent['client_secret'],
        ),
      );

      // Display payment sheet
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // Handle payment success or failure
        String type = 'House cleaning bill: $dropDownValue';
        await PaymentController().donePayment(
          servicePrice.toString(),
          formattedCurrentDate,
          type,
        );
        print('Payment Success');
        paymentIntent = null;
      });
    } catch (e) {
      print('Error during payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("House cleaning booking service"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                height: screenHeight * 0.2,
                width: screenWidth * 0.7,
                child: const Text(
                  "House cleaning booking service sdn bhd",
                  style: TextStyle(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text("Type of cleaning service:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              DropdownButton<String>(
                value: dropDownValue,
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text("\nDate:\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                date != null
                    ? DateFormat('yyyy-MM-dd').format(date!)
                    : "", // show selected date or nothing if none chosen
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(""),
              ElevatedButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  newDate ??= DateTime.now();

                  setState(() {
                    date = newDate!; // update the selected date
                  });

                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(newDate);
                  dateController.text = formattedDate;

                  await _showTimePicker();
                },
                child: const Text("Choose date"),
              ),
              const Text("Time:\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                startTime != null
                    ? DateFormat('h:mm a').format(DateTime(
                        date!.year,
                        date!.month,
                        date!.day,
                        startTime!.hour,
                        startTime!.minute))
                    : '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: date != null ? _showTimePicker : null,
                child: const Text("Choose time"),
              ),
              Text(
                '\nPrice: RM ${prices[dropDownValue]}\n',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: screenHeight * 0.05),
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        await makePayment();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionHistoryPage()));
                      },
                      child: const Text("Book now"),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HouseCleaningTermsPage(),
                        ),
                      );
                    },
                    child: const Text("Terms and condition"),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    TimeOfDay? selectedStartTime = await showIntervalTimePicker(
      context: context,
      interval: _interval,
      initialTime: TimeOfDay(hour: currentDate.hour, minute: 0),
    );

    if (selectedStartTime == null) return;

    setState(() {
      startTime = selectedStartTime;
    });

    final formattedTime =
        '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
    timeController.text = formattedTime;
  }
}
