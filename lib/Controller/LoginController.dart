import 'package:residential_management_app/Model/UserModel.dart';

class LoginController {
  final UserModel userModel = UserModel();

  Future<Map<String, dynamic>?> login(String username, String password) async {
    // Fetch user data based on the provided username
    final userData = await userModel.getUserData(username);

    if (userData != null) {
      // Check if the password matches the stored password
      final storedPassword = userData['password'];

      if (storedPassword == password) {
        // Password matches, login successful
        return {
          'userID': userData['userID'] as String,
          'name': userData['name'] as String,
        };
      }
    }

    // Invalid username or password, login failed
    return null;
  }
}



