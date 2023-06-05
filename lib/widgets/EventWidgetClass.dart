import 'package:flutter/material.dart';
import 'package:umad/models/CategoryModel.dart';
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
    // userId = args['userId'];
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
  // int userId = 0;
  Function refresh = (){};
  GlobalKey<FormState> _formKeyCategory = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyEvent = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
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

  Widget CategorySelection(int userId) {
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
                child: 
                ListView.separated(
                  itemBuilder:(context, index) {
                    return ListTile(
                      title: Text(categories[index].name),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addEvent', arguments: {'userId':userId,'category':categories[index]});
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                  ),
                  itemCount: categories.length)
              ),
                Expanded(
                  flex:1,
                  child: newCategoryWidget(userId, context),
                )
                ],
          );
        }
        if(snapshot.hasError) {
          print("error");
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(flex:4,child:  Align(alignment: Alignment.center, child: Text("No event categories Yet, create the first one!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
              Expanded(flex:1,child: Align(alignment: Alignment.bottomCenter, child: newCategoryWidget( userId, context))),
            ],
          );
        }
        return CircularProgressIndicator();
      }
    );
  }

  Widget newCategoryWidget(int userId, BuildContext context){
    return  Form(
      key:_formKeyCategory,
      child: Row(
        children: [
          Expanded(
            flex:3,
            child: TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "New category"),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  if (_formKeyCategory.currentState!.validate()) {
                    // print(titleController.text);
                    categoryService.addCategory(userId, categoryController.text).then((value) => Navigator.of(context).pushNamed('/addEvent', arguments: {'userId':userId,'category':value}));
                  }
                },
                // child: const Text('Submit new category'),
                child: const Icon(Icons.add),
              ),
          ),
        
        ],
      )
    );
  }

  Widget EventWidget(int userId, {required bool friendMode}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Events of : "+"${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  // const SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select date'),
                  ),
                ],
              ),
        ),
        Expanded(
          flex: 4,
          child: EventList(date: selectedDate, userId: userId,notifyParent: () {},friendMode: friendMode,),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            
            child: ElevatedButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection', arguments: userId).then((value){
                      print("value update on pop");
                      // setState((){});
                      refresh();
                      }),
                    child: const Text('Add an event')
                  ),
          ),
        )
      ],
    );
  }

    // Widget AddEventPage(int userId, Category category){
    Widget AddEventPage(Map<String, dynamic> args){
    Category category = args['category'];
    int userId = args['userId'];
    return FutureBuilder(
      future: eventTemplateService.getEventTemplatesByCategoryId(userId, category.idcategory),
      builder: (context, snapshot){
        print("arguments");
        print(category.idcategory);
        if(snapshot.hasData) {
          List<EventTemplate> eventTemplates = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(flex:1,child: newEventWidget(context,userId, category)),
              Text("Templates of : ${category.name}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(
                color: Colors.black,
              ),
        //       Row(
        //           children: const [
        //   Expanded(flex:2,child: Text("Name", style: TextStyle(fontSize: 20))),
        //   Expanded(
        //     flex:1,
        //     child: Text("Weight", style: TextStyle(fontSize: 20))
        //   ),
        //   Expanded(
        //     flex:1,
        //     child: SizedBox.shrink()
        //     ),
        //     Expanded(
        //     flex:1,
        //     child: SizedBox.shrink()
        //     )
        // ],
        //         ),
              Expanded(
                flex: 4,
                child: 
                ListView.separated(
                  itemBuilder: (context, index) {
                    return EventTemplateWidget(template: eventTemplates[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                  ),
                  itemCount: eventTemplates.length)
              ),
            ],
          );
        }
        if(snapshot.hasError) {
          print("error");
          return newEventWidget(context,userId, category);
        }
        return CircularProgressIndicator();
      }
      );
  }

  Widget newEventWidget(context,int userId, Category category){
    // titleController.text = "";
    return  Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text("New event", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Form(
                  key:_formKeyEvent,
                  child: Row(
                    children: [
                      Expanded(
                        flex:4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Event"),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please enter an event name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex:3,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            controller: weightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Weight"),
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
                        ),
                      Expanded(
                        flex:1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKeyEvent.currentState!.validate()) {
                              final newTemplate = EventTemplate(ideventTemplate: 0, name: titleController.text, iduser: userId, proposedWeight: int.parse(weightController.text), idcategory: category.idcategory);
                              eventTemplateService.addEventTemplate(newTemplate).then((value){
                                eventService.addEvent(newTemplate).then((value){
                                  Navigator.popUntil(context, (route){
                                  return route.settings.name.toString()=='/';
                                });
                                });

                                
                              });
                            }
                          },
                          child: const Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  )
              ),
      ],
    );
  }


}