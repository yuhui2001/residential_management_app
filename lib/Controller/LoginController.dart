import 'package:residential_management_app/Model/UserModel.dart';
import 'package:residential_management_app/Model/UserData.dart';

class LoginController {
  final UserModel userModel = UserModel();

  Future<UserData?> login(String username, String password) async {
    // Fetch user data based on the provided username
    final userData = await userModel.getUserData(username);

    if (userData != null) {
      // Check if the password matches the stored password
      final storedPassword = userData['password'];

      if (storedPassword == password) {
        // Password matches, login successful
        final user = UserData(
          address: userData['address'],
          name: userData['name'],
          userid: userData['userid'],
          username: username,
        );
        return user;
      }
    }

    // Invalid username or password, login failed
    return null;
  }
}
