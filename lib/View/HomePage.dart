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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Timer? countdownTimer;

  void _onItemTapped(int index) {
    if (index !=
        _selectedIndex) // Make the page button will not do anything at that page
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
                return HomePage(); // Default to the first screen
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
                    "RM 100",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Text(""),
              ElevatedButton(
                  onPressed: () {
                    // Show the alert dialog using showDialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Payment"),
                          content: Text("Hello"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the dialog when the button is pressed
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "OK",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                      width: screenWidth * 0.2,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Pay",
                          style: TextStyle(fontSize: 20),
                        ),
                      ))),

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
                  // Replace the content of this builder with your buttons
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
