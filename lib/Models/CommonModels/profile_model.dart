// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    bool? success;
    String? message;
    Data? data;

    ProfileModel({
        this.success,
        this.message,
        this.data,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    int? id;
    String? userRole;
    String? fullName;
    String? email;
    String? phoneNumber;
    String? location;
    String? profilePhoto;
    dynamic aboutMe;
    int? totalStudents;
    int? totalSessions;
    double? rating;
    dynamic exp;
    List<String>? expertise;
    List<dynamic>? certificate;
    int? activeProjects;
    int? completedProjects;
    List<Achievement>? achievements;
    int? age;
    String? school;
    dynamic dob;
    dynamic guardianName;
    dynamic guardianContact;
    String? cgpa;
    dynamic rank;
    List<CurrentProject>? currentProjects;
    dynamic mentor;
    List<dynamic>? totalProjects;
    List<dynamic>? completedProject;
    String? start_shift_time;
    String? end_shift_time;
    DateTime? createdAt;
    bool? isActive;
    Data? child;
    List<AssignedProject>? assignedProjects;

    Data({
        this.id,
        this.userRole,
        this.fullName,
        this.email,
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
        this.start_shift_time,
        this.end_shift_time,
        this.createdAt,
        this.isActive,
        this.child,
        this.assignedProjects,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userRole: json["user_role"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        profilePhoto: json["profile_photo"],
        aboutMe: json["about_me"],
        totalStudents: json["total_students"],
        totalSessions: json["total_sessions"],
        rating: json["rating"],
        exp: json["exp"],
        expertise: json["expertise"] == null ? [] : List<String>.from(json["expertise"]!.map((x) => x)),
        certificate: json["certificate"] == null ? [] : List<dynamic>.from(json["certificate"]!.map((x) => x)),
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
        currentProjects: json["current_projects"] == null ? [] : List<CurrentProject>.from(json["current_projects"]!.map((x) => CurrentProject.fromJson(x))),
        mentor: json["mentor"],
        totalProjects: json["total_projects"] == null ? [] : List<dynamic>.from(json["total_projects"]!.map((x) => x)),
        completedProject: json["completed_project"] == null ? [] : List<dynamic>.from(json["completed_project"]!.map((x) => x)),
        start_shift_time: json["start_shift_time"],
        end_shift_time: json["end_shift_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isActive: json["is_active"],
        child: json["child"] == null || json["child"] is! Map<String, dynamic> ? null : Data.fromJson(json["child"]),
        assignedProjects: json["assigned_projects"] == null ? [] : List<AssignedProject>.from(json["assigned_projects"]!.map((x) => AssignedProject.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_role": userRole,
        "full_name": fullName,
        "email": email,
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
        "current_projects": currentProjects == null ? [] : List<dynamic>.from(currentProjects!.map((x) => x.toJson())),
        "mentor": mentor,
        "total_projects": totalProjects == null ? [] : List<dynamic>.from(totalProjects!.map((x) => x)),
        "completed_project": completedProject == null ? [] : List<dynamic>.from(completedProject!.map((x) => x)),
        "start_shift_time": start_shift_time,
        "end_shift_time": end_shift_time,
        "created_at": createdAt?.toIso8601String(),
        "is_active": isActive,
        "child": child?.toJson(),
        "assigned_projects": assignedProjects == null ? [] : List<dynamic>.from(assignedProjects!.map((x) => x.toJson())),
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

class AssignedProject {
    int? projectId;
    String? title;
    String? projectType;
    String? projectDescription;
    String? status;
    String? createdByEmail;
    CreatedByUser? createdByUser;
    List<AssignedStudent>? assignedStudent;
    AssignedMentor? assignedMentor;
    String? projectCounsellor;
    List<Milestone>? milestones;
    List<dynamic>? tasks;
    DateTime? dueDate;
    String? attachedFiles;
    DateTime? createdAt;

    AssignedProject({
        this.projectId,
        this.title,
        this.projectType,
        this.projectDescription,
        this.status,
        this.createdByEmail,
        this.createdByUser,
        this.assignedStudent,
        this.assignedMentor,
        this.projectCounsellor,
        this.milestones,
        this.tasks,
        this.dueDate,
        this.attachedFiles,
        this.createdAt,
    });

    factory AssignedProject.fromJson(Map<String, dynamic> json) => AssignedProject(
        projectId: json["project_id"],
        title: json["title"],
        projectType: json["project_type"],
        projectDescription: json["project_description"],
        status: json["status"],
        createdByEmail: json["created_by_email"],
        createdByUser: json["created_by_user"] == null ? null : CreatedByUser.fromJson(json["created_by_user"]),
        assignedStudent: json["assigned_student"] == null ? [] : List<AssignedStudent>.from(json["assigned_student"]!.map((x) => AssignedStudent.fromJson(x))),
        assignedMentor: json["assigned_mentor"] == null ? null : AssignedMentor.fromJson(json["assigned_mentor"]),
        projectCounsellor: json["project_counsellor"],
        milestones: json["milestones"] == null ? [] : List<Milestone>.from(json["milestones"]!.map((x) => Milestone.fromJson(x))),
        tasks: json["tasks"] == null ? [] : List<dynamic>.from(json["tasks"]!.map((x) => x)),
        dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        attachedFiles: json["attached_files"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "title": title,
        "project_type": projectType,
        "project_description": projectDescription,
        "status": status,
        "created_by_email": createdByEmail,
        "assigned_student": assignedStudent == null ? [] : List<dynamic>.from(assignedStudent!.map((x) => x.toJson())),
        "assigned_mentor": assignedMentor?.toJson(),
        "project_counsellor": projectCounsellor,
        "milestones": milestones == null ? [] : List<dynamic>.from(milestones!.map((x) => x.toJson())),
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x)),
        "due_date": dueDate?.toIso8601String(),
        "attached_files": attachedFiles,
        "created_at": createdAt?.toIso8601String(),
    };
}

class CreatedByUser {
  int? id;
  String? full_name;
  String? email;
  String? profile_photo;
  String? user_role;
  String? start_shift_time;
  String? end_shift_time;

  CreatedByUser({
    this.id,
    this.full_name,
    this.email,
    this.profile_photo,
    this.user_role,
    this.start_shift_time,
    this.end_shift_time,
  });

  factory CreatedByUser.fromJson(Map<String, dynamic> json) => CreatedByUser(
    id: json["id"],
    full_name: json["full_name"],
    email: json["email"],
    profile_photo: json["profile_photo"],
    user_role: json["user_role"],
    start_shift_time: json["start_shift_time"],
    end_shift_time: json["end_shift_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": full_name,
    "email": email,
    "profile_photo": profile_photo,
    "user_role": user_role,
    "start_shift_time": start_shift_time,
    "end_shift_time": end_shift_time,
  };
}

class AssignedMentor {
    String? id;
    String? name;
    String? email;
    String? subtitle;
    String? rating;
    String? reviews;
    String? start_shift_time;
    String? end_shift_time;

    AssignedMentor({
        this.id,
        this.name,
        this.email,
        this.subtitle,
        this.rating,
        this.reviews,
        this.start_shift_time,
        this.end_shift_time
    });

    factory AssignedMentor.fromJson(Map<String, dynamic> json) => AssignedMentor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        subtitle: json["subtitle"],
        rating: json["rating"],
        reviews: json["reviews"],
        start_shift_time: json["start_shift_time"],
        end_shift_time: json["end_shift_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "subtitle": subtitle,
        "rating": rating,
        "reviews": reviews,
        "start_shift_time": start_shift_time,
        "end_shift_time": end_shift_time,
    };
}

class AssignedStudent {
    String? id;
    String? name;
    String? grade;

    AssignedStudent({
        this.id,
        this.name,
        this.grade,
    });

    factory AssignedStudent.fromJson(Map<String, dynamic> json) => AssignedStudent(
        id: json["id"],
        name: json["name"],
        grade: json["grade"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "grade": grade,
    };
}

class Milestone {
    String? name;
    DateTime? dueDate;
    String? weight;
    List<Task>? tasks;
    String? id;
    String? status;
    List<String>? attachments;
    DateTime? updatedAt;

    Milestone({
        this.name,
        this.dueDate,
        this.weight,
        this.tasks,
        this.id,
        this.status,
        this.attachments,
        this.updatedAt,
    });

    factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        name: json["name"],
        dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        weight: json["weight"],
        tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
        id: json["id"],
        status: json["status"],
        attachments: json["attachments"] == null ? [] : List<String>.from(json["attachments"]!.map((x) => x)),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "dueDate": dueDate?.toIso8601String(),
        "weight": weight,
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "id": id,
        "status": status,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Task {
    String? title;
    dynamic type;
    dynamic dueDate;
    dynamic priority;
    String? status;
    List<String>? attachments;

    Task({
        this.title,
        this.type,
        this.dueDate,
        this.priority,
        this.status,
        this.attachments,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json["title"],
        type: json["type"],
        dueDate: json["dueDate"],
        priority: json["priority"],
        status: json["status"],
        attachments: json["attachments"] == null ? [] : List<String>.from(json["attachments"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "dueDate": dueDate,
        "priority": priority,
        "status": status,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
    };
}

class CurrentProject {
    int? projectId;
    String? title;
    String? status;
    DateTime? assignedDate;

    CurrentProject({
        this.projectId,
        this.title,
        this.status,
        this.assignedDate,
    });

    factory CurrentProject.fromJson(Map<String, dynamic> json) => CurrentProject(
        projectId: json["project_id"],
        title: json["title"],
        status: json["status"],
        assignedDate: json["assigned_date"] == null ? null : DateTime.parse(json["assigned_date"]),
    );

    Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "title": title,
        "status": status,
        "assigned_date": assignedDate?.toIso8601String(),
    };
}
