import 'dart:convert';

import 'package:simple_budget/_index.g.dart';

class UserAPI {
  static Future<UserLoginModel> login({
    required String identifier,
    required String password
  }) async {
    // post login information using netutils
    final String body = await NetUtils.post(
      url: Globals.apiAuthLocal,
      body: {'identifier': identifier, 'password': password},
      requiredJWT: false,
    );

    // parse the response and put on user login model
    UserLoginModel userLogin = UserLoginModel.fromJson(jsonDecode(body));
    return userLogin;
  }

  static Future<UserLoginInfoModel> me() async {
    // get user information data using netutils
    final String body = await NetUtils.get(
      url: Globals.apiUserMe
    );

    // parse the response and put on user login model
    UserLoginInfoModel userInfo = UserLoginInfoModel.fromJson(jsonDecode(body));
    return userInfo;
  }
}