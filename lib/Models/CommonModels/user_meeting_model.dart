// To parse this JSON data, do
//
//     final userMeetingModel = userMeetingModelFromJson(jsonString);

import 'dart:convert';

UserMeetingModel userMeetingModelFromJson(String str) => UserMeetingModel.fromJson(json.decode(str));

String userMeetingModelToJson(UserMeetingModel data) => json.encode(data.toJson());

class UserMeetingModel {
    bool? success;
    String? message;
    List<FiteredMeetingModel>? data;

    UserMeetingModel({
        this.success,
        this.message,
        this.data,
    });

    factory UserMeetingModel.fromJson(Map<String, dynamic> json) => UserMeetingModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FiteredMeetingModel>.from(json["data"]!.map((x) => FiteredMeetingModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class FiteredMeetingModel {
    String? id;
    String? projectName;
    String? linkCreatedBy;
    String? title;
    String? dateTime;
    String? meetingLink;
    String? projectCounsellorEmail;
    ProjectMentor? projectMentor;
    String? status;
    DateTime? createdAt;

    FiteredMeetingModel({
        this.id,
        this.projectName,
        this.linkCreatedBy,
        this.title,
        this.dateTime,
        this.meetingLink,
        this.projectCounsellorEmail,
        this.projectMentor,
        this.status,
        this.createdAt,
    });

    factory FiteredMeetingModel.fromJson(Map<String, dynamic> json) => FiteredMeetingModel(
        id: json["_id"],
        projectName: json["project_name"],
        linkCreatedBy: json["link_created_by"],
        title: json["title"],
        dateTime: json["date_time"],
        meetingLink: json["meeting_link"],
        projectCounsellorEmail: json["project_counsellor_email"],
        projectMentor: json["project_mentor"] == null ? null : ProjectMentor.fromJson(json["project_mentor"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "project_name": projectName,
        "link_created_by": linkCreatedBy,
        "title": title,
        "date_time": dateTime,
        "meeting_link": meetingLink,
        "project_counsellor_email": projectCounsellorEmail,
        "project_mentor": projectMentor?.toJson(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
    };
}

class ProjectMentor {
    String? id;
    String? name;
    String? subtitle;
    String? rating;
    String? reviews;

    ProjectMentor({
        this.id,
        this.name,
        this.subtitle,
        this.rating,
        this.reviews,
    });

    factory ProjectMentor.fromJson(Map<String, dynamic> json) => ProjectMentor(
        id: json["id"],
        name: json["name"],
        subtitle: json["subtitle"],
        rating: json["rating"],
        reviews: json["reviews"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subtitle": subtitle,
        "rating": rating,
        "reviews": reviews,
    };
}
