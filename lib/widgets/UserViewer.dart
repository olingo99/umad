
import '../models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../services/eventService.dart';
import '../services/friendService.dart';
import '../getSourceImage.dart';

class UserViewer extends StatelessWidget {
  UserViewer({super.key, required this.friend,required this.userId, required this.notifyParent, this.request = false});
  final User friend; //user to display
  final int userId; //id of the connected user, needed to accept or decline friend requests
  Function() notifyParent;  //function to call to refresh the parent widget
  bool request; //if true, the widget is used to display a friend request, else it is used to display a friend
  final EventService eventService = EventService();
  List<Widget> childrenWidget = [];

  final FriendsService friendsService = FriendsService();

  void refresh(){ 
    notifyParent(); //call the function to refresh the parent widget
  }

  @override
  Widget build(BuildContext context) {
    int colorScale = (255*(1-((friend.mood.toDouble()+100)/200))).toInt();
    childrenWidget = [                                                                            //list of the children widgets that make up the user viewer      
          Semantics(
            label: 'Image of ${friend.name} with a curse level of ${(-friend.mood/14).ceil()}',   //semantic label of the image
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.all(3.0), 
              child: Image.asset(                                                                 //image of the user
                getSourceImage(friend.mood),                                                      //get the image corresponding to the mood
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(                                                                        //column containing the name of the user and the gauge
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                Text(friend.name),                                                                //name of the user
                SfLinearGauge(                                                                    //gauge of the user's mood
                  minimum: -100.0,
                  maximum: 100.0,
                  interval: 50,
                  orientation: LinearGaugeOrientation.horizontal,                                //the gauge is horizontal
                  barPointers: [
                    LinearBarPointer(
                      value: friend.mood.toDouble(),
                      thickness: 20,
                      color: Color.fromARGB(255,colorScale, 1-colorScale, 0),
                    )
              ],
            )
              ],
            ),
          ),
    ];

    if (request){                                                                                        //if the widget is used to display a friend request
      childrenWidget.add(
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
              child: SizedBox(width:115,child: ElevatedButton(onPressed: (){                                                           //accept button
          friendsService.acceptFriendRequest(userId, friend.iduser).then((value) => notifyParent());    //send the "accept friend request" to the API and refresh the parent widget
          },
           child:const  Text("Accept") )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
              child: SizedBox(width:115, child: ElevatedButton(onPressed: (){friendsService.declineFriendRequest(userId, friend.iduser).then((value) => notifyParent());}, child:const Text("Decline"))),  //decline button, send the "decline friend request" to the API and refresh the parent widget
            ) ,        
          ],)
        )
      );
    }
    else{                                                                                              //if the widget is used to display a friend
      childrenWidget.add(                                                                             //add the see events and add an event buttons
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center , 
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
              child: SizedBox(width:115,child: ElevatedButton(onPressed: (){Navigator.of(context).pushNamed('/seeEvents', arguments: friend.iduser);}, child: const Text("See Events", ))), //see events button, navigate to the events page with the id of the friend as argument
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
              child: SizedBox(width:115, child: ElevatedButton(onPressed: (){Navigator.of(context).pushNamed('/categorySelection', arguments: friend.iduser);}, child: const Text("Add an event"))),  //add an event button, navigate to the category selection page with the id of the friend as argument
            ) ,        
          ],)
        )
      );

    }
    return SizedBox(                                                                                 //return the user viewer
      height: 100,
      child: Row(                                                                                  //row containing the children widgets
        children: childrenWidget, 
      ),
    );
  }

}