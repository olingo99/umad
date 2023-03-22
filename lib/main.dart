import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Teachers',
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('UMad?'),
                ),
                body: const Center(
                    //child: Text('Hello World'),
                    child: MyHomePage(),
                ),
            ),
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  User user = User("Theo", 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            children: [
            Image.asset('assets/images/mad.png', height: 200,),
            Column(
              children: [
                Text(user.name),
                Text(user.aigreur.toString()),
              ],
            ),
            LinearProgressIndicator()
          ]
        ,),
        const Image(image: AssetImage('assets/images/graph.png')),
      ],
    );
  }
}



class User{
  final String name;
  int aigreur;

  User(this.name, this.aigreur);
}


void determinateIndicator(){
  Timer.periodic(
      Duration(seconds: 1),
          (Timer timer){
        setState(() {
          if(value == 1) {
            timer.cancel();
          }
          else {
            value = value + 0.1;
          }
        });
      }
  );
}