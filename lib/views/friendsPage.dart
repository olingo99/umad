import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/friendService.dart';
import '../widgets/UserViewer.dart';
import '../widgets/EventWidgetClass.dart';
import '../widgets/newSearch.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, required this.userId});
  final int userId;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsService friendsService = FriendsService();

  final navigatorKey = GlobalKey<NavigatorState>();


  refresh(){
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final widgetBuilder = EventWidgets(context : context,args: {"refresh": refresh,  "navigatorKey": navigatorKey});

    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => mainFriendPage(context);
              break;
            case '/seeEvents':
              builder = (BuildContext context) => widgetBuilder.EventWidget(settings.arguments as int);
              break;
            case '/categorySelection':
              builder = (BuildContext context) => widgetBuilder.CategorySelection(settings.arguments as int);
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


  Widget mainFriendPage(context){
    return Column(
      
      children: [

        Expanded(
          flex: 6,
          child: FutureBuilder(
            future : friendsService.getFriends(widget.userId),
            builder: (context, snapshot){
              if(snapshot.hasData) {
                List<User> friends = snapshot.data ?? [];
                print("friends");
                print(snapshot.data);
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                      decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                      child: UserViewer(friend: friends[index], userId: widget.userId, notifyParent: refresh, request: false,)
                      );
                  },
                );
              }
              if(snapshot.hasError) {
                print("error");
                return const Text("No friends yet!");
              }
              // return CircularProgressIndicator();
              return const Text("Loading");
            }
            ),
        ),
        Expanded(
          flex: 1,
          child: FutureBuilder(
            future : friendsService.getFriendRequests(widget.userId),
            builder: (context, snapshot){
              if(snapshot.hasData) {
                List<User> friends = snapshot.data ?? [];
                print("friends");
                print(snapshot.data);
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                      decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                      child: UserViewer(friend: friends[index],userId: widget.userId,notifyParent: refresh, request: true,),
                    );
                  },
                );
              }
              if(snapshot.hasError) {
                print("error");
                return const Text("no pending requests");
              }
              // return CircularProgressIndicator();
              return const Text("Loading");
            }
            ),
        ),
        searchBar(userId: widget.userId,),
      ],
    );
  }
}
