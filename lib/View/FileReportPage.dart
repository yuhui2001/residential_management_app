import 'package:flutter/material.dart';

class FileReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("File a report page"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text("Title:\n"),
            Container(
              height: 60,
              width: screenWidth * 0.95,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter title"),
              ),
            ),
            Text(""),
            Text("Description:\n"),
            Container(
              height: screenHeight * 0.4,
              width: screenWidth * 0.95,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                        bottom: screenWidth * 0.3,
                        top: screenHeight * 0.01,
                        left: screenWidth * 0.01),
                    isCollapsed: true,
                    labelText: "Enter description"),
              ),
            ),
            Spacer(),
            Center(
              child: Container(
                height: 60,
                width: screenWidth * 0.3,
                /////////////////////////
                
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Report submission",
                              style: TextStyle(fontSize: 20),
                            ),
                            content: Text(
                              "Submitted",
                              style: TextStyle(fontSize: 16),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Container(
                                width: screenWidth * 0.1,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("Submit"),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            )
          ],
        ),
      ),
    );
  }
}
