import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HouseCleaningTermsPage.dart';

class HouseCleaningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("House cleaning page"),
      ),
      body: Center(
          child: Column(children: [
        Text("Welcome to house cleaning page"),
        Spacer(),
        Column(
          children: [
            Container(
                width: screenWidth * 0.3,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Hello"),
                              content: Text("NI HAO MA"),
                              actions: <Widget>[
                                Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK")))
                              ],
                            );
                          });
                    },
                    child: Text("Book now"))),
            SizedBox(height: screenHeight * 0.01),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HouseCleaningTermsPage()));
                },
                child: Text("Terms and condition")),
            SizedBox(
              height: screenHeight * 0.05,
            ),
          ],
        )
      ])),
    );
  }
}
