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

    // parse the response to get plan information that we got
    CommonSingleModel commonModel = CommonSingleModel.fromJson(jsonDecode(result));
    PlanModel plan = PlanModel.fromJson(commonModel.data['attributes']);

    return plan;
  }

  static Future<List<PlanModel>> getPlanList() async {
    // get the company data using netutils
    final String body = await NetUtils.get(
      url: Globals.apiPlanList
    );

    // parse the response to get the plan list that we got
    CommonArrayModel commonModel = CommonArrayModel.fromJson(jsonDecode(body));
    List<PlanModel> plans = [];
    for (var data in commonModel.data) {
      PlanModel plan = PlanModel.fromJson(data['attributes']);
      plans.add(plan);
    }
    return plans;
  }

  static Future<PinVerifyModel> createPin({
    required String uid,
    required String pin
  }) async {
    final String body = await NetUtils.post(
      url: Globals.apiPlanPinCreate,
      body: {
        "uid":uid,
        "pin":pin
      },
    );

    // parse the response to the pin that we set for this plan
    CommonSingleModel commonModel = CommonSingleModel.fromJson(jsonDecode(body));
    PinVerifyModel plan = PinVerifyModel.fromJson(commonModel.data['attributes']);

    return plan;
  }

  static Future<void> deletePin({required String uid}) async {
    await NetUtils.post(
      url: Globals.apiPlanPinDelete,
      body: {
        "uid":uid
      },
    );
  }

  static Future<PlanUidModel> generateUid() async {
    final String body = await NetUtils.get(
      url: Globals.apiPlanGenerate,
    );

    // parse the response to the uid data
    CommonSingleModel commonModel = CommonSingleModel.fromJson(jsonDecode(body));
    PlanUidModel plan = PlanUidModel.fromJson(commonModel.data['attributes']);

    return plan;
  }

  static Future<bool> createPlan({
    required String uid,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
    required String pin,
    required List<String> participants,
  }) async {
    bool retValue = false;

    await NetUtils.post(
      url: Globals.apiPlan,
      body: {
        "uid": uid,
        "name": name,
        "description": description,
        "startDate": Globals.dfyyyyMMdd.format(startDate),
        "endDate": Globals.dfyyyyMMdd.format(endDate),
        "amount": amount,
        "pin": pin,
        "participants": participants
      },
    ).then((value) {
      retValue = true;
    },);

    return retValue;
  }

  static Future<void> deletePlan({required String uid}) async {
    await NetUtils.post(
      url: Globals.apiPlanDelete,
      body: {
        "uid":uid
      },
    );
  }

  static Future<bool> updatePlan({
    required String uid,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
    required Map<ParticipationModel, EditType> participants,
  }) async {
    bool retValue = false;
    List<int> delete = [];
    List<String> add = [];

    // loop thru participants to get which one to delete and which one to add
    participants.forEach((participant, edit) {
      if (edit == EditType.delete) {
        delete.add(participant.id);
      }
      else if (edit == EditType.add) {
        add.add(participant.name);
      }
    },);

    await NetUtils.post(
      url: Globals.apiPlanUpdate,
      body: {
        "uid": uid,
        "name": name,
        "description": description,
        "startDate": Globals.dfyyyyMMdd.format(startDate),
        "endDate": Globals.dfyyyyMMdd.format(endDate),
        "amount": amount,
        "participants": {
          "delete": delete,
          "add": add
        }
      },
    ).then((value) {
      retValue = true;
    },);

    return retValue;
  }

  static Future<bool> addTransaction({
    required String uid,
    required String description,
    required DateTime date,
    required double amount,
    required TransactionType type,
  }) async {
    bool retValue = false;

    await NetUtils.post(
      url: Globals.apiTransactionsCreate,
      body: {
        "uid": uid,
        "description": description,
        "date": Globals.dfyyyyMMdd.format(date),
        "amount": amount,
        "type": type.name,
      },
    ).then((value) {
      retValue = true;
    },);

    return retValue;
  }

  static Future<bool> updateTransaction({
    required int id,
    required String uid,
    required String description,
    required DateTime date,
    required double amount,
    required TransactionType type,
  }) async {
    bool retValue = false;

    await NetUtils.post(
      url: Globals.apiTransactionsUpdate,
      body: {
        "id": id,
        "uid": uid,
        "description": description,
        "date": Globals.dfyyyyMMdd.format(date),
        "amount": amount,
        "type": type.name,
      },
    ).then((value) {
      retValue = true;
    },);

    return retValue;
  }

  static Future<void> deleteTransaction({required String uid, required int id}) async {
    await NetUtils.post(
      url: Globals.apiTransactionsDelete,
      body: {
        "uid":uid,
        "id":id,
      },
    );
  }
}