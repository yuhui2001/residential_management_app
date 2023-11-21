import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/Controller/FileReportController.dart';

class FileReportPage extends StatelessWidget {
  const FileReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("File a report page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  const Text("Title:\n"),
                  SizedBox(
                    height: 60,
                    width: screenWidth * 0.95,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter title"),
                      controller: titleController,
                    ),
                  ),
                  const Text(""),
                  const Text("Description:\n"),
                  SizedBox(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.95,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(
                              bottom: screenWidth * 0.3,
                              top: screenHeight * 0.01,
                              left: screenWidth * 0.01),
                          isCollapsed: true,
                          labelText: "Enter description"),
                      controller: descriptionController,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.2),
                  Center(
                    child: SizedBox(
                      height: 60,
                      /////////////////////////

                      child: ElevatedButton(
                        onPressed: () async {
                          await FileReportController().fileReport(
                              titleController.text, descriptionController.text);
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Report submission",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: const Text(
                                    "Submitted",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage()));
                                        },
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text("Submit"),
                      ),
                    ),
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
