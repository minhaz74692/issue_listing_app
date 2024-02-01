// To parse this JSON data, do
//
//     final reactionModel = reactionModelFromJson(jsonString);

import 'dart:convert';

ReactionModel reactionModelFromJson(String str) => ReactionModel.fromJson(json.decode(str));

String reactionModelToJson(ReactionModel data) => json.encode(data.toJson());

class ReactionModel {
    String? url;
    int? totalCount;
    int? the1;
    int? reactionModel1;
    int? laugh;
    int? hooray;
    int? confused;
    int? heart;
    int? rocket;
    int? eyes;

    ReactionModel({
        this.url,
        this.totalCount,
        this.the1,
        this.reactionModel1,
        this.laugh,
        this.hooray,
        this.confused,
        this.heart,
        this.rocket,
        this.eyes,
    });

    factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
        url: json["url"],
        totalCount: json["total_count"],
        the1: json["+1"],
        reactionModel1: json["-1"],
        laugh: json["laugh"],
        hooray: json["hooray"],
        confused: json["confused"],
        heart: json["heart"],
        rocket: json["rocket"],
        eyes: json["eyes"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "total_count": totalCount,
        "+1": the1,
        "-1": reactionModel1,
        "laugh": laugh,
        "hooray": hooray,
        "confused": confused,
        "heart": heart,
        "rocket": rocket,
        "eyes": eyes,
    };
}
