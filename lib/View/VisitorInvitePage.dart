import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/VisitorInviteController.dart';
import 'package:residential_management_app/Controller/VisitorInviteHistoryController.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/Controller/VisitorFavoriteController.dart';
import 'package:residential_management_app/View/VisitorQRPage.dart';
import 'package:residential_management_app/Model/EncryptingModel.dart';

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
  // ignore: library_private_types_in_public_api
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late DateTime? date;
  TimeOfDay? time;
  DateTime currentDate = DateTime.now();
  final userData = UserData.user!;

  final TextEditingController arrivalDateController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();

  bool isCreateInviteButtonEnabled() {
    return widget.nameController.text.isNotEmpty &&
        widget.phoneNumberController.text.isNotEmpty &&
        arrivalDateController.text.isNotEmpty &&
        arrivalTimeController.text.isNotEmpty;
  }

  handleButtonPress() {
    final visitorName = widget.nameController.text;
    final int visitorNumber = int.parse(widget.phoneNumberController.text);
    final String inviteDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final String inviteTime = DateFormat('Hm').format(currentDate);
    final String arrivalDate = arrivalDateController.text;
    final String arrivalTime = arrivalTimeController.text;
    final encryptedVisitorInfo = EncryptingModel().encrypt(
        "Visitor name: $visitorName \nVisitor contact: $visitorNumber \nArrival Date: $arrivalDate \nInvitation date: $inviteDate \nInvitation time: $inviteTime \nInvitor: $userData.name \nInvitor address: $userData.address");

    VisitorInviteController().invite(visitorName, visitorNumber, inviteDate,
        inviteTime, arrivalDate, arrivalTime);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VisitorQRPage(
                visitorName: visitorName,
                visitorContact: visitorNumber,
                ownerAddress: userData.address,
                encryptedVisitorInfo: encryptedVisitorInfo.base64)));
  }

  Future<void> _showTimePicker() async {
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
    arrivalTimeController.text = formattedTime;
  }

  @override
  void initState() {
    super.initState();
    date = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Visitor name: "),
            TextFormField(
              controller: widget.nameController,
              decoration: const InputDecoration(
                hintText: "Example: Smartjiran or smartjiran",
              ),
              onChanged: (value) {
                setState(() {}); // rebuilt ui after input changed
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text("Visitor phone number: "),
            TextFormField(
              controller: widget.phoneNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                prefixText: "+60",
                hintText: " Example: 123456789",
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const Text(""),
            const Text("Arrival date:\n"),
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
                  date = newDate; // update the selected date
                });

                final formattedDate = newDate.toString();
                arrivalDateController.text = formattedDate;

                _showTimePicker();
              },
              child: const Text("Choose date"),
            ),
            const Text(""),
            const Text("Arrival time:\n"),
            Text(
              time != null
                  ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}\n'
                  : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                _showTimePicker();
              },
              child: const Text("Choose time"),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => VisitorFavPage(
                                  nameController: widget.nameController,
                                  phoneNumberController:
                                      widget.phoneNumberController,
                                )),
                          ),
                        );
                      },
                      child: const Text("Favorite List"),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isCreateInviteButtonEnabled()
                          ? () async {
                              await handleButtonPress();
                            }
                          : null,
                      child: const Text("Create invite"),
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

class InviteHistory {
  final String visitorName;
  final String visitorNumber;
  final String encryptedVisitor;

  InviteHistory(
      {required this.visitorName,
      required this.visitorNumber,
      required this.encryptedVisitor});

  factory InviteHistory.fromMap(Map<String, dynamic> map) {
    return InviteHistory(
        visitorName: map['Visitor_Name'],
        visitorNumber: map['Invitation_Contact'],
        encryptedVisitor: map['Encrypted_Visitor_Info']);
  }
}

class InviteHistoryPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController visitorDateController;
  final TabController tabController;

  const InviteHistoryPage({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
    required this.visitorDateController,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!;
    final userId = userData.userid;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<List<List<dynamic>>>(
        future: VisitorInviteHistoryController(userId).getInviteHistory(),
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
                    String visitorName = data[0];
                    DateTime arrivalDate = DateTime.parse(data[1]);
                    String formatedArrivalDate =
                        DateFormat('dd MMM yy').format(arrivalDate);
                    String arrivalTime = data[2];
                    String visitorContact = data[3];
                    DateTime invitationDate = DateTime.parse(data[4]);
                    String formattedInvitationDate =
                        DateFormat('dd MMM yy').format(invitationDate);
                    String invitationTime = data[5];
                    String encryptedVisitor = data[6];

                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(visitorName),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            "Visit date and time:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(children: [
                            Text(formatedArrivalDate),
                            const Text("  "),
                            Text(arrivalTime),
                          ]),
                          SizedBox(height: screenHeight * 0.01),

                          ///
                          const Text(
                            "Invite date and time:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(children: [
                            Text(formattedInvitationDate),
                            const Text("  "),
                            Text(invitationTime),
                          ]),
                          SizedBox(height: screenHeight * 0.01),

                          ///

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  nameController.text = visitorName;
                                  phoneNumberController.text = visitorContact;

                                  // switch to inv tab
                                  tabController.animateTo(0);
                                },
                                child: const Text("Reinvite"),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VisitorQRPage(
                                                  visitorName: visitorName,
                                                  visitorContact:
                                                      int.parse(visitorContact),
                                                  ownerAddress:
                                                      userData.address,
                                                  encryptedVisitorInfo:
                                                      encryptedVisitor,
                                                )));
                                  },
                                  child: const Text("View"))
                            ],
                          )
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

class FavList {
  final String visitorName;
  final String visitorNumber;

  FavList({
    required this.visitorName,
    required this.visitorNumber,
  });

  factory FavList.fromMap(Map<String, dynamic> map) {
    return FavList(
      visitorName: map['Visitor_Name'],
      visitorNumber: map['Invitation_Contact'],
    );
  }
}

class VisitorFavPage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;

  const VisitorFavPage({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VisitorFavPageState createState() => _VisitorFavPageState();
}

class _VisitorFavPageState extends State<VisitorFavPage> {
  late List<List<dynamic>> favList;

  @override
  void initState() {
    super.initState();
    favList = [];
    loadFavList();
  }

  Future<void> loadFavList() async {
    final userData = UserData.user!;
    final userId = userData.userid;
    final loadedList = await VisitorFavListController(userId).getFavList();
    setState(() {
      favList = loadedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserData.user!;
    final userId = userData.userid;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite List"),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: VisitorFavListController(userId).getFavList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<List<dynamic>> favList = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Column(
                children: favList.map(
                  (data) {
                    String visitorName = data[0];
                    String visitorContact = data[1];

                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name:\n$visitorName",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Phone Number:\n+60$visitorContact",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  widget.nameController.text = visitorName;
                                  widget.phoneNumberController.text =
                                      visitorContact;
                                  Navigator.pop(context);
                                },
                                child: const Text("Invite"),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              //////////////////////////////////////
                              ElevatedButton(
                                onPressed: () async {
                                  VisitorFavListController(userId)
                                      .removeFromFavList(
                                          visitorName, visitorContact);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Removed $visitorName from favorites.'),
                                    ),
                                  );
                                  await loadFavList();
                                },
                                child: const Text("Remove"),
                              ),
                            ],
                          )
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

class VisitorInvitePage extends StatefulWidget {
  final String? visitorName;
  final String? visitorContact;

  const VisitorInvitePage({
    super.key,
    this.visitorName,
    this.visitorContact,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VisitorInvitePageState createState() => _VisitorInvitePageState();
}

class _VisitorInvitePageState extends State<VisitorInvitePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titles.length, vsync: this);
    nameController = TextEditingController(text: widget.visitorName ?? "");
    phoneNumberController =
        TextEditingController(text: widget.visitorContact ?? "");
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController visitorDateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite Visitor Page"),
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
            visitorDateController: visitorDateController,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}
