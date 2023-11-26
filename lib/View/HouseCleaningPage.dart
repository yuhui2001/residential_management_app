// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/HouseCleaningController.dart';
import 'package:residential_management_app/Controller/HouseCleaningHistoryController.dart';
import 'package:residential_management_app/Controller/PaymentController.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/View/HouseCleaningTermsPage.dart';
import 'package:residential_management_app/View/TransactionHistoryPage.dart';

List<String> titles = <String>['Request', 'History'];
DateTime currentDate = DateTime.now();

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

Color getStatusColor(String status) {
  switch (status) {
    case 'Completed':
      return Colors.green;
    case 'Incomplete':
      return Colors.red;
    default:
      return Colors.transparent; //default
  }
}

class HouseCleaningBookingPage extends StatefulWidget {
  const HouseCleaningBookingPage({Key? key}) : super(key: key);

  @override
  _HouseCleaningBookingPageState createState() =>
      _HouseCleaningBookingPageState();
}

class _HouseCleaningBookingPageState extends State<HouseCleaningBookingPage> {
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
        await HouseCleaningController()
            .makeRequest(formattedCurrentDate, dropDownValue);
        print('Payment Success');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionHistoryPage()));
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth * 0.7,
                child: const Text(
                  "House cleaning booking service",
                  style: TextStyle(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Type of cleaning service:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      DropdownButton<String>(
                        value: dropDownValue,
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (date != null && startTime != null)
                          ? () async => await makePayment()
                          : null,
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

    final DateTime chosenDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      selectedStartTime.hour,
      selectedStartTime.minute,
    );

    if (chosenDateTime.hour < 8 || chosenDateTime.hour > 17) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Time"),
            content:
                const Text("The operation hours are between 8 am and 5 pm."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      startTime = selectedStartTime;
    });

    final formattedTime =
        '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
    timeController.text = formattedTime;
  }
}

class HouseCleaningHistory {
  final String requestId;
  final String type;
  final String requestDate;
  final String status;

  HouseCleaningHistory({
    required this.requestId,
    required this.type,
    required this.requestDate,
    required this.status,
  });

  factory HouseCleaningHistory.fromMap(Map<String, dynamic> map) {
    return HouseCleaningHistory(
      requestId: map['Request_ID'],
      type: map['Cleaning_Type'],
      requestDate: map['Request_Date'],
      status: map["Request_Status"],
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!;
    final userId = userData.userid;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<List<List<dynamic>>>(
        future: HouseCleaningHistoryController(userId).getRequestHistory(),
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
                    String requestId = data[0];
                    String requestDate = data[1];
                    String status = data[2];
                    String cleaningType = data[3];

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
                            "Request ID:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(requestId),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            "Type:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(cleaningType),
                          SizedBox(height: screenHeight * 0.01),

                          ///
                          const Text(
                            "Request date:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(requestDate),
                          SizedBox(height: screenHeight * 0.01),

                          const Text("Status:",
                              style: TextStyle(fontWeight: FontWeight.bold)),

                          Container(
                            decoration: BoxDecoration(
                                color: getStatusColor(status),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(4.0),
                            child: Text(status),
                          ),
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

class HouseCleaningPage extends StatefulWidget {
  const HouseCleaningPage({super.key});

  @override
  _HouseCleaningPageState createState() => _HouseCleaningPageState();
}

class _HouseCleaningPageState extends State<HouseCleaningPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("House cleaning booking service"),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: titles[0],
            ),
            Tab(
              text: titles[1],
            )
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [HouseCleaningBookingPage(), HistoryPage()],
      ),
    );
  }
}
