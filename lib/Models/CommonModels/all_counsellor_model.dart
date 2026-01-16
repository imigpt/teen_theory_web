// To parse this JSON data, do
//
//     final allCounsellorModel = allCounsellorModelFromJson(jsonString);

import 'dart:convert';

AllCounsellorModel allCounsellorModelFromJson(String str) => AllCounsellorModel.fromJson(json.decode(str));

String allCounsellorModelToJson(AllCounsellorModel data) => json.encode(data.toJson());

class AllCounsellorModel {
    bool? success;
    String? message;
    List<Datum>? data;

    AllCounsellorModel({
        this.success,
        this.message,
        this.data,
    });

    factory AllCounsellorModel.fromJson(Map<String, dynamic> json) => AllCounsellorModel(
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
    int? datumId;
    String? userRole;
    String? fullName;
    String? email;
    String? hashedPassword;
    String? token;
    String? phoneNumber;
    String? location;
    String? profilePhoto;
    String? aboutMe;
    int? totalStudents;
    int? totalSessions;
    double? rating;
    String? exp;
    List<String>? expertise;
    List<String>? certificate;
    int? activeProjects;
    int? completedProjects;
    List<Achievement>? achievements;
    int? age;
    String? school;
    String? dob;
    String? guardianName;
    String? guardianContact;
    String? cgpa;
    String? rank;
    List<dynamic>? currentProjects;
    String? mentor;
    List<dynamic>? totalProjects;
    List<dynamic>? completedProject;
    DateTime? createdAt;
    bool? isActive;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.datumId,
        this.userRole,
        this.fullName,
        this.email,
        this.hashedPassword,
        this.token,
        this.phoneNumber,
        this.location,
        this.profilePhoto,
        this.aboutMe,
        this.totalStudents,
        this.totalSessions,
        this.rating,
        this.exp,
        this.expertise,
        this.certificate,
        this.activeProjects,
        this.completedProjects,
        this.achievements,
        this.age,
        this.school,
        this.dob,
        this.guardianName,
        this.guardianContact,
        this.cgpa,
        this.rank,
        this.currentProjects,
        this.mentor,
        this.totalProjects,
        this.completedProject,
        this.createdAt,
        this.isActive,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        datumId: json["id"],
        userRole: json["user_role"],
        fullName: json["full_name"],
        email: json["email"],
        hashedPassword: json["hashed_password"],
        token: json["token"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        profilePhoto: json["profile_photo"],
        aboutMe: json["about_me"],
        totalStudents: json["total_students"],
        totalSessions: json["total_sessions"],
        rating: json["rating"]?.toDouble(),
        exp: json["exp"],
        expertise: json["expertise"] == null ? [] : List<String>.from(json["expertise"]!.map((x) => x)),
        certificate: json["certificate"] == null ? [] : List<String>.from(json["certificate"]!.map((x) => x)),
        activeProjects: json["active_projects"],
        completedProjects: json["completed_projects"],
        achievements: json["achievements"] == null ? [] : List<Achievement>.from(json["achievements"]!.map((x) => Achievement.fromJson(x))),
        age: json["age"],
        school: json["school"],
        dob: json["dob"],
        guardianName: json["guardian_name"],
        guardianContact: json["guardian_contact"],
        cgpa: json["cgpa"],
        rank: json["rank"],
        currentProjects: json["current_projects"] == null ? [] : List<dynamic>.from(json["current_projects"]!.map((x) => x)),
        mentor: json["mentor"],
        totalProjects: json["total_projects"] == null ? [] : List<dynamic>.from(json["total_projects"]!.map((x) => x)),
        completedProject: json["completed_project"] == null ? [] : List<dynamic>.from(json["completed_project"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isActive: json["is_active"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": datumId,
        "user_role": userRole,
        "full_name": fullName,
        "email": email,
        "hashed_password": hashedPassword,
        "token": token,
        "phone_number": phoneNumber,
        "location": location,
        "profile_photo": profilePhoto,
        "about_me": aboutMe,
        "total_students": totalStudents,
        "total_sessions": totalSessions,
        "rating": rating,
        "exp": exp,
        "expertise": expertise == null ? [] : List<dynamic>.from(expertise!.map((x) => x)),
        "certificate": certificate == null ? [] : List<dynamic>.from(certificate!.map((x) => x)),
        "active_projects": activeProjects,
        "completed_projects": completedProjects,
        "achievements": achievements == null ? [] : List<dynamic>.from(achievements!.map((x) => x.toJson())),
        "age": age,
        "school": school,
        "dob": dob,
        "guardian_name": guardianName,
        "guardian_contact": guardianContact,
        "cgpa": cgpa,
        "rank": rank,
        "current_projects": currentProjects == null ? [] : List<dynamic>.from(currentProjects!.map((x) => x)),
        "mentor": mentor,
        "total_projects": totalProjects == null ? [] : List<dynamic>.from(totalProjects!.map((x) => x)),
        "completed_project": completedProject == null ? [] : List<dynamic>.from(completedProject!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "is_active": isActive,
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Achievement {
    String? title;
    String? description;
    String? date;

    Achievement({
        this.title,
        this.description,
        this.date,
    });

    factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        title: json["title"],
        description: json["description"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "date": date,
    };
}
