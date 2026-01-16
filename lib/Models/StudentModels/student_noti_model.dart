// To parse this JSON data, do
//
//     final studentNotificationModel = studentNotificationModelFromJson(jsonString);

import 'dart:convert';

StudentNotificationModel studentNotificationModelFromJson(String str) => StudentNotificationModel.fromJson(json.decode(str));

String studentNotificationModelToJson(StudentNotificationModel data) => json.encode(data.toJson());

class StudentNotificationModel {
    bool? success;
    String? message;
    List<Datum>? data;

    StudentNotificationModel({
        this.success,
        this.message,
        this.data,
    });

    factory StudentNotificationModel.fromJson(Map<String, dynamic> json) => StudentNotificationModel(
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
    int? projectId;
    String? title;
    String? status;
    DateTime? createdAt;
    String? assignedBy;
    AssignedByUser? assignedByUser;

    Datum({
        this.projectId,
        this.title,
        this.status,
        this.createdAt,
        this.assignedBy,
        this.assignedByUser,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        projectId: json["project_id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        assignedBy: json["assigned_by"],
        assignedByUser: json["assigned_by_user"] == null ? null : AssignedByUser.fromJson(json["assigned_by_user"]),
    );

    Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "title": title,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "assigned_by": assignedBy,
        "assigned_by_user": assignedByUser?.toJson(),
    };
}

class AssignedByUser {
    String? id;
    int? assignedByUserId;
    String? fullName;
    String? email;
    String? profilePhoto;
    String? userRole;

    AssignedByUser({
        this.id,
        this.assignedByUserId,
        this.fullName,
        this.email,
        this.profilePhoto,
        this.userRole,
    });

    factory AssignedByUser.fromJson(Map<String, dynamic> json) => AssignedByUser(
        id: json["_id"],
        assignedByUserId: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
        userRole: json["user_role"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": assignedByUserId,
        "full_name": fullName,
        "email": email,
        "profile_photo": profilePhoto,
        "user_role": userRole,
    };
}
