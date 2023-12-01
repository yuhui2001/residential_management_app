import 'package:encrypt/encrypt.dart';

class EncryptingModel {
  Encrypted encrypt(String plainText) {
    const keyString = "CreatedbYyeeehUI";
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    return encrypter.encrypt(plainText, iv: initVector);
  }
}
