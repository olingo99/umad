import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class UserImage extends StatefulWidget {
    final int userMood;
    const UserImage({ Key? key,  required this.userMood }) : super(key: key);
  
    @override
    _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {

    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Image.asset(
            getSourceImage(widget.userMood),

          ),
          //make a linear gauge ranging from -100 to 100 with 0 in the middle and the current mood as the value and the color of the gauge should be green if the mood is above 0 and red if the mood is below 0
          SfLinearGauge(
            minimum: -100.0,
            maximum: 100.0,
            interval: 50,
            orientation: LinearGaugeOrientation.vertical,
            barPointers: [
              LinearBarPointer(
                value: widget.userMood.toDouble(),
                thickness: 20,
                color: widget.userMood > 0 ? Colors.green : Colors.red,
              )
            ],
          )

        ]);
    }

    String getSourceImage(int mood){
    if (mood >90){
      return "assets/images/verryHappy.png";
    }
    if (mood >=0){
      return "assets/images/happy.png";
    }
    return 'assets/images/sad${(-mood/14).ceil()}.png';
  }
}



// class _UserImageState extends State<UserImage> {

//     @override
//     Widget build(BuildContext context) {
//       return Column(
//         children: [
//           Image.asset(
//             getSourceImage(widget.userMood),
//             width: 100,
//             height: 100,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: const Text(
//                   "-100",
//                   style: TextStyle(fontSize: 10),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//               // SizedBox(width: MediaQuery.of(context).size.height*0.5,),
//               Expanded(
//                 child: Text(
//                   "0",
//                   style: TextStyle(fontSize: 10),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               // SizedBox(width: MediaQuery.of(context).size.height*0.5,),
//               Expanded(
//                 child: Text(
//                   "100",
//                   style: TextStyle(fontSize: 10),
//                   textAlign: TextAlign.right,
//                 ),
//               ),

//             ],
//           ),
//           Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 width: double.infinity,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.red, Colors.yellow, Colors.green],
//                     stops: [0, 0.5, 1],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: MediaQuery.of(context).size.width *(widget.userMood.toDouble()+100)/200,
//                 child: Container(
//                   width: 2,
//                   height: 20,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           )
//         ]);
//     }

//     String getSourceImage(int mood){
//     if (mood >90){
//       return "assets/images/verryHappy.png";
//     }
//     if (mood >=0){
//       return "assets/images/happy.png";
//     }
//     return 'assets/images/sad${(-mood/14).ceil()}.png';
//   }
// }

    //       Container(
    //   height: 180,
    //   width: 100,
    //   child:Row(
    //       children:[
    //         Column(
    //           children: [
    //             Text(widget.userMood.toString()),
    //             Container(width:30,child:Text(widget.userMood.toString(),maxLines: 1,)),
    //           ],),
    //         RotatedBox(
    //         quarterTurns: -1,
    //         child:LinearProgressIndicator(value:widget.userMood.toDouble()),),
    //       ],
    //   ) 
    // )


//               Container(
//   padding: EdgeInsets.symmetric(vertical: 20),
//   width: double.infinity,
//   height: 20,
//   decoration: BoxDecoration(
//     gradient: LinearGradient(
//       colors: [Colors.red, Colors.yellow, Colors.green],
//       stops: [0, 0.5, 1],
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//     ),
//   ),
//   child: LayoutBuilder(
//     builder: (context, constraints) {
//       double progress = 0.5; // Set the progress value between 0 and 1
//       double indicatorPosition = progress * constraints.maxWidth;
//       return Stack(
//         children: [
//           Container(
//             width: indicatorPosition,
//             height: double.infinity,
//             color: Colors.black,
//           ),
//         ],
//       );
//     },
//   ),
// )