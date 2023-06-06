import 'package:flutter/material.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import '../models/CategoryModel.dart';
import '../services/categoryService.dart';
import '../constanst.dart';

class EventViewer extends StatelessWidget {
  final Event event;  //event to display
  final EventService eventService = EventService();
  final Function notifyParent;  //function to notify the parent widget to refresh
  final bool friend;  //if the event is displayed in the friend page
  EventViewer({super.key, required this.event, required this.notifyParent, this.friend = false});


  @override
  Widget build(BuildContext context) {  
    return FutureBuilder(
      future : CategoryService().getCategoryById(event.iduser, event.idcategory),             //get the category of the event
      builder: (context, snapshot) {
        if(snapshot.hasData) {                                                                 //if the category is loaded
          Category category = snapshot.data ?? Category(idcategory: 0, name: "error", iduser: 0);
          return Container(                                                                    //display the event, container to have a border and to add podding/margin
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(                                                        //border
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(                                                                       //row to display the event
                children: [
                  Expanded(
                    flex:5,
                    child: Column(                                                              //column to display the name and category of the event
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.name, style: const TextStyle(fontSize: 20)),               //name of the event
                        Text("Category :  ${category.name}", style: const TextStyle(fontSize: 15, color: Colors.grey)), //category of the event
                      ],
                    ),
                  ),
                  Text(event.weight.toString(), style: TextStyle(fontSize: 20, color: event.weight > 0 ? Colors.green : Colors.red)), //weight of the event (green if positive, red if negative) outside the column
                  friend? Container():Padding(                                                //if the event is displayed in the friend page, don't display the delete button
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){                                    //delete button
                      eventService.deleteEvent(event).then((value) => notifyParent(),);     //delete the event and refresh the page
                    }, child: const Icon(Icons.delete, semanticLabel: "delete icon",)),  
                  ),
                ],
              ),
            ),
          );
        }
        if(snapshot.hasError) {                                                              
          return Text("${snapshot.error}");                                              //display the error if there is one
        }
        return  CircularProgressIndicator(color: Constants().colorButton,);                                     //display a loading indicator while waiting for the category to load
      }
    );
  }

}