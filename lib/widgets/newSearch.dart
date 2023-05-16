import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:umad/services/friendService.dart';
import 'package:umad/services/userService.dart';

class searchBar extends StatefulWidget {
  const searchBar({super.key, required this.userId});
  final int userId;

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(context: context, delegate: SearchBarDelegate(userId:widget.userId));
      },
    );
  }
}

class SearchBarDelegate extends SearchDelegate{

  SearchBarDelegate({required this.userId});
  final int userId;  

  UserService userService = UserService();
  FriendsService friendsService = FriendsService();
  List<String> searchTerms = ["test", "test2", "test3"];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
      close(context, "");
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    // List<String> results = searchTerms.where((element) => element.contains(query)).toList();
    return FutureBuilder(
      future: userService.getAllUserNames(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> results = snapshot.data??[];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:5,
                    child: ListTile(
                      title: Text(results[index]),
                      onTap: () {
                        close(context, results[index]);
                      },
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ElevatedButton(
                      onPressed: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index]));
                        
                      },
                      child: Text("Add"),
                    ),
                  )
                ],
              );
            }
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<String> results = searchTerms.where((element) => element.contains(query)).toList();
    return FutureBuilder(
      future: userService.getAllUserNames(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> results = snapshot.data??[];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:5,
                    child: ListTile(
                      title: Text(results[index]),
                      onTap: () {
                        close(context, results[index]);
                      },
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ElevatedButton(
                      onPressed: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index]));
                        
                      },
                      child: Text("Add"),
                    ),
                  )
                ],
              );
            }
          );
        } else {
          return Container();
        }
      },
    );
  }
}