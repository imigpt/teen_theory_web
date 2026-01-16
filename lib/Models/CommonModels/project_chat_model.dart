// To parse this JSON data, do
//
//     final projectChatModel = projectChatModelFromJson(jsonString);

import 'dart:convert';

ProjectChatModel projectChatModelFromJson(String str) => ProjectChatModel.fromJson(json.decode(str));

String projectChatModelToJson(ProjectChatModel data) => json.encode(data.toJson());

class ProjectChatModel {
    bool? success;
    String? message;
    ProjectChat? data;

    ProjectChatModel({
        this.success,
        this.message,
        this.data,
    });

    factory ProjectChatModel.fromJson(Map<String, dynamic> json) => ProjectChatModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : ProjectChat.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class ProjectChat {
    int? projectId;
    String? projectTitle;
    String? requestedByEmail;
    Participants? participants;

    ProjectChat({
        this.projectId,
        this.projectTitle,
        this.participants,
        this.requestedByEmail
    });

    factory ProjectChat.fromJson(Map<String, dynamic> json) => ProjectChat(
        projectId: json["project_id"],
        projectTitle: json["project_title"],
        requestedByEmail: json["requested_by_email"],
        participants: json["participants"] == null ? null : Participants.fromJson(json["participants"]),
    );

    Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "project_title": projectTitle,
        "requested_by_email": requestedByEmail,
        "participants": participants?.toJson(),
    };
}

class Participants {
    List<Counsellor>? students;
    List<Counsellor>? mentors;
    Counsellor? counsellor;

    Participants({
        this.students,
        this.mentors,
        this.counsellor,
    });

    factory Participants.fromJson(Map<String, dynamic> json) => Participants(
        students: json["students"] == null ? [] : List<Counsellor>.from(json["students"]!.map((x) => Counsellor.fromJson(x))),
        mentors: json["mentors"] == null ? [] : List<Counsellor>.from(json["mentors"]!.map((x) => Counsellor.fromJson(x))),
        counsellor: json["counsellor"] == null ? null : Counsellor.fromJson(json["counsellor"]),
    );

    Map<String, dynamic> toJson() => {
        "students": students == null ? [] : List<dynamic>.from(students!.map((x) => x.toJson())),
        "mentors": mentors == null ? [] : List<dynamic>.from(mentors!.map((x) => x.toJson())),
        "counsellor": counsellor?.toJson(),
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
