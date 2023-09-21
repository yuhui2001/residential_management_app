import 'package:flutter/material.dart';
import 'package:residential_management_app/HomePage.dart';
import 'package:residential_management_app/ProfilePage.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  int _selectedIndex = 1;

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
              case 2:
                return ProfilePage();
              default:
                return AnnouncementPage(); // Default to the first screen
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
          "Anouncement",
          style: TextStyle(fontSize: 30),
        )),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Hello, this is announcement page"),
      ])),
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
