// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
    bool? success;
    String? message;
    String? token;
    User? user;

    UserLoginModel({
        this.success,
        this.message,
        this.token,
        this.user,
    });

    factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        success: json["success"],
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "token": token,
        "user": user?.toJson(),
    };
}

class User {
    String? id;
    int? userId;
    String? userRole;
    String? fullName;
    String? email;
    String? token;
    String? phoneNumber;
    String? location;
    dynamic profilePhoto;
    dynamic aboutMe;
    int? totalStudents;
    int? totalSessions;
    double? rating;
    dynamic exp;
    List<dynamic>? expertise;
    List<dynamic>? certificate;
    int? activeProjects;
    int? completedProjects;
    List<dynamic>? achievements;
    dynamic age;
    dynamic school;
    dynamic dob;
    dynamic guardianName;
    dynamic guardianContact;
    dynamic cgpa;
    dynamic rank;
    List<dynamic>? currentProjects;
    dynamic mentor;
    List<dynamic>? totalProjects;
    List<dynamic>? completedProject;
    DateTime? createdAt;
    bool? isActive;

    User({
        this.id,
        this.userId,
        this.userRole,
        this.fullName,
        this.email,
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
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userId: json["id"],
        userRole: json["user_role"],
        fullName: json["full_name"],
        email: json["email"],
        token: json["token"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        profilePhoto: json["profile_photo"],
        aboutMe: json["about_me"],
        totalStudents: json["total_students"],
        totalSessions: json["total_sessions"],
        rating: json["rating"],
        exp: json["exp"],
        expertise: json["expertise"] == null ? [] : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        certificate: json["certificate"] == null ? [] : List<dynamic>.from(json["certificate"]!.map((x) => x)),
        activeProjects: json["active_projects"],
        completedProjects: json["completed_projects"],
        achievements: json["achievements"] == null ? [] : List<dynamic>.from(json["achievements"]!.map((x) => x)),
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
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": userId,
        "user_role": userRole,
        "full_name": fullName,
        "email": email,
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
        "achievements": achievements == null ? [] : List<dynamic>.from(achievements!.map((x) => x)),
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
    };
}
