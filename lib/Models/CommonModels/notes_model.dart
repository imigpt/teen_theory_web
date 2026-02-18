// To parse this JSON data, do
//
//     final notesModel = notesModelFromJson(jsonString);

import 'dart:convert';

NotesModel notesModelFromJson(String str) => NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
    bool? success;
    String? message;
    int? count;
    List<Datum>? data;

    NotesModel({
        this.success,
        this.message,
        this.count,
        this.data,
    });

    factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
        success: json["success"],
        message: json["message"],
        count: json["count"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "count": count,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? projectName;
    String? createdByUserEmail;
    DateTime? createdDate;
    String? notes;

    Datum({
        this.id,
        this.projectName,
        this.createdByUserEmail,
        this.createdDate,
        this.notes,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        projectName: json["project_name"],
        createdByUserEmail: json["created_by_user_email"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "project_name": projectName,
        "created_by_user_email": createdByUserEmail,
        "created_date": createdDate?.toIso8601String(),
        "notes": notes,
    };
}
