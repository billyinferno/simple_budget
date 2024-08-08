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
    await NetUtils.post(
      url: Globals.apiPlanCheck,
      body: {
        "uid":uid.toUpperCase()
      },
      requiredJWT: false,
    );

    return true;
  }

  static Future<PlanModel> findSecure({required String uid, String? pin}) async {
    // check whether we need to use JWT or not?
    bool requiredJwt = false;
    Map<String, dynamic> body = {};

    if (pin == null) {
      requiredJwt = true;
      body = {
        "uid": uid.toUpperCase()
      };
    }
    else {
      // we will usinggenerate the body
      body = {
        "uid": uid.toUpperCase(),
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

  static Future<List<PlanModel>> getPlanList() async {
    // get the company data using netutils
    final String body = await NetUtils.get(
      url: Globals.apiPlanList
    );

    // parse the response to get the sector name list
    CommonArrayModel commonModel = CommonArrayModel.fromJson(jsonDecode(body));
    List<PlanModel> plans = [];
    for (var data in commonModel.data) {
      PlanModel plan = PlanModel.fromJson(data['attributes']);
      plans.add(plan);
    }
    return plans;
  }
}