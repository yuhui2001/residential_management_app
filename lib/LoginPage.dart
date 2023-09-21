import 'package:flutter/material.dart';
import 'package:residential_management_app/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;

  // Function to handle the "Login" button press
  void handleLoginButtonPress() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // get screen size
    double inputFieldWidthPercentage = 0.5;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Text(
                "SMART JIRAN",
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20.0),

              // Username input
              Container(
                width: screenWidth * inputFieldWidthPercentage,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              // Password input
              Container(
                width: screenWidth * inputFieldWidthPercentage,
                child: TextFormField(
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: isHidden
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isHidden = !isHidden; // Toggle visibility
                        });
                      },
                    ),
                    hintText: "Password",
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              TextButton(
                onPressed: handleLoginButtonPress,
                child: Text(
                    "Login"), // Specify the label using the "child" property
              )
            ],
          ),
        ),
      ),
    );
  }
}
