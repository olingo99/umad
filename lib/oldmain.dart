import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umad/secondScreen.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'secondScreen.dart';

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
  User user = User("Theo", 1.0);
  List<double> points = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0];
  void onPressed(){
    user.aigreur=user.aigreur/2;
    points[2] = 10.0;
    setState(() {
      
    });
    print(user.aigreur);
    Navigator.push(context, MaterialPageRoute(builder: (context) => secondScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(onPressed: onPressed, child: Text("feur")),
        Row(
            children: [
            Image.asset('assets/images/mad.png', height: 200,),
            Padding(padding: EdgeInsets.all(10),),
            aigreurBar(user:user,),
          ]
        ,),

        LineChartWidget(points),
      ],
    );
  }
}



class User{
  final String name;
  double aigreur;

  User(this.name, this.aigreur);
}


class aigreurBar extends StatefulWidget {
  final User user;
  aigreurBar({Key? key, required this.user}) : super(key: key);

  @override
  _aigreurBarState createState() => _aigreurBarState();
}

class _aigreurBarState extends State<aigreurBar> {
  @override
  Widget build(BuildContext context) {
    // return RotatedBox(
    //     quarterTurns: -1,
    //     child: Container(
    //       height: 20,
    //       width: 100,
    //       child:LinearProgressIndicator(value:widget.user.aigreur)
    //     )
    //   );
    return Container(
      height: 180,
      width: 100,
      child:Row(
          children:[
            Column(
              children: [
                Text(widget.user.name),
                Container(width:30,child:Text(widget.user.aigreur.toString(),maxLines: 1,)),
              ],),
            RotatedBox(
            quarterTurns: -1,
            child:LinearProgressIndicator(value:widget.user.aigreur),),
          ],
      ) 
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> points;

  const LineChartWidget(this.points, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: points.map((point) => FlSpot(point, point*2)).toList(),
                isCurved: false,
                // dotData: FlDotData(
                //   show: false,
                // ),
              ),
            ],
          ),
      ),
    );
  }
}