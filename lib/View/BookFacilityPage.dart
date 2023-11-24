import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:residential_management_app/Controller/BookFacilityController.dart';
import 'BookingHistoryContentPage.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/Model/EncryptingModel.dart';

const List<String> list = <String>[
  'Badminton Court A',
  'Badminton Court B',
  'Basketball Court',
  'Tennis Court'
];
final userData = UserData.user!;

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
  final int _interval = 60;
  TimeOfDay currentTime = TimeOfDay.now();
  final userName = userData.name;
  final String userId = userData.userid;

  List<String> availableSlots = [];

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Booking failed"),
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
          return; // prevent proceed if start time and end time are same
        }
      }

      final facility = dropdownValue;
      final facilityCode = mapFacilityToCode(facility);
      const description = "";

      // check availability
      bool isAvailable = await BookFacilityController()
          .checkAvailable(facilityCode, bookingDate, startTime!, endTime!);

      if (isAvailable) {
        await BookFacilityController().bookFacility(bookingDate, startTime!,
            endTime!, facilityCode, dropdownValue, description);
        // ignore: use_build_context_synchronously
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
                            encryptedBookingInfo: EncryptingController()
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
        // facility is not available, show a message
        // ignore: use_build_context_synchronously
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
      // ignore: avoid_print
      print("Error handling button press: $e");
    }
  }

  Future<void> getAvailableSlots() async {
    try {
      final facilityCode = mapFacilityToCode(dropdownValue);
      final bookingDate = date!;

      // get available slots
      List<String> slots = await BookFacilityController()
          .getAvailableSlots(facilityCode, bookingDate);

      // set the available slots in the state
      setState(() {
        availableSlots = slots;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error handling getAvailableSlots: $e");
    }
  }

  Future<void> _showStartTimePicker() async {
    TimeOfDay? selectedStartTime = await showIntervalTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      interval: _interval,
      helpText: "Select start time",
    );

    if (selectedStartTime != null) {
      if (selectedStartTime.hour < 8 || selectedStartTime.hour > 23) {
        // Show an alert for invalid start time
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Invalid Start Time"),
              content: const Text(
                  "Please choose a start time between 8 am and 11 pm."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return;
      }

      setState(() {
        startTime = selectedStartTime;
        availableSlots = []; // reset available slots after start time changed
      });

      final formattedTime =
          '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
      startTimeController.text = formattedTime;

      await getAvailableSlots();
    }
  }

  Future<void> _showEndTimePicker() async {
    TimeOfDay? selectedEndTime = await showIntervalTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: currentTime.hour + 1, minute: 0),
        interval: _interval,
        helpText: "Select end time");

    if (selectedEndTime != null) {
      setState(() {
        endTime = selectedEndTime;
        availableSlots = []; // reset available slots after end time changed
      });

      final formattedTime =
          '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}';
      endTimeController.text = formattedTime;

      await getAvailableSlots();
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
        title: const Text("Book a facility page"),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(left: screenWidth * 0.01, top: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Type of facility\n"),
            /////////
            // ignore: sized_box_for_whitespace
            Container(
              width: screenWidth * 0.5,
              height: 60,
              child: DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    availableSlots =
                        []; // reset available slots when facility changes
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

            const Text("Date:\n"),
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
                  availableSlots =
                      []; // reset available slots when date changes
                });

                final formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
                dateController.text = formattedDate;

                await getAvailableSlots();
              },
              child: const Text("Choose date"),
            ),

            const Text("\nStart time:\n"),
            Text(
              startTime != null
                  ? DateFormat('H:mm a').format(DateTime(
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
                      await _showEndTimePicker();
                    }
                  : null,
              child: const Text("Choose start time"),
            ),

            const Text("\nEnd time:\n"),
            Text(
              endTime != null
                  ? DateFormat('H:mm a').format(DateTime(date!.year,
                      date!.month, date!.day, endTime!.hour, endTime!.minute))
                  : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: startTime != null ? _showEndTimePicker : null,
              child: const Text("Choose end time"),
            ),

            const Text("\n Available slots:\n"),

            // display available slots as buttons
            if (availableSlots.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableSlots
                    .map(
                      (slot) => ElevatedButton(
                        onPressed: () async {
                          try {
                            final List<String> timeParts = slot.split(" ");
                            if (timeParts.length == 2) {
                              final List<String> hourMinute =
                                  timeParts[0].split(":");
                              final int hour = int.parse(hourMinute[0]);
                              final int minute = int.parse(hourMinute[1]);
                              final String period = timeParts[1].toUpperCase();

                              if ((period == 'AM' || period == 'PM') &&
                                  (hour >= 1 && hour <= 12) &&
                                  (minute >= 0 && minute <= 59)) {
                                setState(() {
                                  startTime = TimeOfDay(
                                      hour: period == 'PM' ? hour + 12 : hour,
                                      minute: minute);
                                  availableSlots = []; // reset available slots
                                });
                              } else {
                                print("Invalid time format");
                              }
                            } else {
                              print("Invalid time format");
                            }
                          } catch (e) {
                            print("Error parsing time: $e");
                          }
                          await getAvailableSlots();
                        },
                        child: Text(
                          slot,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),

            SizedBox(height: screenHeight * 0.1),

            Align(
              alignment: Alignment.center,
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 60,
                child: ElevatedButton(
                  onPressed:
                      (date != null && startTime != null && endTime != null)
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
    );
  }
}
