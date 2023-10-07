import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/Controller/VisitorFavoriteController.dart';

class VisitorQRPage extends StatelessWidget {
  final String visitorName;
  final int visitorContact;

  const VisitorQRPage(
      {super.key, required this.visitorName, required this.visitorContact});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitation details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.05),
          Center(
            child: Container(
              height: screenHeight * 0.3,
              width: screenWidth * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black)),
              child: Text("This is QR"),
            ),
          ),
          //////////////////////////

          Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name:\n$visitorName"),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "Phone number:\n+60$visitorContact",
                ),
              ],
            ),
          ),

          Spacer(),

          Center(
            child: Column(
              children: [
                Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.1,
                    child: ElevatedButton(
                        onPressed: () {
                          VisitorFavoriteController()
                              .addFav(visitorName, visitorContact);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text("Added into favourite"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog when the button is pressed
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
                        },
                        child: Text("Add to favourite"))),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                /////////////////////////
                Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.1,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Text("Back to home page"))),
                SizedBox(
                  height: screenHeight * 0.05,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
