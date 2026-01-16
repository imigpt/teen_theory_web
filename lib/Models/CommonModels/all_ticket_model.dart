// To parse this JSON data, do
//
//     final allTicketModel = allTicketModelFromJson(jsonString);

import 'dart:convert';

AllTicketModel allTicketModelFromJson(String str) => AllTicketModel.fromJson(json.decode(str));

String allTicketModelToJson(AllTicketModel data) => json.encode(data.toJson());

class AllTicketModel {
    bool? success;
    String? message;
    List<Datum>? data;

    AllTicketModel({
        this.success,
        this.message,
        this.data,
    });

    factory AllTicketModel.fromJson(Map<String, dynamic> json) => AllTicketModel(
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
    String? title;
    String? raisedBy;
    String? projectName;
    dynamic assignedTo;
    String? priority;
    String? explaination;
    List<String>? attachments;
    String? status;
    RaisedByUser? raisedByUser;

    Datum({
        this.id,
        this.title,
        this.raisedBy,
        this.projectName,
        this.assignedTo,
        this.priority,
        this.explaination,
        this.attachments,
        this.status,
        this.raisedByUser,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        raisedBy: json["raised_by"],
        projectName: json["project_name"],
        assignedTo: json["assigned_to"],
        priority: json["priority"],
        explaination: json["explaination"],
        attachments: json["attachments"] == null ? [] : List<String>.from(json["attachments"]!.map((x) => x)),
        status: json["status"],
        raisedByUser: json["raised_by_user"] == null ? null : RaisedByUser.fromJson(json["raised_by_user"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "raised_by": raisedBy,
        "project_name": projectName,
        "assigned_to": assignedTo,
        "priority": priority,
        "explaination": explaination,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
        "status": status,
        "raised_by_user": raisedByUser?.toJson(),
    };
}

class RaisedByUser {
    String? id;
    int? raisedByUserId;
    String? fullName;
    String? email;
    String? profilePhoto;
    String? userRole;
    String? phoneNumber;
    DateTime? createdAt;

    RaisedByUser({
        this.id,
        this.raisedByUserId,
        this.fullName,
        this.email,
        this.profilePhoto,
        this.userRole,
        this.phoneNumber,
        this.createdAt,
    });

    factory RaisedByUser.fromJson(Map<String, dynamic> json) => RaisedByUser(
        id: json["_id"],
        raisedByUserId: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
        userRole: json["user_role"],
        phoneNumber: json["phone_number"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": raisedByUserId,
        "full_name": fullName,
        "email": email,
        "profile_photo": profilePhoto,
        "user_role": userRole,
        "phone_number": phoneNumber,
        "created_at": createdAt?.toIso8601String(),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
