import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Pest control',
  'Leaking issue',
  'Electrical issue',
];

List<String> titles = <String>['Request', 'History'];

class MaintenanceRequestPage extends StatefulWidget {
  const MaintenanceRequestPage({Key? key}) : super(key: key);

  @override
  State<MaintenanceRequestPage> createState() => _MaintenanceRequestPageState();
}

class _MaintenanceRequestPageState extends State<MaintenanceRequestPage> {
  String dropDownValue = list.first;
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance request page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.01, top: screenHeight * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Type:",
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
              const Text("Description:\n"),
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
                  onPressed: () {},
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
