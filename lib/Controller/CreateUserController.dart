import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';

class CreateUserController {
  final collection = FirebaseFirestore.instance.collection('user');
  final key = "CreatedByYeeeHui";

  Future addUser(
    String customDocumentName,
    String username,
    String password,
    String userid,
    String name,
    String address,
  ) async {
    try {
      final encryptedPassword = encrypt(key, password);

      final DocumentReference documentReference =
          collection.doc(customDocumentName);

      final postData = {
        "username": username,
        "password": encryptedPassword.base64,
        "userid": userid,
        "name": name,
        "address": address,
      };
      await documentReference.set(postData);
      print("User added successfully!");
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  //https://stackoverflow.com/questions/72886971/i-want-to-decrypt-and-enccrypt-the-data-in-flutter
  Encrypted encrypt(String keyString, String plainText) {
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    return encrypter.encrypt(plainText, iv: initVector);
  }
}
