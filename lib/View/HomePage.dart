// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:residential_management_app/View/AnnouncementPage.dart';
import 'package:residential_management_app/View/BookFacilityPage.dart';
import 'package:residential_management_app/View/ProfilePage.dart';
import 'package:residential_management_app/View/TransactionHistoryPage.dart';
import 'package:residential_management_app/View/VisitorInvitePage.dart';
import 'package:residential_management_app/View/FileReportPage.dart';
import 'package:residential_management_app/View/ScheduleEventPage.dart';
import 'package:residential_management_app/View/HouseCleaningPage.dart';
import 'package:residential_management_app/View/MaintenancePage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:residential_management_app/Controller/PaymentController.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/Controller/HomePageController.dart';

final userData = UserData.user!;
final userid = userData.userid;
DateTime currentDate = DateTime.now();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  Timer? countdownTimer;
  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
  String monthlyStatus = 'unpaid';

  @override
  void initState() {
    super.initState();
    fetchMonthlyStatus();
  }

  Future<void> fetchMonthlyStatus() async {
    try {
      List<String> monthlyStatusList =
          await HomePageController(userid).getMonthlyStatus();

      if (monthlyStatusList.isNotEmpty) {
        setState(() {
          monthlyStatus = monthlyStatusList.first;
        });
      }
    } catch (e) {
      print('Error fetching monthly status: $e');
    }
  }

  Future<void> makePayment() async {
    try {
      // get the payment intent from the server
      int amount = monthlyStatus == 'paid' ? 0 : 10000;

      // fetch Payment Intent from the server
      Map<String, dynamic>? paymentIntent =
          await PaymentController.createPaymentIntent(amount);

      print('Payment Intent: $paymentIntent');

      // Initialize payment sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.dark,
          merchantDisplayName: 'Smart Jiran',
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntent['client_secret'],
        ),
      )
          .then((value) {
        print('Payment Sheet Initialized Successfully');
      });

      // Display payment sheet
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // Handle payment success or failure
        String type = 'Monthly maintenance bill';
        double formattedAmount = (amount / 100);
        await PaymentController().donePayment(
            formattedAmount.toString(), formattedCurrentDate, type);
        print('Payment Success');
        await PaymentController().updateMonthlyPaymentStatus('paid');
        paymentIntent = null;
        setState(() {
          monthlyStatus = 'paid';
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionHistoryPage()));
        ModalRoute.of(context)!.addLocalHistoryEntry(
          LocalHistoryEntry(onRemove: () {
            // This callback will be called when the page is popped
            setState(() {});
          }),
        );
      });
    } catch (e) {
      print('Error during payment: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index !=
        _selectedIndex) // make the page button will not do anything at that page
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            switch (index) {
              case 1:
                return const AnnouncementPage();
              case 2:
                return const ProfilePage();
              default:
                return const HomePage();
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String currentMonth = DateFormat('MMMM').format(DateTime.now());
    print(monthlyStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Home",
            style: TextStyle(fontSize: 30),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Maintenance fee for $currentMonth:",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RM ${monthlyStatus == 'paid' ? '0' : '100'}",
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              const Text(""),
              ElevatedButton(
                onPressed: monthlyStatus != 'paid'
                    ? () async {
                        try {
                          await makePayment();
                        } catch (error) {
                          print('Error during payment button press: $error');
                        }
                      }
                    : null, // Set onPressed to null when amount is 0
                child: SizedBox(
                  width: screenWidth * 0.2,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Pay",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Second row
              GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05, right: screenWidth * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  List<Widget> buttons = [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VisitorInvitePage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Visitor",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookFacilityPage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Book a",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "facility",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    // Third row
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FileReportPage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "File a\n Report",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ScheduleEventPage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Schedule an",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "event",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    // Fourth Row
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HouseCleaningPage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "House",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Cleaning",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    // Maintenance request button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MaintenancePage()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Maintenance",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Request",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ];

                  if (index < buttons.length) {
                    return buttons[index];
                  }
                  return const SizedBox
                      .shrink(); // Return an empty space if index is out of range
                },
              ),

              // Fifth row
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            int secondsRemaining = 5;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                void startCountdown() {
                                  countdownTimer = Timer.periodic(
                                    const Duration(seconds: 1),
                                    (timer) {
                                      setState(() {
                                        if (secondsRemaining > 0) {
                                          secondsRemaining--;
                                        } else {
                                          timer.cancel();
                                          Navigator.of(context).pop();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: null,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      "\nGuard called",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            20), // Add spacing
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      });
                                    },
                                  );
                                }

                                startCountdown(); // start the countdown timer initially

                                return AlertDialog(
                                  title: const Text(
                                    "Emergency",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Calling the guard in:\n",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "$secondsRemaining seconds",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 20), // add spacing
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              countdownTimer
                                                  ?.cancel(); // Cancel the countdown timer
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                          height: 60,
                          child: Center(
                            child: Text(
                              "Emergency",
                              style: TextStyle(fontSize: 30),
                            ),
                          )),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
