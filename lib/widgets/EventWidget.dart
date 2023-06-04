import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:umad/models/CategoryModel.dart';
import 'package:umad/services/categoryService.dart';
import '../widgets/EventList.dart';
import '../models/EventTemplateModel.dart';
import '../services/eventTemplateService.dart';
import '../widgets/EventTemplateWidget.dart';
import 'package:flutter/services.dart';
import '../services/eventService.dart';


// Widget EventWidget(context, Map<String, dynamic> args) {
//   DateTime selectedDate = args['selectedDate'];
//   Function _selectDate = args['_selectDate'];
//   final navigatorKey = args['navigatorKey'];
//   final userId = args['userId'];
//   Function refresh = args['refresh'];
//   final _formKeyCategory = args['_formKeyCategory'];
//   final titleController = args['titleController'];
//   return Column(
//   mainAxisSize: MainAxisSize.min,
//   children: [
//     Expanded(
//       flex: 1,
//       child: Row(
//         children: [
//           Column(
//             children: <Widget>[
//               Text("${selectedDate.toLocal()}".split(' ')[0]),
//               const SizedBox(height: 20.0,),
//               ElevatedButton(
//                 onPressed: () => _selectDate(context),
//                 child: const Text('Select date'),
//               ),
//             ],
//           ),
//           ElevatedButton(
//             // onPressed: ()=> Navigator.of(context).pushNamed('/addEvent'),
//             // onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection').then((value) => setState((){})),
//             onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection', arguments:{"userId": userId, "_formKeyCategory": _formKeyCategory, "titleController":titleController}).then((value){
//               print("value update on pop");
//               // setState((){});
//               refresh();

//               }),

//             child: const Text('Add an event'))
//         ],
//       ),
//     ),
//     Expanded(
//       flex: 4,
//       child: EventList(date: selectedDate, userId: userId,notifyParent: () {
        
//       },),
//     ),
//   ],
// );
// }