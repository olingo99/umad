import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';
import '../models/FriendsModel.dart';
import '../services/friendService.dart';
import '../widgets/UserViewer.dart';

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
    return Placeholder();
    // return WillPopScope(
    //   onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
    //   child: Navigator(
    //     key: navigatorKey,
    //     initialRoute: '/',
    //     onGenerateRoute: (RouteSettings settings) {
    //       WidgetBuilder builder;
    //       switch (settings.name) {
    //         case '/':
    //           builder = (BuildContext context) => mainFriendPage(context);
    //           break;
    //         case '/categorySelection':
    //           builder = (BuildContext context) => CategorySelection(context);
    //           break;
    //         case '/addEvent':
    //           builder = (BuildContext context) => AddEventPage(context, settings.arguments as Category);
    //           break;
    //         case '/eventPage':
    //           builder = (BuildContext context) => EventPage(context, settings.arguments as Event);
    //           break;
    //         default:
    //           throw Exception('Invalid route: ${settings.name}');
    //       }
    //       return MaterialPageRoute(builder: builder, settings: settings);
    //     },
    //   ),
    // );
  }

  Widget addFriendForm(){
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _controller = TextEditingController();
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter a username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  friendsService.addFriend(widget.userId, _controller.text);
                  _controller.clear();
                }
              },
              child: const Text('Add Friend'),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainFriendPage(context){
    return Column(
      
      children: [
        Expanded(
          flex: 1,
          child : addFriendForm(),
        ),
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
                    return UserViewer(friend: friends[index], userId: widget.userId, notifyParent: refresh, request: false,);
                  },
                );
              }
              if(snapshot.hasError) {
                print("error");
                return Text("No friends yet!");
              }
              // return CircularProgressIndicator();
              return Text("Loading");
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
                    return UserViewer(friend: friends[index],userId: widget.userId,notifyParent: refresh, request: true,);
                  },
                );
              }
              if(snapshot.hasError) {
                print("error");
                return Text("no pending requests");
              }
              // return CircularProgressIndicator();
              return Text("Loading");
            }
            ),
        )
      ],
    );
  }
}


// Column(
      
//       children: [
//         Expanded(
//           flex: 1,
//           child : addFriendForm(),
//         ),
//         Expanded(
//           flex: 6,
//           child: FutureBuilder(
//             future : friendsService.getFriends(widget.userId),
//             builder: (context, snapshot){
//               if(snapshot.hasData) {
//                 List<User> friends = snapshot.data ?? [];
//                 print("friends");
//                 print(snapshot.data);
//                 return ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     return UserViewer(friend: friends[index], userId: widget.userId, notifyParent: refresh, request: false,);
//                   },
//                 );
//               }
//               if(snapshot.hasError) {
//                 print("error");
//                 return Text("No friends yet!");
//               }
//               // return CircularProgressIndicator();
//               return Text("Loading");
//             }
//             ),
//         ),
//         Expanded(
//           flex: 1,
//           child: FutureBuilder(
//             future : friendsService.getFriendRequests(widget.userId),
//             builder: (context, snapshot){
//               if(snapshot.hasData) {
//                 List<User> friends = snapshot.data ?? [];
//                 print("friends");
//                 print(snapshot.data);
//                 return ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     return UserViewer(friend: friends[index],userId: widget.userId,notifyParent: refresh, request: true,);
//                   },
//                 );
//               }
//               if(snapshot.hasError) {
//                 print("error");
//                 return Text("no pending requests");
//               }
//               // return CircularProgressIndicator();
//               return Text("Loading");
//             }
//             ),
//         )
//       ],
//     )