
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

    factory Category.fromJson(Map<String, dynamic> json) => Category(   //factory constructor to create a category from a json
        idcategory: json["idcategory"],
        name: json["Name"],
        iduser: json["iduser"],
    );

    Map<String, dynamic> toJson() => {                                  //method to convert a category to a json
        "idcategory": idcategory,
        "Name": name,
        "iduser": iduser,
    };
}