// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/BookFacilityController.dart';
import 'package:residential_management_app/Model/EncryptingModel.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/View/BookingHistoryContentPage.dart';

final userData = UserData.user!;

const List<String> list = <String>[
  'Event hall A',
  'Event hall B',
  'Event hall C'
];

class ScheduleEventPage extends StatefulWidget {
  const ScheduleEventPage({Key? key}) : super(key: key);

  @override
  State<ScheduleEventPage> createState() => _ScheduleEventPageState();
}

class _ScheduleEventPageState extends State<ScheduleEventPage> {
  String dropdownValue = list.first;
  late DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final int _interval = 60;
  TimeOfDay currentTime = TimeOfDay.now();
  final userName = userData.name;
  final String userId = userData.userid;

  String mapFacilityToCode(String facility) {
    switch (facility) {
      case 'Event hall A':
        return 'FAC4';
      case 'Event hall B':
        return 'FAC5';
      case 'Event hall C':
        return 'FAC6';
      default:
        return '';
    }
  }

  Future<void> handleButtonPress() async {
    final facility = dropdownValue;
    final facilityCode = mapFacilityToCode(facility);
    final description = descriptionController.text;
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
                title: const Text("Error"),
                content: const Text("End time must be after start time."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "OK",
                    ),
                  ),
                ],
              );
            },
          );
          return; // if end time is before or equal to start time then prevent continue
        }
      }

      // Check availability
      bool isAvailable = await BookFacilityController()
          .checkAvailable(facilityCode, bookingDate, startTime!, endTime!);

      if (isAvailable) {
        // Facility is available, proceed with booking
        await BookFacilityController().bookFacility(bookingDate, startTime!,
            endTime!, facilityCode, dropdownValue, description);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Facility booked"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BookingHistoryContentPage(
                            bookingUser: userName,
                            startTime: startTimeController.text,
                            endTime: endTimeController.text,
                            facilityName: dropdownValue,
                            userBookedDate: bookingDate.toString(),
                            encryptedBookingInfo: EncryptingModel()
                                .encrypt(
                                    "Booking user: $userName \nBooking userId: $userId \nBooking date: $bookingDate \nStart time: $startTime \nEnd time: $endTime Facility Id: $facilityCode")
                                .base64),
                      ),
                    );
                  },
                  child: const Text(
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
              title: const Text("Booking failed"),
              content: const Text(
                  "Facility is not available for the selected time slot."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
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

  Future<void> _showStartTimePicker() async {
    TimeOfDay? selectedStartTime = await showIntervalTimePicker(
      context: context,
      interval: _interval,
      initialTime: TimeOfDay(hour: currentTime.hour, minute: 0),
      helpText: "Select start time",
    );

    if (selectedStartTime == null) return;

    setState(() {
      startTime = selectedStartTime;
    });

    final formattedTime =
        '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
    startTimeController.text = formattedTime;
  }

  Future<void> _showEndTimePicker() async {
    TimeOfDay? selectedEndTime = await showIntervalTimePicker(
      context: context,
      interval: _interval,
      initialTime: TimeOfDay(hour: currentTime.hour + 1, minute: 0),
      helpText: "Select end time",
    );

    if (selectedEndTime == null) return;

    setState(() {
      endTime = selectedEndTime;
    });

    final formattedTime =
        '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}';
    endTimeController.text = formattedTime;
  }

  Future<void> _showDatePicker() async {
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

    final formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
    dateController.text = formattedDate;
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
        title: const Text("Schedule an event page:"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.01, top: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Type of facility\n"),
                  /////////
                  SizedBox(
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
                  /////////
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
                  //////
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
                      await _showDatePicker();
                      await _showStartTimePicker();
                      _showEndTimePicker();
                    },
                    child: const Text("Choose date"),
                  ),

                  const Text("\nStart time:\n"),
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
                    onPressed: date != null
                        ? () async {
                            await _showStartTimePicker();
                            _showEndTimePicker();
                          }
                        : null, // Disable button if date is not chosen
                    child: const Text("Choose time"),
                  ),

                  const Text("\nEnd time:\n"),
                  Text(
                    endTime != null
                        ? DateFormat('h:mm a').format(DateTime(
                            date!.year,
                            date!.month,
                            date!.day,
                            endTime!.hour,
                            endTime!.minute))
                        : '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: date != null
                        ? () async {
                            _showEndTimePicker();
                          }
                        : null, // Disable button if date is not chosen
                    child: const Text("Choose time"),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: (date != null &&
                                startTime != null &&
                                endTime != null)
                            ? () => handleButtonPress()
                            : null,
                        child: const Text("Book now"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
