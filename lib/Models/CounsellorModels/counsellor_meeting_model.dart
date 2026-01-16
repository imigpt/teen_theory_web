// To parse this JSON data, do
//
//     final counsellorMeetingModel = counsellorMeetingModelFromJson(jsonString);

import 'dart:convert';

CounsellorMeetingModel counsellorMeetingModelFromJson(String str) => CounsellorMeetingModel.fromJson(json.decode(str));

String counsellorMeetingModelToJson(CounsellorMeetingModel data) => json.encode(data.toJson());

class CounsellorMeetingModel {
    bool? success;
    String? message;
    List<CounsellorMeeting>? data;

    CounsellorMeetingModel({
        this.success,
        this.message,
        this.data,
    });

    factory CounsellorMeetingModel.fromJson(Map<String, dynamic> json) => CounsellorMeetingModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<CounsellorMeeting>.from(json["data"]!.map((x) => CounsellorMeeting.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CounsellorMeeting {
    String? id;
    String? projectName;
    String? linkCreatedBy;
    String? title;
    DateTime? dateTime;
    String? meetingLink;
    String? projectCounsellorEmail;
    ProjectMentor? projectMentor;
    String? status;
    DateTime? createdAt;

    CounsellorMeeting({
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

    factory CounsellorMeeting.fromJson(Map<String, dynamic> json) => CounsellorMeeting(
        id: json["_id"],
        projectName: json["project_name"],
        linkCreatedBy: json["link_created_by"],
        title: json["title"],
        dateTime: json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
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
        "date_time": dateTime?.toIso8601String(),
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
    String? email;
    String? subtitle;
    String? rating;
    String? reviews;

    ProjectMentor({
        this.id,
        this.name,
        this.email,
        this.subtitle,
        this.rating,
        this.reviews,
    });

    factory ProjectMentor.fromJson(Map<String, dynamic> json) => ProjectMentor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        subtitle: json["subtitle"],
        rating: json["rating"],
        reviews: json["reviews"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "subtitle": subtitle,
        "rating": rating,
        "reviews": reviews,
    };
}
