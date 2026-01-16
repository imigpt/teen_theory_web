// To parse this JSON data, do
//
//     final chatMessagesModel = chatMessagesModelFromJson(jsonString);

import 'dart:convert';

ChatMessagesModel chatMessagesModelFromJson(String str) => ChatMessagesModel.fromJson(json.decode(str));

String chatMessagesModelToJson(ChatMessagesModel data) => json.encode(data.toJson());

class ChatMessagesModel {
    bool? success;
    String? message;
    List<ChatMessages>? data;

    ChatMessagesModel({
        this.success,
        this.message,
        this.data,
    });

    factory ChatMessagesModel.fromJson(Map<String, dynamic> json) => ChatMessagesModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ChatMessages>.from(json["data"]!.map((x) => ChatMessages.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ChatMessages {
    String? id;
    String? conversationId;
    int? projectId;
    String? senderEmail;
    Receiver? sender;
    String? receiverEmail;
    Receiver? receiver;
    String? message;
    DateTime? createdAt;

    ChatMessages({
        this.id,
        this.conversationId,
        this.projectId,
        this.senderEmail,
        this.sender,
        this.receiverEmail,
        this.receiver,
        this.message,
        this.createdAt,
    });

    factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
        id: json["_id"],
        conversationId: json["conversation_id"],
        projectId: json["project_id"],
        senderEmail: json["sender_email"],
        sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
        receiverEmail: json["receiver_email"],
        receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
        message: json["message"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "conversation_id": conversationId,
        "project_id": projectId,
        "sender_email": senderEmail,
        "sender": sender?.toJson(),
        "receiver_email": receiverEmail,
        "receiver": receiver?.toJson(),
        "message": message,
        "created_at": createdAt?.toIso8601String(),
    };
}

class Receiver {
    String? id;
    int? receiverId;
    String? fullName;
    String? email;
    String? profilePhoto;
    String? userRole;

    Receiver({
        this.id,
        this.receiverId,
        this.fullName,
        this.email,
        this.profilePhoto,
        this.userRole,
    });

    factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["_id"],
        receiverId: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
        userRole: json["user_role"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": receiverId,
        "full_name": fullName,
        "email": email,
        "profile_photo": profilePhoto,
        "user_role": userRole,
    };
}
