import 'package:flutter/material.dart';
import '../widgets/EventWidgetClass.dart';

class EventsPage extends StatefulWidget {
  final int userId;                                     //Id of the user that is logged in
  const EventsPage({super.key, required this.userId});  

  @override
  State<EventsPage> createState() => _EventsPageState();
}


///Events page widget, uses a navigator to change between the different pages of the events section
class _EventsPageState extends State<EventsPage> {

final navigatorKey = GlobalKey<NavigatorState>();

void refresh(){                              //refreshes the page, function to be passed to child widgets that need to refresh the page on certain events
  setState((){
  });
}


@override
  Widget build(BuildContext context) {

    final widgetBuilder = EventWidgets(context : context,args: {"refresh": refresh, "navigatorKey": navigatorKey});     //widget builder, class that bundles all the widgets related to events, the class holds the navigator key and the refresh function so as to not pass them to every widget

    return WillPopScope(                                                                                                //allows the back button to work, creates a scope for the navigator
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),                                              //allows the back button to work on the correct navigator
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => widgetBuilder.EventWidget(widget.userId, friendMode: false);                               //main events page, shows the events of the user
              break;
            case '/categorySelection':
              builder = (BuildContext context) => widgetBuilder.CategorySelection(widget.userId);                         //shows the categories of the user, displayed when the user wants to add an event
              break;
            case '/addEvent':
              builder = (BuildContext context) => widgetBuilder.AddEventPage(settings.arguments as Map<String, dynamic>); //add event page, allows the user to add an event, displayed after the user selects a category
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}