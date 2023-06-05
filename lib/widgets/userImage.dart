import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class UserImage extends StatefulWidget {
    final int userMood;   //mood of the user, between -100 and 100
    bool vertical;        //if true, the gauge is vertical, else it is horizontal
    UserImage({ Key? key,  required this.userMood, this.vertical = false }) : super(key: key);
  
    @override
    _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {


    // build the widget containing the image and the gauge
    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(                            //image of the user
            getSourceImage(widget.userMood),      //get the image corresponding to the mood
            semanticLabel: "User image",
            width: 100,
          ),
          SfLinearGauge(                        //gauge of the user's mood
            minimum: -100.0,                  //minimum value of the gauge
            maximum: 100.0,                   //maximum value of the gauge
            interval: 50,                     //interval between each tick
            orientation: widget.vertical ? LinearGaugeOrientation.horizontal:LinearGaugeOrientation.vertical, //if vertical is true, the gauge is vertical, else it is horizontal
            barPointers: [                  //pointer of the gauge
              LinearBarPointer( 
                value: widget.userMood.toDouble(),
                thickness: 20,
                shaderCallback: (bounds) => const LinearGradient(   //color gradient of the gauge, TODO updated as to make the color gradient be static but to display only a part of it
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                           Colors.redAccent,
                          Colors.yellowAccent,
                         
                          Color(0xff00FF94),
                        ]).createShader(bounds),
                  )
            ],
          )

        ]);
    }

    String getSourceImage(int mood){  //get the image corresponding to the mood
    if (mood >90){
      return "assets/images/verryHappy.png";
    }
    if (mood >=0){
      return "assets/images/happy.png";
    }
    return 'assets/images/sad${(-mood/14).ceil()}.png'; //the image is chosen according to the curse level, we have 8 images for the sad mood with a mood going from -1 to -100 (for sad)
  }
}
