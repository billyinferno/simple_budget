class ContributionModel {
    final int id;
    final int participationId;

    ContributionModel({
        required this.id,
        required this.participationId,
    });

    factory ContributionModel.fromJson(Map<String, dynamic> json) => ContributionModel(
        id: json["id"],
        participationId: json["participation_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "participation_id": participationId,
    };
}