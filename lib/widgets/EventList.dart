import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import 'EventViewer.dart';

class EventList extends StatelessWidget {
  EventList({super.key, required this.userId, required this.date});
  final int userId;
  final DateTime date;
  final EventService eventService = EventService();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventService.getEventsByDate(userId,date),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          List<Event> events = snapshot.data ?? [];
          print("events");
          print(snapshot.data);
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventViewer(event: events[index]);
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