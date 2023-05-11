// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    int idevent;
    String name;
    int iduser;
    int weight;
    DateTime date;
    int idcategory;

    Event({
        required this.idevent,
        required this.name,
        required this.iduser,
        required this.weight,
        required this.date,
        required this.idcategory,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        idevent: json["idevent"],
        name: json["Name"],
        iduser: json["iduser"],
        weight: json["weight"],
        date: DateTime.parse(json["date"]),
        idcategory: json["idcategory"],
    );

    Map<String, dynamic> toJson() => {
        "idevent": idevent,
        "Name": name,
        "iduser": iduser,
        "weight": weight,
        "date": date.toIso8601String(),
        "idcategory": idcategory,
    };
}