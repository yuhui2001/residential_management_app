import 'package:flutter/material.dart';
import 'package:residential_management_app/BookingHistoryPage.dart';
import 'package:residential_management_app/HomePage.dart';
import 'package:residential_management_app/AnnouncementPage.dart';
import 'package:residential_management_app/LoginPage.dart';
import 'package:residential_management_app/TransactionHistoryPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index !=
        _selectedIndex) //make that page button will not do anything at that page
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            switch (index) {
              case 0:
                return HomePage();
              case 1:
                return AnnouncementPage();
              default:
                return ProfilePage(); // Default to the first screen
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Profile",
          style: TextStyle(fontSize: 30),
        )),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, top: screenHeight * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name:",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Person 1",
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address:"),
                  Text("Some address"),
                ],
              ),
            ),
            Spacer(), // to push the buttons to bottom

            // buttons at bellow
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingHistoryPage()));
                    },
                    child: Container(
                      width: screenWidth * 0.3,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Booking history",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionHistoryPage()));
                    },
                    child: Container(
                      width: screenWidth * 0.3,
                      height: 50,
                      child: Center(
                        child: Text("Transaction history",
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Container(
                      width: screenWidth * 0.3,
                      height: 50,
                      child: Center(
                        child: Text("Logout", style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ],
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