import 'dart:async';
import 'package:flutter/material.dart';
import 'package:residential_management_app/View/AnnouncementPage.dart';
import 'package:residential_management_app/View/BookFacilityPage.dart';
import 'package:residential_management_app/View/ProfilePage.dart';
import 'package:residential_management_app/View/VisitorInvitePage.dart';
import 'package:residential_management_app/View/FileReportPage.dart';
import 'package:residential_management_app/View/ScheduleEventPage.dart';
import 'package:residential_management_app/View/HouseCleaningPage.dart';
import 'package:residential_management_app/View/MaintenancePage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:residential_management_app/Controller/PaymentController.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  Timer? countdownTimer;
  TextEditingController amountController = TextEditingController();

  Future<void> makePayment() async {
    try {
      // Get the payment intent from the server
      int amount = 10000;
      if (amountController.text.isNotEmpty) {
        amount = int.tryParse(amountController.text) ?? 10000;
      }

      // Fetch Payment Intent from the server
      Map<String, dynamic> paymentIntent =
          await PaymentController.createPaymentIntent(amount);

      print('Payment Intent: $paymentIntent');

      // Initialize payment sheet

      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.dark,
          merchantDisplayName: 'Smart Jiran',
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntent[
              'sk_test_51OBXVlGUVzRz1fshV5NxJop2M4zzP1YLAioVaSdXhPisYU0MnrVSBDF2I36QpqO9ArYWCMG4GYT4mwtFxPqQpdUq00fN3IkNr8'],
        ),
      )
          .then((value) {
        print('Payment Sheet Initialized Successfully');
      });

      // Display payment sheet
      await Stripe.instance.presentPaymentSheet().then((value) {
        // Handle payment success or failure
        print('Payment Success');
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
                return AnnouncementPage();
              case 2:
                return ProfilePage();
              default:
                return HomePage();
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
    String currentMonth = new DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Center(
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
                    "$currentMonth bill:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "RM ${amountController.text.isEmpty ? '100' : amountController.text}",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              Text(""),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await makePayment();
                  } catch (error) {
                    print('Error during payment button press: $error');
                  }
                },
                child: Container(
                  width: screenWidth * 0.2,
                  height: 50,
                  child: Center(
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
                physics: NeverScrollableScrollPhysics(),
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
                                builder: (context) => VisitorInvitePage()));
                      },
                      child: Column(
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
                                builder: (context) => BookFacilityPage()));
                      },
                      child: Column(
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
                                builder: (context) => FileReportPage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "File a",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Report",
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
                                builder: (context) => ScheduleEventPage()));
                      },
                      child: Column(
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
                                builder: (context) => HouseCleaningPage()));
                      },
                      child: Column(
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
                                builder: (context) =>
                                    MaintenanceRequestPage()));
                      },
                      child: Column(
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
                  return SizedBox
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
                                    Duration(seconds: 1),
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
                                                    Text(
                                                      "\nGuard Called",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
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
                                                          child: Text(
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

                                startCountdown(); // Start the countdown timer initially

                                return AlertDialog(
                                  title: Text(
                                    "Emergency",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Calling the guard in:\n",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "$secondsRemaining seconds",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 20), // Add spacing
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
                                            child: Text(
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
                      child: Container(
                          width: screenWidth * 0.4,
                          height: 60,
                          child: Center(
                            child: Text(
                              "Emergency",
                              style: TextStyle(fontSize: 30),
                            ),
                          )),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
