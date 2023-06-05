///User model
class User {
    int iduser;   //id of the user
    String name;  //name of the user
    String passWord;  //password of the user
    int mood;    //mood of the user
    bool admin;   //admin status of the user


    User({              //constructor
        required this.iduser,
        required this.name,
        required this.passWord,
        required this.mood,
        required this.admin,

    });

    factory User.fromJson(Map<String, dynamic> json) => User(  //factory constructor to create a user from a json
        
        iduser: json["iduser"],
        name: json["Name"],
        passWord: json["passWord"],
        mood: json["Mood"],
        admin: json["Admin"]?? false,

    );

    Map<String, dynamic> toJson() => {  //method to convert a user to a json
        "iduser": iduser,
        "Name": name,
        "passWord": passWord,
        "Mood": mood,
        "Admin": admin,
    };
}