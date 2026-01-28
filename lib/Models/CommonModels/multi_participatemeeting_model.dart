// To parse this JSON data, do
//
//     final participateMeetingModel = participateMeetingModelFromJson(jsonString);

import 'dart:convert';

ParticipateMeetingModel participateMeetingModelFromJson(String str) => ParticipateMeetingModel.fromJson(json.decode(str));

String participateMeetingModelToJson(ParticipateMeetingModel data) => json.encode(data.toJson());

class ParticipateMeetingModel {
    bool? success;
    String? message;
    List<Datum>? data;

    ParticipateMeetingModel({
        this.success,
        this.message,
        this.data,
    });

    factory ParticipateMeetingModel.fromJson(Map<String, dynamic> json) => ParticipateMeetingModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? createdByEmail;
    String? meetingTitle;
    String? meetingDescription;
    String? meetingLink;
    List<String>? studentEmails;
    List<String>? mentorEmails;
    List<String>? parentEmails;
    String? status;
    DateTime? createdAt;

    Datum({
        this.id,
        this.createdByEmail,
        this.meetingTitle,
        this.meetingDescription,
        this.meetingLink,
        this.studentEmails,
        this.mentorEmails,
        this.parentEmails,
        this.status,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        createdByEmail: json["created_by_email"],
        meetingTitle: json["meeting_title"],
        meetingDescription: json["meeting_description"],
        meetingLink: json["meeting_link"],
        studentEmails: json["student_emails"] == null ? [] : List<String>.from(json["student_emails"]!.map((x) => x)),
        mentorEmails: json["mentor_emails"] == null ? [] : List<String>.from(json["mentor_emails"]!.map((x) => x)),
        parentEmails: json["parent_emails"] == null ? [] : List<String>.from(json["parent_emails"]!.map((x) => x)),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by_email": createdByEmail,
        "meeting_title": meetingTitle,
        "meeting_description": meetingDescription,
        "meeting_link": meetingLink,
        "student_emails": studentEmails == null ? [] : List<dynamic>.from(studentEmails!.map((x) => x)),
        "mentor_emails": mentorEmails == null ? [] : List<dynamic>.from(mentorEmails!.map((x) => x)),
        "parent_emails": parentEmails == null ? [] : List<dynamic>.from(parentEmails!.map((x) => x)),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
    };
}
