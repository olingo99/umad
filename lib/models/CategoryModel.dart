// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
    int idcategory;
    String name;
    int iduser;

    Category({
        required this.idcategory,
        required this.name,
        required this.iduser,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        idcategory: json["idcategory"],
        name: json["Name"],
        iduser: json["iduser"],
    );

    Map<String, dynamic> toJson() => {
        "idcategory": idcategory,
        "Name": name,
        "iduser": iduser,
    };
}