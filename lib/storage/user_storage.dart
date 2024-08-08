import 'dart:convert';

import 'package:simple_budget/_index.g.dart';

class UserStorage {
  static const _userMeKey = "user_me";
  static const _securedPinKey = "secured_pin";

  static Future<bool> isLogin() async {
    // check if we got JWT in the secured storage
    String jwt = await SecureBox.get(key: 'jwt');
    if (jwt.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<void> putSecuredPin({required PinVerifyModel data}) async {
    // put the secured PIN for this UID in secured box
    await SecureBox.put(key: _securedPinKey, value: jsonEncode(data.toJson()));
  }

  static Future<String> getSecuredPin() async {
    // check if we got JWT in the secured storage
    String securedPin = await SecureBox.get(key: _securedPinKey);
    return securedPin;
  }

  static Future<String> jwt() async {
    // check if we got JWT in the secured storage
    String jwt = await SecureBox.get(key: 'jwt');
    return jwt;
  }

  static Future<void> setUserInfo(UserLoginInfoModel userInfo) async {
    // stored the user info to box
    // convert the json to string so we can stored it on the local storage
    String userInfoString = jsonEncode(userInfo.toJson());
    LocalStorage.put(key: _userMeKey, value: userInfoString);
  }
}