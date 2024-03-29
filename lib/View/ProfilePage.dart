// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:residential_management_app/View/BookingHistoryPage.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/View/AnnouncementPage.dart';
import 'package:residential_management_app/View/LoginPage.dart';
import 'package:residential_management_app/View/TransactionHistoryPage.dart';
import 'package:residential_management_app/Model/UserData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 2;

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
                return const HomePage();
              case 1:
                return const AnnouncementPage();
              default:
                return ProfilePage();
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!; // to state that i is not null
    final name = userData.name;
    final address = userData.address;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Profile",
          style: TextStyle(fontSize: 30),
        )),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05, top: screenHeight * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(name)
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Container(
            padding: EdgeInsets.only(left: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(address)
              ],
            ),
          ),
          const Spacer(), // to push the buttons to bottom

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
                  child: SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Booking history",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
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
                            builder: (context) =>
                                const TransactionHistoryPage()));
                  },
                  child: SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: const Center(
                      child: Text("Transaction history",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ],
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
