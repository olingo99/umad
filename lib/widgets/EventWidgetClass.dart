import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:umad/models/CategoryModel.dart';
import 'package:umad/models/EventModel.dart';
import 'package:umad/services/categoryService.dart';
import '../widgets/EventList.dart';
import '../models/EventTemplateModel.dart';
import '../services/eventTemplateService.dart';
import '../widgets/EventTemplateWidget.dart';
import 'package:flutter/services.dart';
import '../services/eventService.dart';


class EventWidgets{
  EventWidgets({required this.context, required this.args}){
    // selectedDate = args['selectedDate'];
    // _selectDate = args['_selectDate'];
    navigatorKey = args['navigatorKey'];
    userId = args['userId'];
    refresh = args['refresh'];
    // _formKeyCategory = args['_formKeyCategory'];
    // titleController = args['titleController'];
    // weightController = args['weightController'];
    // _formKeyEvent = args['_formKeyEvent'];
  }

  final CategoryService categoryService = CategoryService();

  final BuildContext context;
  final Map<String, dynamic> args;
  DateTime selectedDate = DateTime.now();
  // Function _selectDate = (){};
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int userId = 0;
  Function refresh = (){};
  GlobalKey<FormState> _formKeyCategory = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyEvent = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final EventTemplateService eventTemplateService = EventTemplateService();
  final EventService eventService = EventService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print("picked != null && picked != selectedDate");
      print(picked);
      selectedDate = picked;
      refresh();
    }
  }

  Widget CategorySelection() {
    print("CategorySelection");
    return FutureBuilder<List<Category>>(
      future :categoryService.getCategoriesByUserId(userId),
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
                    key:_formKeyCategory,
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
                              if (_formKeyCategory.currentState!.validate()) {
                                // print(titleController.text);
                                categoryService.addCategory(userId, titleController.text).then((value) => Navigator.of(context).pushNamed('/addEvent', arguments: value));
                              }
                            },
                            child: const Text('Submit new category'),
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

    Widget EventWidget(){
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
                // onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection').then((value) => setState((){})),
                onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection').then((value){
                  print("value update on pop");
                  // setState((){});
                  refresh();

                  }),

                child: const Text('Add an event'))
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: EventList(date: selectedDate, userId: userId,notifyParent: () {
            
          },),
        ),
      ],
    );
  }

    Widget AddEventPage(Category category){
    return FutureBuilder(
      future: eventTemplateService.getEventTemplatesByCategoryId(userId, category.idcategory),
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
                    return EventTemplateWidget(template: eventTemplates[index]);
                  },
                ),
              ),
              newEventWidget(context, category),
            ],
          );
        }
        if(snapshot.hasError) {
          print("error");
          return newEventWidget(context, category);
        }
        return CircularProgressIndicator();
      }
      );
  }

  Widget newEventWidget(context, Category category){
    return  Expanded(
                  flex:1,
                  child: Form(
                      key:_formKeyEvent,
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
                            flex:4,
                            child: TextFormField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                // FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                              ],
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Please enter a weight";
                                }
                                return null;
                              },
                              ),
                            ),
                          Expanded(
                            flex:1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKeyEvent.currentState!.validate()) {
                                  print(titleController.text);
                                  final newTemplate = EventTemplate(ideventTemplate: 0, name: titleController.text, iduser: userId, proposedWeight: int.parse(weightController.text), idcategory: category.idcategory);
                                  eventTemplateService.addEventTemplate(newTemplate).then((value){
                                    eventService.addEvent(newTemplate).then((value){
                                      Navigator.popUntil(context, (route){
                                      print("route");
                                      print(route.settings.name);
                                      print(route.toString());
                                      return route.settings.name.toString()=='/';
                                    });
                                    });

                                    
                                  });
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      )
                  )
              );
  }


}