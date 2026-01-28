// To parse this JSON data, do
//
//     final passRequestEmailModel = passRequestEmailModelFromJson(jsonString);

import 'dart:convert';

PassRequestEmailModel passRequestEmailModelFromJson(String str) => PassRequestEmailModel.fromJson(json.decode(str));

String passRequestEmailModelToJson(PassRequestEmailModel data) => json.encode(data.toJson());

class PassRequestEmailModel {
    bool? success;
    String? message;
    List<Datum>? data;

    PassRequestEmailModel({
        this.success,
        this.message,
        this.data,
    });

    factory PassRequestEmailModel.fromJson(Map<String, dynamic> json) => PassRequestEmailModel(
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
    int? userId;
    String? email;
    String? fullName;
    String? userRole;
    String? status;
    DateTime? requestedAt;
    DateTime? approvedAt;
    String? approvedBy;
    DateTime? completedAt;

    Datum({
        this.id,
        this.userId,
        this.email,
        this.fullName,
        this.userRole,
        this.status,
        this.requestedAt,
        this.approvedAt,
        this.approvedBy,
        this.completedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["user_id"],
        email: json["email"],
        fullName: json["full_name"],
        userRole: json["user_role"],
        status: json["status"],
        requestedAt: json["requested_at"] == null ? null : DateTime.parse(json["requested_at"]),
        approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
        approvedBy: json["approved_by"],
        completedAt: json["completed_at"] == null ? null : DateTime.parse(json["completed_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "email": email,
        "full_name": fullName,
        "user_role": userRole,
        "status": status,
        "requested_at": requestedAt?.toIso8601String(),
        "approved_at": approvedAt?.toIso8601String(),
        "approved_by": approvedBy,
        "completed_at": completedAt?.toIso8601String(),
    };
}
