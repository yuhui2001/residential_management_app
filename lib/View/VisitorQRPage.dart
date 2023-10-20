import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/Controller/VisitorFavoriteController.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VisitorQRPage extends StatelessWidget {
  final String visitorName;
  final String encryptedVisitorInfo;
  final String ownerAddress;
  final int visitorContact;

  const VisitorQRPage(
      {super.key,
      required this.visitorName,
      required this.visitorContact,
      required this.ownerAddress,
      required this.encryptedVisitorInfo});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitation details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: Container(
                height: screenWidth * 0.7,
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: QrImageView(
                  data: encryptedVisitorInfo,
                ),
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
                  SizedBox(height: screenHeight * 0.05),
                  Text("Address to visit:\n$ownerAddress")
                ],
              ),
            ),
            ///////////////////////////

            SizedBox(
              height: screenHeight * 0.05,
            ),

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
                        child: Text(
                          "Add to favourite",
                          textAlign: TextAlign.center,
                        ),
                      )),
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
                          child: Text(
                            "Back to home page",
                            textAlign: TextAlign.center,
                          ))),
                  SizedBox(
                    height: screenHeight * 0.05,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
