import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/View/ProfilePage.dart';
import 'package:residential_management_app/Controller/AnnouncementController.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final int _selectedIndex = 1;
  final AnnouncementController announcementController =
      AnnouncementController();
  String? selectedType;

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
                return AnnouncementPage();
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    selectedType = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Announcement",
            style: TextStyle(fontSize: 30),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: announcementController.getAnnouncements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<Map<String, dynamic>> announcements = snapshot.data ?? [];

            // Filter announcements based on selected type
            List<Map<String, dynamic>> filteredAnnouncements =
                selectedType == null
                    ? announcements
                    : announcements
                        .where((announcement) =>
                            announcement['Announcement_Type'] == selectedType)
                        .toList();

            return Column(
              children: [
                // Dropdown for filtering by type
                DropdownButton<String>(
                  hint: Text('Filter by Type'),
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value == 'All' ? null : value;
                    });
                  },
                  items:
                      ['All', ...announcementController.getTypes()].map((type) {
                    return DropdownMenuItem<String>(
                      value: type == 'All' ? null : type,
                      child: Text(type),
                    );
                  }).toList(),
                ),

                // Display filtered announcements
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredAnnouncements.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = filteredAnnouncements[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: ListTile(
                              title: Text(
                                '${data['Announcement_Title']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 26),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type: ${data['Announcement_Type']}\n',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    '${data['Announcement_Content']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
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
