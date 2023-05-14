// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int iduser;
    String name;
    String passWord;
    int mood;
    bool admin;


    User({
        required this.iduser,
        required this.name,
        required this.passWord,
        required this.mood,
        required this.admin,

    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        
        iduser: json["iduser"],
        name: json["Name"],
        passWord: json["passWord"],
        mood: json["Mood"],
        admin: json["Admin"]?? false,

    );

    Map<String, dynamic> toJson() => {
        "iduser": iduser,
        "Name": name,
        "passWord": passWord,
        "Mood": mood,
        "Admin": admin,
    };
}