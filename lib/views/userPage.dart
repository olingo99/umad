import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';


class UserPage extends StatefulWidget {
    final int userId;
    const UserPage({ Key? key,  required this.userId }) : super(key: key);
  
    @override
    _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
    late Future<User> futureUser;

    final UserService userService = UserService();
    _UserPageState();

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        futureUser = userService.getUserById(widget.userId);
    }
  
    @override
    Widget build(BuildContext context) {
        return FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
                if(snapshot.hasData) {
                  String val = snapshot.data?.name ?? "";
                     
                    //return Text('Data: ${teachers.length} teachers');
                    return Text(
                      val,
                      style: const TextStyle(fontSize: 20),
                    );
                }
                if(snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                }
                return const CircularProgressIndicator();
            }
        );
    }
}