import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:umad/models/CategoryModel.dart';
import 'package:umad/services/categoryService.dart';
import '../widgets/EventList.dart';
import '../models/EventTemplateModel.dart';
import '../services/eventTemplateService.dart';

class EventsPage extends StatefulWidget {
  final int userId;
  const EventsPage({super.key, required this.userId});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  DateTime selectedDate = DateTime.now();
  final CategoryService categoryService = CategoryService();
  final EventTemplateService eventTemplateService = EventTemplateService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // void addEvent(){
  //   Navigator.of(context).pushNamed('/categorySelection');
  //   print("add event");
  // }
final navigatorKey = GlobalKey<NavigatorState>();
@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => EventWidget(context);
              break;
            case '/categorySelection':
              builder = (BuildContext context) => CategorySelection(context);
              break;
            case '/addEvent':
              builder = (BuildContext context) => AddEventPage(context, settings.arguments as Category);
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }


  Widget EventWidget(context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Column(
                children: <Widget>[
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select date'),
                  ),
                ],
              ),
              ElevatedButton(
                // onPressed: ()=> Navigator.of(context).pushNamed('/addEvent'),
                onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection'),
                child: const Text('Add an event'))
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: EventList(date: selectedDate, userId: widget.userId),
        ),
      ],
    );
  }

  Widget CategorySelection(context){
    return FutureBuilder<List<Category>>(
      future :categoryService.getCategoriesByUserId(widget.userId),
      builder: (context, snapshot){

        if(snapshot.hasData) {
          List<Category> categories = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(categories[index].name),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addEvent', arguments: categories[index]);
                      },
                    );
                  },
                ),
              ),
                Expanded(
                  flex:1,
                  child: Form(
                    key:_formKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex:4,
                          child: TextFormField(
                            controller: titleController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please enter a category name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // print(titleController.text);
                                categoryService.addCategory(widget.userId, titleController.text).then((value) => Navigator.of(context).pushNamed('/addEvent', arguments: value));
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    )
                    ),
                )
                ],
          );
        }
        if(snapshot.hasError) {
          print("error");
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }

  Widget AddEventPage(context, Category category){
    return FutureBuilder(
      future: eventTemplateService.getEventTemplatesByCategoryId(widget.userId, category.idcategory),
      builder: (context, snapshot){
        print("arguments");
        print(category.idcategory);
        if(snapshot.hasData) {
          List<EventTemplate> eventTemplates = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: eventTemplates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(eventTemplates[index].name),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addEvent', arguments: eventTemplates[index]);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                  flex:1,
                  child: Form(
                      key:_formKey,
                      child: Row(
                        children: [
                          Expanded(
                            flex:4,
                            child: TextFormField(
                              controller: titleController,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter a category name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print(titleController.text);
                                  // eventTemplateService.addEventTemplate(widget.userId, category.idcategory, titleController.text).then((value) => Navigator.of(context).pushNamed('/addEvent', arguments: value));
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      )
                  )
              )
            ],
          );
        }
        if(snapshot.hasError) {
          print("error");
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
      );
  }

}



// Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//            Expanded(
//               flex: 1,
//               child: Row(
//                 children: [
//                   Column(
//                     children: <Widget>[
//                       Text("${selectedDate.toLocal()}".split(' ')[0]),
//                       const SizedBox(height: 20.0,),
//                       ElevatedButton(
//                         onPressed: () => _selectDate(context),
//                         child: const Text('Select date'),
//                       ),
//                     ],
//                   ),
//                   ElevatedButton(onPressed: addEvent, child: const Text('Add an event'))
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: EventList(date: selectedDate, userId: widget.userId),
//             ),
//           ],
//         );