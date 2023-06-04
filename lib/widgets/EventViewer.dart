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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex:5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.name, style: const TextStyle(fontSize: 20)),
                      Text("Category :  ${category.name}", style: const TextStyle(fontSize: 15, color: Colors.grey)),
                    ],
                  ),
                ),
                Text(event.weight.toString(), style: TextStyle(fontSize: 20, color: event.weight > 0 ? Colors.green : Colors.red)),
                friend? Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    eventService.deleteEvent(event).then((value) => notifyParent(),);
                  }, child: const Icon(Icons.delete)),
                ),
              ],
            ),
          );
        }
        if(snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      }
    );
  }


  // Widget deleteButton(){

  // }
}