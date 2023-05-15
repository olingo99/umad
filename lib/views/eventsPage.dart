import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../widgets/EventList.dart';

class EventsPage extends StatefulWidget {
  final int userId;
  const EventsPage({super.key, required this.userId});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addEvent(){
    Navigator.of(context).pushNamed('/addEvent');
    print("add event");
  }
final navigatorKey = GlobalKey<NavigatorState>();
@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Events'),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Column(
                            children: <Widget>[
                              Text("${selectedDate.toLocal()}".split(' ')[0]),
                              const SizedBox(height: 20.0,),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: const Text('Select date'),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            // onPressed: ()=> Navigator.of(context).pushNamed('/addEvent'),
                            onPressed: () => navigatorKey.currentState!.pushNamed('/addEvent'),
                            child: const Text('Add an event'))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: EventList(date: selectedDate, userId: widget.userId),
                    ),
                  ],
                ),
              );
              break;
            case '/addEvent':
              builder = (BuildContext context) => Text("data");
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


// Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//            Expanded(
//               flex: 1,
//               child: Row(
//                 children: [
//                   Column(
//                     children: <Widget>[
//                       Text("${selectedDate.toLocal()}".split(' ')[0]),
//                       const SizedBox(height: 20.0,),
//                       ElevatedButton(
//                         onPressed: () => _selectDate(context),
//                         child: const Text('Select date'),
//                       ),
//                     ],
//                   ),
//                   ElevatedButton(onPressed: addEvent, child: const Text('Add an event'))
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: EventList(date: selectedDate, userId: widget.userId),
//             ),
//           ],
//         );