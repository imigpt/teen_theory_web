// To parse this JSON data, do
//
//     final conversionIdModel = conversionIdModelFromJson(jsonString);

import 'dart:convert';

ConversionIdModel conversionIdModelFromJson(String str) => ConversionIdModel.fromJson(json.decode(str));

String conversionIdModelToJson(ConversionIdModel data) => json.encode(data.toJson());

class ConversionIdModel {
    bool? success;
    String? message;
    Data? data;

    ConversionIdModel({
        this.success,
        this.message,
        this.data,
    });

    factory ConversionIdModel.fromJson(Map<String, dynamic> json) => ConversionIdModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? conversationId;
    dynamic? projectId;
    List<String>? members;
    DateTime? createdAt;
    bool? exists;

    Data({
        this.conversationId,
        this.projectId,
        this.members,
        this.createdAt,
        this.exists,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        conversationId: json["conversation_id"],
        projectId: json["project_id"],
        members: json["members"] == null ? [] : List<String>.from(json["members"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        exists: json["exists"],
    );

    Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "project_id": projectId,
        "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "exists": exists,
    };
}
