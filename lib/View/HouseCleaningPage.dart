import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/View/HouseCleaningTermsPage.dart';

const List<String> list = <String>[
  'Basic cleaning',
  'Move in cleaning',
  'Spring cleaning'
];

const Map<String, double> prices = {
  'Basic cleaning': 50.00,
  'Move in cleaning': 200.00,
  'Spring cleaning': 270.00,
};

class HouseCleaningPage extends StatefulWidget {
  const HouseCleaningPage({Key? key}) : super(key: key);

  @override
  _HouseCleaningPageState createState() => _HouseCleaningPageState();
}

class _HouseCleaningPageState extends State<HouseCleaningPage> {
  String dropDownValue = list.first;
  DateTime? date;
  TimeOfDay? startTime;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("House cleaning booking service"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                height: screenHeight * 0.2,
                width: screenWidth * 0.7,
                child: const Text(
                  "House cleaning booking service sdn bhd",
                  style: TextStyle(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text("Type of cleaning service:"),
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
              const SizedBox(
                height: 20.0,
              ),
              const Text("\nDate:\n"),
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
                    date = newDate!; // update the selected date
                  });

                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(newDate);
                  dateController.text = formattedDate;

                  await _showTimePicker();
                },
                child: const Text("Choose date"),
              ),
              const Text("Time:\n"),
              Text(
                startTime != null
                    ? DateFormat('h:mm a').format(DateTime(
                        date!.year,
                        date!.month,
                        date!.day,
                        startTime!.hour,
                        startTime!.minute))
                    : '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: date != null ? _showTimePicker : null,
                child: const Text("Choose time"),
              ),
              Text(
                '\nPrice: RM ${prices[dropDownValue]}\n',
                style: const TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: screenHeight * 0.05),
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Hello"),
                              content: const Text("NI HAO MA"),
                              actions: <Widget>[
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Book now"),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HouseCleaningTermsPage(),
                        ),
                      );
                    },
                    child: const Text("Terms and condition"),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    TimeOfDay? selectedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedStartTime == null) return;

    setState(() {
      startTime = selectedStartTime;
    });

    final formattedTime =
        '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
    timeController.text = formattedTime;
  }
}
