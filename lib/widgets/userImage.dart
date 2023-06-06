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
      
      int colorScale = (255*(1-((widget.userMood+100)/200))).toInt();
      return Container(
        decoration: BoxDecoration(                              //Add a border to the widget                      
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(                            //image of the user
              getSourceImage(widget.userMood),      //get the image corresponding to the mood
              semanticLabel: "User image with a curse level of ${(widget.userMood/14).ceil()}",
              // width: 100,
              fit: BoxFit.fitWidth,
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
                  color: Color.fromARGB(255,colorScale, 1-colorScale, 0)
                    )
              ],
            )
      
          ]),
      );
    }


}
