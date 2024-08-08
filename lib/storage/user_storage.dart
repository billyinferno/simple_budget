import 'dart:convert';

import 'package:simple_budget/_index.g.dart';

class UserStorage {
  static const _userMeKey = "user_me";

  static Future<bool> isLogin() async {
    // check if we got JWT in the secured storage
    String jwt = await SecureBox.get(key: 'jwt');
    if (jwt.isEmpty) {
      return false;
    }
    return true;
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