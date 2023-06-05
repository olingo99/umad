// To parse this JSON data, do
//
//     final eventTemplate = eventTemplateFromJson(jsonString);

import 'dart:convert';

// EventTemplate eventTemplateFromJson(String str) => EventTemplate.fromJson(json.decode(str));

// String eventTemplateToJson(EventTemplate data) => json.encode(data.toJson());

class EventTemplate {
    int ideventTemplate;
    String name;
    int iduser;
    int proposedWeight;
    int idcategory;

    EventTemplate({
        required this.ideventTemplate,
        required this.name,
        required this.iduser,
        required this.proposedWeight,
        required this.idcategory,
    });

    factory EventTemplate.fromJson(Map<String, dynamic> json) => EventTemplate(
        ideventTemplate: json["ideventTemplate"],
        name: json["Name"],
        iduser: json["iduser"],
        proposedWeight: json["ProposedWeight"],
        idcategory: json["idcategory"],
    );

    Map<String, dynamic> toJson() => {
        "ideventTemplate": ideventTemplate,
        "Name": name,
        "iduser": iduser,
        "proposedWeight": proposedWeight,
        "idcategory": idcategory,
    };
}