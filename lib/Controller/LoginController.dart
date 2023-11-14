// ignore_for_file: avoid_print

import 'package:residential_management_app/Model/LoginModel.dart';
import 'package:residential_management_app/Model/UserData.dart';
import 'package:encrypt/encrypt.dart';

class LoginController {
  final LoginModel loginModel = LoginModel();
  final key = "CreatedByYeeeHui";

  Future<UserData?> login(
    String enteredUsername,
    String enteredPassword,
  ) async {
    try {
      // Fetch user data
      final userData = await loginModel.getUserDataWithSalt(enteredUsername);

      if (userData != null) {
        final storedPassword = userData['password'];

        // Decrypt the stored password
        final decryptedPassword = decrypt(key, storedPassword);

        // Compare decrypted password with entered password
        if (decryptedPassword == enteredPassword) {
          // Correct password, login success
          final user = UserData(
            address: userData['address'],
            name: userData['name'],
            userid: userData['userid'],
          );
          return user;
        } else {
          print("Wrong password");
        }
      }

      // Wrong username or password, login failed
      return null;
    } catch (e) {
      // Log or handle errors more explicitly
      print('Error during login: $e');
      return null;
    }
  }

  //https://stackoverflow.com/questions/72886971/i-want-to-decrypt-and-enccrypt-the-data-in-flutter
  String decrypt(String keyString, String encryptedData) {
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    return encrypter.decrypt64(encryptedData, iv: initVector);
  }
}
