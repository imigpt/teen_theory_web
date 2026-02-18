// To parse this JSON data, do
//
//     final googleCalenderModel = googleCalenderModelFromJson(jsonString);

import 'dart:convert';

GoogleCalenderModel googleCalenderModelFromJson(String str) => GoogleCalenderModel.fromJson(json.decode(str));

String googleCalenderModelToJson(GoogleCalenderModel data) => json.encode(data.toJson());

class GoogleCalenderModel {
    String? kind;
    String? etag;
    String? summary;
    String? description;
    DateTime? updated;
    String? timeZone;
    String? accessRole;
    List<DefaultReminder>? defaultReminders;
    String? nextSyncToken;
    List<Item>? items;

    GoogleCalenderModel({
        this.kind,
        this.etag,
        this.summary,
        this.description,
        this.updated,
        this.timeZone,
        this.accessRole,
        this.defaultReminders,
        this.nextSyncToken,
        this.items,
    });

    factory GoogleCalenderModel.fromJson(Map<String, dynamic> json) => GoogleCalenderModel(
        kind: json["kind"],
        etag: json["etag"],
        summary: json["summary"],
        description: json["description"],
        updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
        timeZone: json["timeZone"],
        accessRole: json["accessRole"],
        defaultReminders: json["defaultReminders"] == null ? [] : List<DefaultReminder>.from(json["defaultReminders"]!.map((x) => DefaultReminder.fromJson(x))),
        nextSyncToken: json["nextSyncToken"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "summary": summary,
        "description": description,
        "updated": updated?.toIso8601String(),
        "timeZone": timeZone,
        "accessRole": accessRole,
        "defaultReminders": defaultReminders == null ? [] : List<dynamic>.from(defaultReminders!.map((x) => x.toJson())),
        "nextSyncToken": nextSyncToken,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class DefaultReminder {
    String? method;
    int? minutes;

    DefaultReminder({
        this.method,
        this.minutes,
    });

    factory DefaultReminder.fromJson(Map<String, dynamic> json) => DefaultReminder(
        method: json["method"],
        minutes: json["minutes"],
    );

    Map<String, dynamic> toJson() => {
        "method": method,
        "minutes": minutes,
    };
}

class Item {
    String? kind;
    String? etag;
    String? id;
    String? status;
    String? htmlLink;
    DateTime? created;
    DateTime? updated;
    String? summary;
    String? description;
    Creator? creator;
    Creator? organizer;
    End? start;
    End? end;
    String? iCalUid;
    int? sequence;
    String? hangoutLink;
    ConferenceData? conferenceData;
    Reminders? reminders;
    String? eventType;

    Item({
        this.kind,
        this.etag,
        this.id,
        this.status,
        this.htmlLink,
        this.created,
        this.updated,
        this.summary,
        this.description,
        this.creator,
        this.organizer,
        this.start,
        this.end,
        this.iCalUid,
        this.sequence,
        this.hangoutLink,
        this.conferenceData,
        this.reminders,
        this.eventType,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        etag: json["etag"],
        id: json["id"],
        status: json["status"],
        htmlLink: json["htmlLink"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
        summary: json["summary"],
        description: json["description"],
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        organizer: json["organizer"] == null ? null : Creator.fromJson(json["organizer"]),
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        iCalUid: json["iCalUID"],
        sequence: json["sequence"],
        hangoutLink: json["hangoutLink"],
        conferenceData: json["conferenceData"] == null ? null : ConferenceData.fromJson(json["conferenceData"]),
        reminders: json["reminders"] == null ? null : Reminders.fromJson(json["reminders"]),
        eventType: json["eventType"],
    );

    Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id,
        "status": status,
        "htmlLink": htmlLink,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "summary": summary,
        "description": description,
        "creator": creator?.toJson(),
        "organizer": organizer?.toJson(),
        "start": start?.toJson(),
        "end": end?.toJson(),
        "iCalUID": iCalUid,
        "sequence": sequence,
        "hangoutLink": hangoutLink,
        "conferenceData": conferenceData?.toJson(),
        "reminders": reminders?.toJson(),
        "eventType": eventType,
    };
}

class ConferenceData {
    CreateRequest? createRequest;
    List<EntryPoint>? entryPoints;
    ConferenceSolution? conferenceSolution;
    String? conferenceId;

    ConferenceData({
        this.createRequest,
        this.entryPoints,
        this.conferenceSolution,
        this.conferenceId,
    });

    factory ConferenceData.fromJson(Map<String, dynamic> json) => ConferenceData(
        createRequest: json["createRequest"] == null ? null : CreateRequest.fromJson(json["createRequest"]),
        entryPoints: json["entryPoints"] == null ? [] : List<EntryPoint>.from(json["entryPoints"]!.map((x) => EntryPoint.fromJson(x))),
        conferenceSolution: json["conferenceSolution"] == null ? null : ConferenceSolution.fromJson(json["conferenceSolution"]),
        conferenceId: json["conferenceId"],
    );

    Map<String, dynamic> toJson() => {
        "createRequest": createRequest?.toJson(),
        "entryPoints": entryPoints == null ? [] : List<dynamic>.from(entryPoints!.map((x) => x.toJson())),
        "conferenceSolution": conferenceSolution?.toJson(),
        "conferenceId": conferenceId,
    };
}

class ConferenceSolution {
    Key? key;
    String? name;
    String? iconUri;

    ConferenceSolution({
        this.key,
        this.name,
        this.iconUri,
    });

    factory ConferenceSolution.fromJson(Map<String, dynamic> json) => ConferenceSolution(
        key: json["key"] == null ? null : Key.fromJson(json["key"]),
        name: json["name"],
        iconUri: json["iconUri"],
    );

    Map<String, dynamic> toJson() => {
        "key": key?.toJson(),
        "name": name,
        "iconUri": iconUri,
    };
}

class Key {
    String? type;

    Key({
        this.type,
    });

    factory Key.fromJson(Map<String, dynamic> json) => Key(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}

class CreateRequest {
    String? requestId;
    Key? conferenceSolutionKey;
    Status? status;

    CreateRequest({
        this.requestId,
        this.conferenceSolutionKey,
        this.status,
    });

    factory CreateRequest.fromJson(Map<String, dynamic> json) => CreateRequest(
        requestId: json["requestId"],
        conferenceSolutionKey: json["conferenceSolutionKey"] == null ? null : Key.fromJson(json["conferenceSolutionKey"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "conferenceSolutionKey": conferenceSolutionKey?.toJson(),
        "status": status?.toJson(),
    };
}

class Status {
    String? statusCode;

    Status({
        this.statusCode,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusCode: json["statusCode"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
    };
}

class EntryPoint {
    String? entryPointType;
    String? uri;
    String? label;

    EntryPoint({
        this.entryPointType,
        this.uri,
        this.label,
    });

    factory EntryPoint.fromJson(Map<String, dynamic> json) => EntryPoint(
        entryPointType: json["entryPointType"],
        uri: json["uri"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "entryPointType": entryPointType,
        "uri": uri,
        "label": label,
    };
}

class Creator {
    String? email;
    bool? self;

    Creator({
        this.email,
        this.self,
    });

    factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        email: json["email"],
        self: json["self"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "self": self,
    };
}

class End {
    DateTime? dateTime;
    String? timeZone;

    End({
        this.dateTime,
        this.timeZone,
    });

    factory End.fromJson(Map<String, dynamic> json) => End(
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        timeZone: json["timeZone"],
    );

    Map<String, dynamic> toJson() => {
        "dateTime": dateTime?.toIso8601String(),
        "timeZone": timeZone,
    };
}

class Reminders {
    bool? useDefault;

    Reminders({
        this.useDefault,
    });

    factory Reminders.fromJson(Map<String, dynamic> json) => Reminders(
        useDefault: json["useDefault"],
    );

    Map<String, dynamic> toJson() => {
        "useDefault": useDefault,
    };
}
