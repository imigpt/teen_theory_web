// To parse this JSON data, do
//
//     final filterRequestMeetingModel = filterRequestMeetingModelFromJson(jsonString);

import 'dart:convert';

FilterRequestMeetingModel filterRequestMeetingModelFromJson(String str) => FilterRequestMeetingModel.fromJson(json.decode(str));

String filterRequestMeetingModelToJson(FilterRequestMeetingModel data) => json.encode(data.toJson());

class FilterRequestMeetingModel {
    bool? success;
    String? message;
    List<FilterRequestMeeting>? data;

    FilterRequestMeetingModel({
        this.success,
        this.message,
        this.data,
    });

    factory FilterRequestMeetingModel.fromJson(Map<String, dynamic> json) => FilterRequestMeetingModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FilterRequestMeeting>.from(json["data"]!.map((x) => FilterRequestMeeting.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class FilterRequestMeeting {
    String? id;
    String? projectName;
    Counsellor? requestByMeeting;
    String? title;
    Counsellor? mentor;
    Counsellor? counsellor;
    String? message;
    String? status;
    DateTime? createdAt;

    FilterRequestMeeting({
        this.id,
        this.projectName,
        this.requestByMeeting,
        this.title,
        this.mentor,
        this.counsellor,
        this.message,
        this.status,
        this.createdAt,
    });

    factory FilterRequestMeeting.fromJson(Map<String, dynamic> json) => FilterRequestMeeting(
        id: json["_id"],
        projectName: json["project_name"],
        requestByMeeting: json["request_by_meeting"] == null ? null : Counsellor.fromJson(json["request_by_meeting"]),
        title: json["title"],
        mentor: json["mentor"] == null ? null : Counsellor.fromJson(json["mentor"]),
        counsellor: json["counsellor"] == null ? null : Counsellor.fromJson(json["counsellor"]),
        message: json["message"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "project_name": projectName,
        "request_by_meeting": requestByMeeting?.toJson(),
        "title": title,
        "mentor": mentor?.toJson(),
        "counsellor": counsellor?.toJson(),
        "message": message,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
    };
}

class Counsellor {
    String? id;
    int? counsellorId;
    String? fullName;
    String? email;
    String? profilePhoto;
    String? userRole;

    Counsellor({
        this.id,
        this.counsellorId,
        this.fullName,
        this.email,
        this.profilePhoto,
        this.userRole,
    });

    factory Counsellor.fromJson(Map<String, dynamic> json) => Counsellor(
        id: json["_id"],
        counsellorId: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
        userRole: json["user_role"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": counsellorId,
        "full_name": fullName,
        "email": email,
        "profile_photo": profilePhoto,
        "user_role": userRole,
    };
}
