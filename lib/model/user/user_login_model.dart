import 'package:simple_budget/model/_index.g.dart';

class UserLoginModel {
  final String jwt;
  final UserLoginInfoModel user;

  UserLoginModel(this.jwt, this.user);

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    UserLoginInfoModel user = UserLoginInfoModel.fromJson(json['user']);
    return UserLoginModel(json['jwt'], user);
  }

  Map<String, dynamic> toJson() {
    return {
      'jwt': jwt,
      'user': user.toJson()
    };
  }
}