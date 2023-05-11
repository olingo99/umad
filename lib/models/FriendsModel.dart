// To parse this JSON data, do
//
//     final friendsMap = friendsMapFromJson(jsonString);

import 'dart:convert';

FriendsMap friendsMapFromJson(String str) => FriendsMap.fromJson(json.decode(str));

String friendsMapToJson(FriendsMap data) => json.encode(data.toJson());

class FriendsMap {
    int idfriendsMap;
    int iduser;
    DateTime date;
    int idfriend;
    String status;

    FriendsMap({
        required this.idfriendsMap,
        required this.iduser,
        required this.date,
        required this.idfriend,
        required this.status,
    });

    factory FriendsMap.fromJson(Map<String, dynamic> json) => FriendsMap(
        idfriendsMap: json["idfriendsMap"],
        iduser: json["iduser"],
        date: DateTime.parse(json["date"]),
        idfriend: json["idfriend"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "idfriendsMap": idfriendsMap,
        "iduser":iduser,
        "date": date.toIso8601String(),
        "idfriend": idfriend,
        "status": status,
    };
}