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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future : friendsService.getFriends(widget.userId),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          List<User> friends = snapshot.data ?? [];
          print("friends");
          print(snapshot.data);
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return UserViewer(friend: friends[index]);
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