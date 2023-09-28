import 'package:flutter/material.dart';
import 'package:residential_management_app/View/HomePage.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:residential_management_app/Controller/LoginController.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = LoginController();
  bool isHidden = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLoginButtonPress() async {
    // get username and password form input field
    final username = usernameController.text;
    final password = passwordController.text;

    // login process, loginController will check
    final userData = await loginController.login(username, password);

    if (userData != null) {
      // if login success, set the global user object in UserData
      UserData.user = userData;

      // then navaigate to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid username or password"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double inputFieldWidthPercentage = 0.5;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  controller: usernameController,
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
                  controller: passwordController,
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
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
