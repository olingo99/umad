import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';
import '../widgets/userImage.dart';
import '../widgets/EventList.dart';


class UserPage extends StatefulWidget {
    final int userId;                               //The id of the user to display
    const UserPage({ Key? key,  required this.userId }) : super(key: key);
  
    @override
    _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
    late Future<User> futureUser;

    final UserService userService = UserService();
    _UserPageState();

    void refresh(){               //Refresh the widget, pass this function to the child widgets that need to refresh this widget on certain events
      didChangeDependencies();
      setState(() {});
    }

    @override
    void didChangeDependencies() {                                
        super.didChangeDependencies();
        futureUser = userService.getUserById(widget.userId);           //Get the user data from the database
    }
  
    //build the userPage using custom widgets build in the widgets folder
    @override
    Widget build(BuildContext context) {
        return FutureBuilder<User>(                                                 //Build the widget when the future is resolved, while waiting show a loading indicator
            future: futureUser,
            builder: (context, snapshot) {
                if(snapshot.hasData) {                                            //If the future is resolved, build the widget                 
                    return Column(
                      children: [
                        Expanded(
                          flex: 1,                                                  //make the widget take 1/3 of the available space
                          child: UserImage(userMood: snapshot.data?.mood ?? 0),     //User image widget, contains the user image, and mood indicator
                        ),

                        Expanded(
                          flex: 2,                                                   //make the widget take 2/3 of the available space
                          child: Container(
                            // margin: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.fromLTRB(0, 5.0,0, 0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(                              //Add a border to the widget                      
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Title(color: Colors.white, child: const Text("Today's Events", style: TextStyle(fontSize: 25, color: Colors.white),)),  //Title of the widget
                                Expanded(child: EventList(userId: widget.userId, date: DateTime.now(), notifyParent: refresh, friendMode: false,)),                             //List of events widget, declared in EventList.dart
                              ],
                            ))
                          ),
                      ],
                    );
                }
                if(snapshot.hasError) {                                                   //If the future has an error, show the error
                    return Text('Error: ${snapshot.error}');
                }
                return const CircularProgressIndicator();                                 //while waiting for the future, show a loading indicator
            }
        );
    }
}