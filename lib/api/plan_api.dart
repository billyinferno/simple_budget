import 'dart:convert';

import 'package:simple_budget/_index.g.dart';

class PlanAPI {
  static Future<PinVerifyModel> verifyPIN({required String uid, required String pin}) async {
    final String body = await NetUtils.post(
      url: Globals.apiPlanPinVerify,
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

  static Future<bool> check({required String uid}) async {
    bool returnCheck = false;

    await NetUtils.post(
      url: Globals.apiPlanCheck,
      body: {
        "uid":uid
      },
      requiredJWT: false,
    ).then((_) {
      returnCheck = true;
    }).onError((error, stackTrace) {
      returnCheck = false;
    },);

    return returnCheck;
  }

  static Future<PlanModel> findSecure({required String uid, String? pin}) async {
    // check whether we need to use JWT or not?
    bool requiredJwt = false;
    Map<String, dynamic> body = {};

    if (pin == null) {
      requiredJwt = true;
      body = {
        "uid": uid
      };
    }
    else {
      // we will usinggenerate the body
      body = {
        "uid": uid,
        "pin": pin
      };
    }

    final String result = await NetUtils.post(
      url: Globals.apiPlanFind,
      body: body,
      requiredJWT: requiredJwt,
    );

    // parse the response to get watchlist information that we just added
    CommonSingleModel commonModel = CommonSingleModel.fromJson(jsonDecode(result));
    PlanModel plan = PlanModel.fromJson(commonModel.data['attributes']);

    return plan;
  }
}