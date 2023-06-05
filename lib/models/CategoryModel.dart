import 'dart:convert';

// Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

// String categoryToJson(Category data) => json.encode(data.toJson());

/// Category model
class Category {
    int idcategory;   //id of the category
    String name;      //name of the category
    int iduser;       //id of the user to which the category belongs

    Category({        //constructor     
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