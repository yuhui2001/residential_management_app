import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/MaintenanceHistoryController.dart';
import 'package:residential_management_app/Controller/MaintenanceController.dart';
import 'package:residential_management_app/Model/UserData.dart';

const List<String> list = <String>[
  'Pest control',
  'Leaking issue',
  'Electrical issue',
  'Other',
];

List<String> titles = <String>['Request', 'History'];
DateTime currentDate = DateTime.now();

class MaintenanceRequest extends StatefulWidget {
  const MaintenanceRequest({Key? key}) : super(key: key);

  @override
  State<MaintenanceRequest> createState() => _MaintenanceRequestState();
}

class _MaintenanceRequestState extends State<MaintenanceRequest> {
  String dropDownValue = list.first;
  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.01, top: screenHeight * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Type:",
                style: TextStyle(fontSize: 20),
              ),
              DropdownButton<String>(
                value: dropDownValue,
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Text(
                "\nDescription:\n",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth * 0.9,
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                          bottom: screenWidth * 0.15,
                          top: screenHeight * 0.01,
                          left: screenWidth * 0.01),
                      isCollapsed: true,
                      labelText: "Enter description"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    MaintenanceController().makeRequest(formattedCurrentDate,
                        dropDownValue, descriptionController.text);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Request submission",
                            style: TextStyle(fontSize: 20),
                          ),
                          content: const Text(
                            "Request submitted",
                            style: TextStyle(fontSize: 16),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Requets now"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Completed':
      return Colors.green;
    case 'Incomplete':
      return Colors.red;
    case 'Pending':
      return Colors.yellow;
    default:
      return Colors.transparent; // default color
  }
}

class MaintenanceHistory {
  final String requestId;
  final String type;
  final String description;
  final String requestDate;
  final String assignedWorker;
  final String workerContact;
  final String status;

  MaintenanceHistory(
      {required this.requestId,
      required this.type,
      required this.description,
      required this.requestDate,
      required this.assignedWorker,
      required this.status,
      required this.workerContact});

  factory MaintenanceHistory.fromMap(Map<String, dynamic> map) {
    return MaintenanceHistory(
        requestId: map['Maintenance_ID'],
        type: map['Maintenance_Type'],
        description: map['Description'],
        requestDate: map['Request_Date'],
        assignedWorker: map['Worker_Name'],
        status: map["Request_Status"],
        workerContact: map["Worker_Contact"]);
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
        future: MaintenanceHistoryController(userId).getMaintenanceHistory(),
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
                    String description = data[3];
                    String maintenanceType = data[4];
                    String workerContact = data[5];
                    String workerName = data[6];

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
                          Text(maintenanceType),
                          SizedBox(height: screenHeight * 0.01),

                          const Text("Description:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(description),
                          SizedBox(height: screenHeight * 0.01),

                          ///
                          const Text(
                            "Request date:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(requestDate),
                          SizedBox(height: screenHeight * 0.01),

                          const Text("Assigned worker:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(workerName),
                          SizedBox(height: screenHeight * 0.01),

                          const Text("Contact number:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(workerContact),
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

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage>
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
        title: const Text("Maintenance request page"),
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
        children: const [MaintenanceRequest(), HistoryPage()],
      ),
    );
  }
}
