import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import '../services/userService.dart';


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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child:  Text(
                      "-100",
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.height*0.5,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "0",
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // SizedBox(width: MediaQuery.of(context).size.height*0.5,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "100",
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                ],
              ),
                        Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: 20,
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.yellow, Colors.green],
                    stops: [0, 0.5, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                // top: MediaQuery.of(context).size.height *(widget.userMood.toDouble()+100)/200,
                top: 200,

                child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.black,
                ),
              ),
            ],
          )
            ],
          ),

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