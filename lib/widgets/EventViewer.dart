import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import '../models/CategoryModel.dart';
import '../services/categoryService.dart';

class EventViewer extends StatelessWidget {
  final Event event;
  final EventService eventService = EventService();
  final Function notifyParent;
  final bool friend;
  EventViewer({super.key, required this.event, required this.notifyParent, this.friend = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future : CategoryService().getCategoryById(event.iduser, event.idcategory),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Category category = snapshot.data ?? Category(idcategory: 0, name: "error", iduser: 0);
          return Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex:5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name, style: TextStyle(fontSize: 20)),
                    Text("  ${category.name}", style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                ),
              ),
              Text(event.weight.toString(), style: TextStyle(fontSize: 20, color: event.weight > 0 ? Colors.green : Colors.red)),
              friend? Container():Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  eventService.deleteEvent(event).then((value) => notifyParent(),);
                }, child: Icon(Icons.delete)),
              ),
            ],
          );
        }
        if(snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }


  // Widget deleteButton(){

  // }
}