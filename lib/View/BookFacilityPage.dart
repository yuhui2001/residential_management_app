import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/BookFacilityController.dart';

const List<String> list = <String>[
  'Badminton Court A',
  'Badminton Court B',
  'Basketball Court',
  'Tennis Court'
];

class BookFacilityPage extends StatefulWidget {
  const BookFacilityPage({Key? key}) : super(key: key);

  @override
  State<BookFacilityPage> createState() => _BookFacilityPageState();
}

class _BookFacilityPageState extends State<BookFacilityPage> {
  String dropdownValue = list.first;
  late DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  String mapFacilityToCode(String facility) {
    switch (facility) {
      case 'Badminton Court A':
        return 'FAC1';
      case 'Badminton Court B':
        return 'FAC2';
      case 'Basketball Court':
        return 'FAC3';
      case 'Tennis Court':
        return 'FAC4';
      default:
        return '';
    }
  }

  Future<void> handleButtonPress() async {
    try {
      final DateTime bookingDate = DateTime.parse(dateController.text);

      if (endTime != null && startTime != null) {
        final String startTimeString =
            '${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}';
        final String endTimeString =
            '${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}';

        if (endTimeString.compareTo(startTimeString) <= 0) {
          // Show error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("End time must be after start time."),
                actions: [
                  TextButton(
                    onPressed: () {
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
          return; // Don't proceed with booking if end time is before or equal to start time
        }
      }

      final facility = dropdownValue;
      final facilityCode = mapFacilityToCode(facility);

      // Check availability
      bool isAvailable = await BookFacilityController()
          .checkAvailable(facilityCode, bookingDate, startTime!, endTime!);

      if (isAvailable) {
        // Facility is available, proceed with booking
        await BookFacilityController()
            .bookFacility(bookingDate, startTime!, endTime!, facilityCode);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Facility booked"),
              actions: [
                TextButton(
                  onPressed: () {
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
      } else {
        // Facility is not available, show a message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("Facility is not available for the selected time slot."),
              actions: [
                TextButton(
                  onPressed: () {
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
      }
    } catch (e) {
      print("Error handling button press: $e");
    }
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
      appBar: AppBar(
        title: Text("Book a facility page"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: screenWidth * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type of facility"),
            /////////
            Container(
              width: screenWidth * 0.5,
              height: 60,
              child: DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries: list.map<DropdownMenuEntry<String>>(
                  (String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  },
                ).toList(),
              ),
            ),

            Text("Date:\n"),
            Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date!)
                  : "", // show selected date or nothing if none chosen
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(""),
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (newDate == null) {
                  newDate = DateTime.now();
                }

                setState(() {
                  date = newDate!; // update the selected date
                });

                final formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
                dateController.text = formattedDate;
              },
              child: Text("Choose date"),
            ),

            Text("\nStart time:\n"),
            Text(
              startTime != null
                  ? DateFormat('h:mm a').format(DateTime(
                      date!.year,
                      date!.month,
                      date!.day,
                      startTime!.hour,
                      startTime!.minute))
                  : '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: date != null
                  ? () async {
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
                      startTimeController.text = formattedTime;
                    }
                  : null, // Disable button if date is not chosen
              child: Text("Choose time"),
            ),

            Text("\nEnd time:\n"),
            Text(
              endTime != null
                  ? DateFormat('h:mm a').format(DateTime(date!.year,
                      date!.month, date!.day, endTime!.hour, endTime!.minute))
                  : '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: date != null
                  ? () async {
                      TimeOfDay? selectedEndTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedEndTime == null) return;

                      setState(() {
                        endTime = selectedEndTime;
                      });

                      final formattedTime =
                          '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}';
                      endTimeController.text = formattedTime;
                    }
                  : null, // Disable button if date is not chosen
              child: Text("Choose time"),
            ),

            Spacer(),

            Align(
              alignment: Alignment.center,
              child: Container(
                height: 60,
                width: screenWidth * 0.3,
                child: ElevatedButton(
                  onPressed:
                      (date != null && startTime != null && endTime != null)
                          ? () => handleButtonPress()
                          : null,
                  child: Text("Book now"),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            )
          ],
        ),
      ),
    );
  }
}
