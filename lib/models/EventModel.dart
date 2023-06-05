
// Event model
class Event {
    int idevent;  // id of event
    String name;  // name of event
    int iduser;   // id of user to which the event belongs
    int weight;   // weight of event
    DateTime date; // date of event
    int idcategory; // id of category to which the event belongs

    Event({      // constructor             
        required this.idevent,
        required this.name,
        required this.iduser,
        required this.weight,
        required this.date,
        required this.idcategory,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(  // factory constructor to create an event from a json
        idevent: json["idevent"],
        name: json["Name"],
        iduser: json["iduser"],
        weight: json["Weight"],
        date: DateTime.parse(json["Date"]),
        idcategory: json["idcategory"],
    );


    Map<String, dynamic> toJson() => {  // method to convert an event to a json
        "idevent": idevent,
        "Name": name,
        "iduser": iduser,
        "Weight": weight,
        "Date": date.toIso8601String(),
        "idcategory": idcategory,
    };
}