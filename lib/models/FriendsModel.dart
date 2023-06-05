// To parse this JSON data, do
//
//     final friendsMap = friendsMapFromJson(jsonString);

import 'dart:convert';

// FriendsMap friendsMapFromJson(String str) => FriendsMap.fromJson(json.decode(str));

// String friendsMapToJson(FriendsMap data) => json.encode(data.toJson());
/// FriendsMap model
class FriendsMap {
    int idfriendsMap;   //id of the friendsmap
    int iduser;         //id of the user to which the friendsmap belongs
    DateTime date;      //date of the friendsmap
    int idfriend;       //id of the friend 
    String status;      //status of the friendsmap

    FriendsMap({     //constructor        
        required this.idfriendsMap,
        required this.iduser,
        required this.date,
        required this.idfriend,
        required this.status,
    });

    factory FriendsMap.fromJson(Map<String, dynamic> json) => FriendsMap(   //factory constructor to create a friendsmap from a json
        idfriendsMap: json["idfriendsmap"],
        iduser: json["iduser"],
        date: DateTime.parse(json["date"]),
        idfriend: json["idfriend"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {    //method to convert a friendsmap to a json
        "idfriendsMap": idfriendsMap,
        "iduser":iduser,
        "date": date.toIso8601String(),
        "idfriend": idfriend,
        "status": status,
    };
}