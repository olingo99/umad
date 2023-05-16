import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import 'package:flutter/material.dart';
import 'userImage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'EventViewer.dart';
import '../models/EventModel.dart';
import '../services/eventService.dart';
import '../services/friendService.dart';
import '../models/FriendsModel.dart';

class UserViewer extends StatelessWidget {
  UserViewer({super.key, required this.friend,required this.userId, required this.notifyParent, this.request = false});
  final User friend;
  final int userId;
  Function() notifyParent;
  bool request;
  final EventService eventService = EventService();
  List<Widget> childrenWidget = [];

  final FriendsService friendsService = FriendsService();

  @override
  Widget build(BuildContext context) {
    childrenWidget = [
          Image.asset(
            getSourceImage(friend.mood),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(friend.name),
                SfLinearGauge(
                  minimum: -100.0,
                  maximum: 100.0,
                  interval: 50,
                  orientation: LinearGaugeOrientation.horizontal,
                  barPointers: [
                    LinearBarPointer(
                      value: friend.mood.toDouble(),
                      thickness: 20,
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                            Colors.redAccent,
                          Colors.yellowAccent,
                          
                          Color(0xff00FF94),
                        ]).createShader(bounds),
                    )
              ],
            )
              ],
            ),
          ),
    ];

    if (request){
      childrenWidget.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: (){
          friendsService.acceptFriendRequest(userId, friend.iduser).then((value) => notifyParent());
          },
           child: Text("Accept")
          ),
      ));
      childrenWidget.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: (){friendsService.declineFriendRequest(userId, friend.iduser).then((value) => notifyParent());}, child: Text("Decline")),
      ));
    }
    else{
      childrenWidget.add(futureEventViewer(friend));
      childrenWidget.add(Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){}, child: Text("Chat")),
                          ))
                        );
      childrenWidget.add(Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){}, child: Text("Chat")),
                          ))
                        );
    }
    return SizedBox(
      height: 100,
      child: Row(
        children: childrenWidget,
      ),
    );
  }

  Widget friendBuilder(){
    return const Placeholder();
  }

  Widget requestBuilder(){
    return const Placeholder();
  }

  Widget futureEventViewer(User friend) {
    return FutureBuilder<List<Event>>(
      future: eventService.getLastEventsByUserId(friend.iduser),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(flex:2,child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: EventViewer(event: snapshot.data![0]),
          ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Placeholder();
      },
    );
  }


  String getSourceImage(int mood){
  if (mood >90){
    return "assets/images/verryHappy.png";
  }
  if (mood >=0){
    return "assets/images/happy.png";
  }
  return 'assets/images/sad${(-mood/14).ceil()}.png';
  }
}