import 'package:flutter/material.dart';
import 'package:umad/services/friendService.dart';
import 'package:umad/services/userService.dart';

class searchBar extends StatefulWidget {
  const searchBar({super.key, required this.userId});
  final int userId; //id of the user, used to make the request to add a friend

  @override
  State<searchBar> createState() => _searchBarState();
}


// widget that displays the button to add a friend, the button opens a search bar to search for a friend
class _searchBarState extends State<searchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(onPressed: () {
          showSearch(context: context, delegate: SearchBarDelegate(userId:widget.userId));  //open the search bar
        }, child:const Text("Add Friend")),
    );

  }
}

class SearchBarDelegate extends SearchDelegate{   //class responsible for the search bar itself

  SearchBarDelegate({required this.userId});
  final int userId;  

  UserService userService = UserService();
  FriendsService friendsService = FriendsService();


  //Widget containing the clear button
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon:const Icon(Icons.clear), onPressed: () {
      query = ""; //clear the query
    })];
  }

  //Widget containing the back button
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
      close(context, ""); //close the search bar and return an empty string
    });
  }


  //Widget containing the results of the search (Results are displayed when the user confirms the search )
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(                                             //In a future builder to wait for the results of the search
      future: userService.getAllUserNames(query),                     //get the results of the search from the API
      builder: (context, snapshot) {
        if (snapshot.hasData) {                                      //if the results are here
          List<String> results = snapshot.data??[];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Row(                                            //for each result, display a row containing the name of the user and a button to add him as a friend
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:5,
                    child: ListTile(
                      title: Text(results[index]),
                      onTap: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index])); //close the search bar and add the user as a friend
                      },
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ElevatedButton(
                      onPressed: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index])); //close the search bar and add the user as a friend
                      },
                      child: const Text("Add"),
                    ),
                  )
                ],
              );
            }
          );
        } else {
          return Container();                                    //if the results are not here, return an empty container
        }
      },
    );
  }


  //Widget containing the suggestions of the search
  @override
  Widget buildSuggestions(BuildContext context) {

    return FutureBuilder(                                            //In a future builder to wait for the results of the search
      future: userService.getAllUserNames(query),                   //get the results of the search from the API
      builder: (context, snapshot) {
        if (snapshot.hasData) {                                    //if the results are here
          List<String> results = snapshot.data??[];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Row(                                         //for each result, display a row containing the name of the user and a button to add him as a friend
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:5,
                    child: ListTile(
                      title: Text(results[index]),
                      onTap: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index]));  //close the search bar and add the user as a friend
                      },
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ElevatedButton(
                      onPressed: () {
                        friendsService.addFriend(userId,results[index]).then((value) => close(context, results[index]));  //close the search bar and add the user as a friend
                        
                      },
                      child: const Text("Add"),
                    ),
                  )
                ],
              );
            }
          );
        } else {
          return Container();                                   //if the results are not here, return an empty container
        }
      },
    );
  }
}