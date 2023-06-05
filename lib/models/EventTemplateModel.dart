// To parse this JSON data, do
//
//     final eventTemplate = eventTemplateFromJson(jsonString);

import 'dart:convert';

// EventTemplate eventTemplateFromJson(String str) => EventTemplate.fromJson(json.decode(str));

// String eventTemplateToJson(EventTemplate data) => json.encode(data.toJson());


//EventTemplate model
class EventTemplate {  
    int ideventTemplate;  //id of the event template
    String name;          //name of the event template
    int iduser;             //id of the user to which the event template belongs
    int proposedWeight;     //proposed weight of the event template
    int idcategory;         //id of the category to which the event template belongs

    EventTemplate({         //constructor
        required this.ideventTemplate,
        required this.name,
        required this.iduser,
        required this.proposedWeight,
        required this.idcategory,
    });

    factory EventTemplate.fromJson(Map<String, dynamic> json) => EventTemplate(   //factory constructor to create an event template from a json
        ideventTemplate: json["ideventTemplate"],
        name: json["Name"],
        iduser: json["iduser"],
        proposedWeight: json["ProposedWeight"],
        idcategory: json["idcategory"],
    );

    Map<String, dynamic> toJson() => {                                        //method to convert an event template to a json
        "ideventTemplate": ideventTemplate,
        "Name": name,
        "iduser": iduser,
        "proposedWeight": proposedWeight,
        "idcategory": idcategory,
    };
}