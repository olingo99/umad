import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:umad/models/CategoryModel.dart';
import 'package:umad/services/categoryService.dart';
import '../widgets/EventList.dart';
import '../models/EventTemplateModel.dart';
import '../services/eventTemplateService.dart';
import '../widgets/EventTemplateWidget.dart';
import 'package:flutter/services.dart';
import '../services/eventService.dart';

import '../widgets/EventWidgetClass.dart';

class EventsPage extends StatefulWidget {
  final int userId;
  const EventsPage({super.key, required this.userId});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

final navigatorKey = GlobalKey<NavigatorState>();

void refresh(){
  setState((){
  });
}


@override
  Widget build(BuildContext context) {

    final widgetBuilder = EventWidgets(context : context,args: {"refresh": refresh, "navigatorKey": navigatorKey});

    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => widgetBuilder.EventWidget(widget.userId);
              break;
            case '/categorySelection':
              builder = (BuildContext context) => widgetBuilder.CategorySelection(widget.userId);
              break;
            case '/addEvent':
              builder = (BuildContext context) => widgetBuilder.AddEventPage(settings.arguments as Map<String, dynamic>);
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