// To parse this JSON data, do
//
//     final issueModel = issueModelFromJson(jsonString);

import 'dart:convert';

import 'package:issue_listing_app/data/models/reaction.dart';
import 'package:issue_listing_app/data/models/user.dart';

IssueModel issueModelFromJson(String str) =>
    IssueModel.fromJson(json.decode(str));

String issueModelToJson(IssueModel data) => json.encode(data.toJson());

class IssueModel {
  String? url;
  String? repositoryUrl;
  String? labelsUrl;
  String? commentsUrl;
  String? eventsUrl;
  String? htmlUrl;
  int? id;
  String? nodeId;
  int? number;
  String? title;
  User? user;
  List<dynamic>? labels;
  String? state;
  bool? locked;
  dynamic assignee;
  List<dynamic>? assignees;
  dynamic milestone;
  int? comments;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic closedAt;
  String? authorAssociation;
  dynamic activeLockReason;
  String? body;
  ReactionModel? reactions;
  String? timelineUrl;
  dynamic performedViaGithubApp;
  dynamic stateReason;

  IssueModel({
    this.url,
    this.repositoryUrl,
    this.labelsUrl,
    this.commentsUrl,
    this.eventsUrl,
    this.htmlUrl,
    this.id,
    this.nodeId,
    this.number,
    this.title,
    this.user,
    this.labels,
    this.state,
    this.locked,
    this.assignee,
    this.assignees,
    this.milestone,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.authorAssociation,
    this.activeLockReason,
    this.body,
    this.reactions,
    this.timelineUrl,
    this.performedViaGithubApp,
    this.stateReason,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) => IssueModel(
        url: json["url"],
        repositoryUrl: json["repository_url"],
        labelsUrl: json["labels_url"],
        commentsUrl: json["comments_url"],
        eventsUrl: json["events_url"],
        htmlUrl: json["html_url"],
        id: json["id"],
        nodeId: json["node_id"],
        number: json["number"],
        title: json["title"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        labels: json["labels"] == null
            ? []
            : List<dynamic>.from(json["labels"]!.map((x) => x)),
        state: json["state"],
        locked: json["locked"],
        assignee: json["assignee"],
        assignees: json["assignees"] == null
            ? []
            : List<dynamic>.from(json["assignees"]!.map((x) => x)),
        milestone: json["milestone"],
        comments: json["comments"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        closedAt: json["closed_at"],
        authorAssociation: json["author_association"],
        activeLockReason: json["active_lock_reason"],
        body: json["body"],
        reactions: json["reactions"] == null
            ? null
            : ReactionModel.fromJson(json["reactions"]),
        timelineUrl: json["timeline_url"],
        performedViaGithubApp: json["performed_via_github_app"],
        stateReason: json["state_reason"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "repository_url": repositoryUrl,
        "labels_url": labelsUrl,
        "comments_url": commentsUrl,
        "events_url": eventsUrl,
        "html_url": htmlUrl,
        "id": id,
        "node_id": nodeId,
        "number": number,
        "title": title,
        "user": user?.toJson(),
        "labels":
            labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
        "state": state,
        "locked": locked,
        "assignee": assignee,
        "assignees": assignees == null
            ? []
            : List<dynamic>.from(assignees!.map((x) => x)),
        "milestone": milestone,
        "comments": comments,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "closed_at": closedAt,
        "author_association": authorAssociation,
        "active_lock_reason": activeLockReason,
        "body": body,
        "reactions": reactions?.toJson(),
        "timeline_url": timelineUrl,
        "performed_via_github_app": performedViaGithubApp,
        "state_reason": stateReason,
      };
}
