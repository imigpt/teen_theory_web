// To parse this JSON data, do
//
//     final allMyProjectModel = allMyProjectModelFromJson(jsonString);

import 'dart:convert';

AllMyProjectModel allMyProjectModelFromJson(String str) => AllMyProjectModel.fromJson(json.decode(str));

String allMyProjectModelToJson(AllMyProjectModel data) => json.encode(data.toJson());

class AllMyProjectModel {
    bool? success;
    String? message;
    List<MyProject>? data;

    AllMyProjectModel({
        this.success,
        this.message,
        this.data,
    });

    factory AllMyProjectModel.fromJson(Map<String, dynamic> json) => AllMyProjectModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MyProject>.from(json["data"]!.map((x) => MyProject.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class MyProject {
    int? id;
    String? title;
    String? projectType;
    String? projectDescription;
    String? status;
    String? createdByEmail;
    List<AssignedStudent>? assignedStudent;
    AssignedMentor? assignedMentor;
    String? projectCounsellor;
    List<Milestone>? milestones;
    List<dynamic>? tasks;
    String? deliverablesTitle;
    List<String>? deliverablesType;
    DateTime? dueDate;
    String? linkedMilestones;
    String? metadataAndReq;
    String? pageLimit;
    String? additionalInstructions;
    bool? allowMultipleSubmissions;
    bool? montorApproval;
    bool? counsellorApproval;
    String? resourcesType;
    String? resourcesTitle;
    String? resourcesDescription;
    String? attachedFiles;
    bool? studentVisibility;
    bool? mentorVisibility;
    String? sessionType;
    String? purpose;
    String? preferredTime;
    String? duration;
    DateTime? createdAt;

    MyProject({
        this.id,
        this.title,
        this.projectType,
        this.projectDescription,
        this.status,
        this.createdByEmail,
        this.assignedStudent,
        this.assignedMentor,
        this.projectCounsellor,
        this.milestones,
        this.tasks,
        this.deliverablesTitle,
        this.deliverablesType,
        this.dueDate,
        this.linkedMilestones,
        this.metadataAndReq,
        this.pageLimit,
        this.additionalInstructions,
        this.allowMultipleSubmissions,
        this.montorApproval,
        this.counsellorApproval,
        this.resourcesType,
        this.resourcesTitle,
        this.resourcesDescription,
        this.attachedFiles,
        this.studentVisibility,
        this.mentorVisibility,
        this.sessionType,
        this.purpose,
        this.preferredTime,
        this.duration,
        this.createdAt,
    });

    factory MyProject.fromJson(Map<String, dynamic> json) => MyProject(
        id: json["id"],
        title: json["title"],
        projectType: json["project_type"],
        projectDescription: json["project_description"],
        status: json["status"],
        createdByEmail: json["created_by_email"],
        assignedStudent: json["assigned_student"] == null ? [] : List<AssignedStudent>.from(json["assigned_student"]!.map((x) => AssignedStudent.fromJson(x))),
        assignedMentor: json["assigned_mentor"] == null ? null : AssignedMentor.fromJson(json["assigned_mentor"]),
        projectCounsellor: json["project_counsellor"],
        milestones: json["milestones"] == null ? [] : List<Milestone>.from(json["milestones"]!.map((x) => Milestone.fromJson(x))),
        tasks: json["tasks"] == null ? [] : List<dynamic>.from(json["tasks"]!.map((x) => x)),
        deliverablesTitle: json["deliverables_title"],
        deliverablesType: json["deliverables_type"] == null ? [] : List<String>.from(json["deliverables_type"]!.map((x) => x)),
        dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        linkedMilestones: json["linked_milestones"],
        metadataAndReq: json["metadata_and_req"],
        pageLimit: json["page_limit"],
        additionalInstructions: json["additional_instructions"],
        allowMultipleSubmissions: json["allow_multiple_submissions"],
        montorApproval: json["montor_approval"],
        counsellorApproval: json["counsellor_approval"],
        resourcesType: json["resources_type"],
        resourcesTitle: json["resources_title"],
        resourcesDescription: json["resources_description"],
        attachedFiles: json["attached_files"],
        studentVisibility: json["student_visibility"],
        mentorVisibility: json["mentor_visibility"],
        sessionType: json["session_type"],
        purpose: json["purpose"],
        preferredTime: json["preferred_time"],
        duration: json["duration"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
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
        "deliverables_title": deliverablesTitle,
        "deliverables_type": deliverablesType == null ? [] : List<dynamic>.from(deliverablesType!.map((x) => x)),
        "due_date": dueDate?.toIso8601String(),
        "linked_milestones": linkedMilestones,
        "metadata_and_req": metadataAndReq,
        "page_limit": pageLimit,
        "additional_instructions": additionalInstructions,
        "allow_multiple_submissions": allowMultipleSubmissions,
        "montor_approval": montorApproval,
        "counsellor_approval": counsellorApproval,
        "resources_type": resourcesType,
        "resources_title": resourcesTitle,
        "resources_description": resourcesDescription,
        "attached_files": attachedFiles,
        "student_visibility": studentVisibility,
        "mentor_visibility": mentorVisibility,
        "session_type": sessionType,
        "purpose": purpose,
        "preferred_time": preferredTime,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
    };
}

class AssignedMentor {
    String? id;
    String? name;
    String? email;
    String? subtitle;
    String? rating;
    String? reviews;

    AssignedMentor({
        this.id,
        this.name,
        this.email,
        this.subtitle,
        this.rating,
        this.reviews,
    });

    factory AssignedMentor.fromJson(Map<String, dynamic> json) => AssignedMentor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        subtitle: json["subtitle"],
        rating: json["rating"],
        reviews: json["reviews"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "subtitle": subtitle,
        "rating": rating,
        "reviews": reviews,
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
