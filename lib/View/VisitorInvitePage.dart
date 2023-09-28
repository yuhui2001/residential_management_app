import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/VisitorInviteController.dart';
import 'package:residential_management_app/View/VisitorQRPage.dart';

List<String> titles = <String>['Invite', 'History'];

class InvitePage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TabController tabController;

  const InvitePage({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
    required this.tabController,
  }) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late DateTime date;
  TimeOfDay? time;
  final TextEditingController visitorDateController = TextEditingController();
  final TextEditingController visitorTimeController = TextEditingController();

  handleButtonPress() {
    final visitorName = widget.nameController.text;
    final int visitorNumber = int.parse(widget.phoneNumberController.text);
    final String visitorDate = visitorDateController.text;
    final String visitorTime = visitorTimeController.text;

    VisitorInviteController()
        .invite(visitorName, visitorNumber, visitorDate, visitorTime);
  }

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Visitor name: "),
            TextFormField(
              controller: widget.nameController,
              decoration: InputDecoration(
                  hintText: "Example: Smartjiran or smartjiran"),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),

            /////////////////////
            Text("Visitor phone number: "),
            TextFormField(
              controller: widget.phoneNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: "Example: 0123456789"),
            ),
            Text(""),

            ////////////////////
            Text("Date:\n"),
            Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : "", // show selected date or nothing if none chosen
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(""),
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (newDate == null) return;

                setState(() {
                  date = newDate; // update the selected date
                });

                final formattedDate = '${newDate.toString()}';
                visitorDateController.text = formattedDate;
              },
              child: Text("Choose date"),
            ),
            Text(""),

            ////////////////////
            Text("Time:\n"),
            Text(
              time != null
                  ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}\n'
                  : '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime == null) return;

                setState(() {
                  time = selectedTime;
                });

                final formattedTime =
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                visitorTimeController.text = formattedTime;
              },
              child: Text("Choose time"),
            ),

            Spacer(),

            /////////////////
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Favorite List"),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),

                  ////////////////////////
                  Container(
                    height: 60,
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        await handleButtonPress();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitorQRPage()));
                      },
                      child: Text("Create invite"),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InviteHistoryPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TabController tabController;

  const InviteHistoryPage({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Pass text to InvitePage for both Name and Phone number fields
              nameController.text = "I AM NAME";
              phoneNumberController.text = "0125698753";

              // Switch to the Invite tab
              tabController.animateTo(0);
            },
            child: Text("Pass Text and Switch"),
          ),
        ],
      ),
    );
  }
}

class VisitorInvitePage extends StatefulWidget {
  @override
  _VisitorInvitePageState createState() => _VisitorInvitePageState();
}

class _VisitorInvitePageState extends State<VisitorInvitePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Invite Visitor Page"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: titles[0]),
            Tab(text: titles[1]),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InvitePage(
            nameController: nameController,
            phoneNumberController: phoneNumberController,
            tabController: _tabController,
          ),
          InviteHistoryPage(
            nameController: nameController,
            phoneNumberController: phoneNumberController,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}
