import 'package:residential_management_app/Model/LoginModel.dart';
import 'package:residential_management_app/Model/UserData.dart';

class LoginController {
  final UserModel userModel = UserModel();

  Future<UserData?> login(String username, String password) async {
    // fetch usernmae first (see if valid or not in UserModel)
    final userData = await userModel.getUserData(username);

    if (userData != null) {
      // check password
      final storedPassword = userData['password'];

      if (storedPassword == password) {
        // correct password, then login success
        final user = UserData(
          address: userData['address'],
          name: userData['name'],
          userid: userData['userid'],
        );
        return user;
      }
    }

    // Invalid username or password, login failed
    return null;
  }
}
