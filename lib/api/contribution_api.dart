import 'package:simple_budget/_index.g.dart';

class ContributionAPI {
  static Future<void> create({
    required String uid,
    required int participationId,
    required DateTime date}
  ) async {
    await NetUtils.post(
      url: Globals.apiContributionCreate,
      body: {
        "uid":uid,
        "participation_id": participationId,
        "date": Globals.dfyyyyMMdd.format(date)
      },
    );
  }

  static Future<void> delete({
    required String uid,
    required int participationId,
    required DateTime date}
  ) async {
    await NetUtils.post(
      url: Globals.apiContributionDelete,
      body: {
        "uid":uid,
        "participation_id": participationId,
        "date": Globals.dfyyyyMMdd.format(date)
      },
    );
  }
}