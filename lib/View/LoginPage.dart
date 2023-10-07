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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleLoginButtonPress() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with login
      final username = usernameController.text;
      final password = passwordController.text;

      final userData = await loginController.login(username, password);

      if (userData != null) {
        UserData.user = userData;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid username or password"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double inputFieldWidthPercentage = 0.5;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
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
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.0),

                TextButton(
                  onPressed: handleLoginButtonPress,
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
