import 'package:flutter/material.dart';
import 'package:umad/constanst.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import 'EventViewer.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.userId, required this.date, required this.notifyParent, required this.friendMode});
  final int userId;           // The user id used to get the events
  final DateTime date;        // The date to get the events from
  final Function() notifyParent;  // Function to notify the parent widget to refresh
  final bool friendMode;      // Whether the user is viewing their own events or a friend's events

  @override
  State<EventList> createState() => _EventListState();
}


//Build the list of events using the EventViewer widget
class _EventListState extends State<EventList> {
  final EventService eventService = EventService();

  void refresh(){
    widget.notifyParent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventService.getEventsByDate(widget.userId,widget.date),    //Get the events from the api as a future
      builder: (context, snapshot){   
        if(snapshot.hasData) {                                            //If the future is resolved, build the widget
          List<Event> events = snapshot.data ?? [];
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: EventViewer(event: events[index], notifyParent: refresh, friend: widget.friendMode,),
              );  //Build the event viewer widget for each event
            },
          );
        }
        if(snapshot.hasError) {
          return Text("${snapshot.error}");                              //If the future is rejected, show the error
        }
        return  CircularProgressIndicator(color: Constants().colorButton,);                //While waiting for the future to resolve, show a loading indicator
      }
    );
  }
}