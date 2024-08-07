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
}