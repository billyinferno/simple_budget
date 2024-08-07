import 'dart:convert';

import 'package:simple_budget/_index.g.dart';

class PlanAPI {
  static Future<PinVerifyModel> verifyPIN({required String uid, required String pin}) async {
    final String body = await NetUtils.post(
      url: Globals.apiPinVerify,
      body: {
        "uid":uid,
        "pin":pin
      },
      requiredJWT: false,
    );

    // parse the response to get watchlist information that we just added
    CommonSingleModel commonModel = CommonSingleModel.fromJson(jsonDecode(body));
    PinVerifyModel pinVerify = PinVerifyModel.fromJson(commonModel.data['attributes']);

    return pinVerify;
  }
}