import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import 'EventViewer.dart';

class EventList extends StatefulWidget {
  EventList({super.key, required this.userId, required this.date});
  final int userId;
  final DateTime date;
  // final Function() notifyParent;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final EventService eventService = EventService();

  void refresh(){
    // widget.notifyParent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventService.getEventsByDate(widget.userId,widget.date),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          List<Event> events = snapshot.data ?? [];
          print("events");
          print(snapshot.data);
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventViewer(event: events[index], notifyParent: refresh,);
            },
          );
        }
        if(snapshot.hasError) {
          print("error");
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }
}