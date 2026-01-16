// To parse this JSON data, do
//
//     final studentMeetingModel = studentMeetingModelFromJson(jsonString);

import 'dart:convert';

StudentMeetingModel studentMeetingModelFromJson(String str) => StudentMeetingModel.fromJson(json.decode(str));

String studentMeetingModelToJson(StudentMeetingModel data) => json.encode(data.toJson());

class StudentMeetingModel {
    bool? success;
    String? message;
    List<Datum>? data;

    StudentMeetingModel({
        this.success,
        this.message,
        this.data,
    });

    factory StudentMeetingModel.fromJson(Map<String, dynamic> json) => StudentMeetingModel(
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
    String? meetingType;
    String? assignedStudents;
    String? dateTime;
    String? duration;
    String? purpose;
    String? meetingLink;
    String? linkCreatedBy;
    String? status;
    DateTime? createdAt;

    Datum({
        this.id,
        this.meetingType,
        this.assignedStudents,
        this.dateTime,
        this.duration,
        this.purpose,
        this.meetingLink,
        this.linkCreatedBy,
        this.status,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        meetingType: json["meeting_type"],
        assignedStudents: json["assigned_students"],
        dateTime: json["date_time"],
        duration: json["duration"],
        purpose: json["purpose"],
        meetingLink: json["meeting_link"],
        linkCreatedBy: json["link_created_by"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "meeting_type": meetingType,
        "assigned_students": assignedStudents,
        "date_time": dateTime,
        "duration": duration,
        "purpose": purpose,
        "meeting_link": meetingLink,
        "link_created_by": linkCreatedBy,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
    };
}
