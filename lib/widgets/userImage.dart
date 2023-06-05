import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../getSourceImage.dart';


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


}
