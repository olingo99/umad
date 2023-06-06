import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/friendService.dart';
import '../widgets/UserViewer.dart';
import '../widgets/EventWidgetClass.dart';
import '../widgets/newSearch.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, required this.userId});
  final int userId;                                       //id of the user

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}



///Friends page widget, shows the friends and friend requests, uses a navigator to change the content of the page
class _FriendsPageState extends State<FriendsPage> {
  final FriendsService friendsService = FriendsService();

  final navigatorKey = GlobalKey<NavigatorState>();


  refresh(){                                     //refreshes the page, function to be passed to child widgets that need to refresh the page on certain events
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final widgetBuilder = EventWidgets(context : context,args: {"refresh": refresh,  "navigatorKey": navigatorKey});      //widget builder, class that bundles all the widgets related to events, the class holds the navigator key and the refresh function so as to not pass them to every widget

    return WillPopScope(                                                                                                  //allows the back button to work, creates a scope for the navigator
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),                                                //allows the back button to work on the correct navigator
      child: Navigator(                                                                                                   //create a new navigator for the friend page, this navigator only changes the content of the page, so the app bar and bottom navigation bar stay the same
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => mainFriendPage(context);                                                  //main friend page, shows the friends and friend requests
              break;
            case '/seeEvents':
              builder = (BuildContext context) => widgetBuilder.EventWidget(settings.arguments as int, friendMode: true);                     //shows the events of a friend
              break;
            case '/categorySelection':
              builder = (BuildContext context) => widgetBuilder.CategorySelection(settings.arguments as int);              //shows the categories of a friend, displayed when the user wants to add an event to a friend         
              break;
            case '/addEvent':
              builder = (BuildContext context) => widgetBuilder.AddEventPage(settings.arguments as Map<String, dynamic>);   //add event page, allows the user to add an event to a friend, displayed after the user selects a category
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }


  //Displayes a list of friends using the user viewer widget
  Widget _friendList(context){
    return FutureBuilder(
      future : friendsService.getFriends(widget.userId),
      builder: (context, snapshot){
        if(snapshot.hasData) {                                                                  //if the data has been loaded, display the list of friends
          List<User> friends = snapshot.data ?? [];
          return ListView.builder(                                                              //list view builder, creates a list of user viewers, each user viewer is a friend
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                child: UserViewer(friend: friends[index], userId: widget.userId, notifyParent: refresh, request: false,)  //user viewer, displays the friend's name, picture and mood indicator + a button to see the friend's events and to add an event to the friend
                );
            },
          );
        }
        if(snapshot.hasError) {                                                                                                                                      //if there is an error, display a message, an empty friend lsit is considered as an error as it is returned as a 404 from the api
          return const Text("No friends yet!");                                                                                                                       
        }
        return const CircularProgressIndicator();
        // return const Text("Loading");
      }
      );
  }

  //Displayes a list of friend requests using the user viewer widget
  Widget _friendRequestList(context){
    return FutureBuilder(
      future : friendsService.getFriendRequests(widget.userId),
      builder: (context, snapshot){
        if(snapshot.hasData) {                                                          //if the data has been loaded, display the list of friend requests
          List<User> friends = snapshot.data ?? [];                               
          return ListView.builder(                                                        //list view builder, creates a list of user viewers, each user viewer is a friend request
            itemCount: friends.length,  
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                child: UserViewer(friend: friends[index],userId: widget.userId,notifyParent: refresh, request: true,),    //user viewer, displays the friend's name, picture and mood indicator + a button to accept or decline the friend request
              );
            },
          );
        }
        if(snapshot.hasError) {
          return const Text("no pending requests");
        }
        return const CircularProgressIndicator();
        // return const Text("Loading");
      }
      );
  }

  Widget mainFriendPage(context){                                                                 //widget building the main friend page, displays the friend list and friend request list + a button to add friends
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Friend list", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 5,
          child: _friendList(context),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.black),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Expanded(
        //     flex: 1,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text("Friend Requests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 2,
          child: _friendRequestList(context),
        ),
        searchBar(userId: widget.userId,),                                                         //Widget containing the search bar to add friends, dispalyes a button, when pressed, opens a new widget to search for friends
      ],
    );
  }
}
