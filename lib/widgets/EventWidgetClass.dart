import 'package:flutter/material.dart';
import 'package:umad/models/CategoryModel.dart';
import 'package:umad/services/categoryService.dart';
import '../widgets/EventList.dart';
import '../models/EventTemplateModel.dart';
import '../services/eventTemplateService.dart';
import '../widgets/EventTemplateWidget.dart';
import 'package:flutter/services.dart';
import '../services/eventService.dart';


// class that bundles all the widget for event creattion together to make it easier to make them interact with the same naivgatorKey and refresh function
class EventWidgets{
  EventWidgets({required this.context, required this.args}){
    navigatorKey = args['navigatorKey'];
    refresh = args['refresh'];
  }

  final CategoryService categoryService = CategoryService();
  final EventTemplateService eventTemplateService = EventTemplateService();
  final EventService eventService = EventService();

  final BuildContext context;
  final Map<String, dynamic> args;          //arguments passed to the class, contains the navigatorKey and the refresh function
  DateTime selectedDate = DateTime.now();   //date selected by the user
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); //key for the navigator
  Function refresh = (){};                //function to refresh the page
  final GlobalKey<FormState> _formKeyCategory = GlobalKey<FormState>(); //key for the category form
  final GlobalKey<FormState> _formKeyEvent = GlobalKey<FormState>();  //key for the event form
  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController categoryController = TextEditingController();


  //function used to select the date using the showDatePicker 
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) { //if the user selected a date, update the selected date and refresh the page
      selectedDate = picked;
      refresh();
    }
  }

  Widget CategorySelection(int userId) {
    return FutureBuilder<List<Category>>( 
      future :categoryService.getCategoriesByUserId(userId),  //get the categories of the user
      builder: (context, snapshot){

        if(snapshot.hasData) {                                //when the future is resolved
          List<Category> categories = snapshot.data ?? [];
          return Column(                                    //in a collumn, display the list of categories and the form to create a new one
            children: [
              Expanded(
                flex: 3,
                child: 
                ListView.separated(                       //list of categories, separated by a divider
                  itemBuilder:(context, index) {
                    return ListTile(
                      title: Text(categories[index].name),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addEvent', arguments: {'userId':userId,'category':categories[index]});  //when the user tap on a category, go to the addEvent page for this specific category
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(      //divider between categories
                    color: Colors.black,
                  ),
                  itemCount: categories.length)
              ),
                Expanded(
                  flex:1,
                  child: newCategoryWidget(userId, context),                //Widget containing a form to create a new category
                )
                ],
          );
        }
        if(snapshot.hasError) {                                             //if the future returns an error
          return Column(                                                  //display a message and the form to create a new category
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(flex:4,child:  Align(alignment: Alignment.center, child: Text("No event categories Yet, create the first one!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),  //Message saying that there is no category yet
              Expanded(flex:1,child: Align(alignment: Alignment.bottomCenter, child: newCategoryWidget( userId, context))),   //Widget containing a form to create a new category
            ],
          );
        }
        return const CircularProgressIndicator();
      }
    );
  }

  //Widget containing a form to create a new category
  Widget newCategoryWidget(int userId, BuildContext context){
    return  Form(
      key:_formKeyCategory,
      child: Row(
        children: [
          Expanded(
            flex:3,
            child: TextFormField(                                                               //TextField for the name of the new category
              controller: categoryController,
              decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "New category"),
              validator: (value){
                if(value == null || value.isEmpty){                                             //if the user didn't enter a name, return an error message
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(                                                             //Button to submit the new category
                onPressed: () {
                  if (_formKeyCategory.currentState!.validate()) {                           //if the form is valid
                    categoryService.addCategory(userId, categoryController.text).then((value) => Navigator.of(context).pushNamed('/addEvent', arguments: {'userId':userId,'category':value}));   //add the category and go to the addEvent page for this specific category
                  }
                },
                child: const Icon(Icons.add, semanticLabel: "add icon",),
              ),
          ),
        
        ],
      )
    );
  }

  //Widget containing the button to select the date and the list of events for this date
  Widget EventWidget(int userId, {required bool friendMode}){
    return Column(                                            //in a column
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(                                                                   //display the date selected by the user
                    "Events of : "+"${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  // const SizedBox(height: 20.0,),
                  ElevatedButton(                                                        //button to select the date
                    onPressed: () => _selectDate(context),
                    child: const Text('Select date'),
                  ),
                ],
              ),
        ),
        Expanded(
          flex: 4,
          child: EventList(date: selectedDate, userId: userId,notifyParent: () {},friendMode: friendMode,), //Widget displaying the list of events for the selected date
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            
            child: ElevatedButton(                                                      //button to add an event
                    onPressed: () => navigatorKey.currentState!.pushNamed('/categorySelection', arguments: userId).then((value){  //go to the categorySelection page and refresh the page when the navigator pops to this page
                      refresh();
                      }),
                    child: const Text('Add an event')
                  ),
          ),
        )
      ],
    );
  }

  //Widget containing a list of all event templates of a category and a form to create a new event
  Widget AddEventPage(Map<String, dynamic> args){
    Category category = args['category'];
    int userId = args['userId'];
    return FutureBuilder(
      future: eventTemplateService.getEventTemplatesByCategoryId(userId, category.idcategory),  //get the event templates of the category
      builder: (context, snapshot){
        if(snapshot.hasData) {
          List<EventTemplate> eventTemplates = snapshot.data ?? [];
          return Column(  
            children: [
              Expanded(flex:1,child: newEventWidget(context,userId, category)),                                           //Widget containing a form to create a new event
              Text("Templates of : ${category.name}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //Title of the list of event templates
              const Divider(                                                                                           //divider
                color: Colors.black,
              ),
              Expanded(
                flex: 4,
                child: 
                ListView.separated(                                                                                  //list of event templates separated by a divider
                  itemBuilder: (context, index) {
                    return EventTemplateWidget(template: eventTemplates[index]);                                   //Widget displaying an event template
                  },
                  separatorBuilder: (context, index) => const Divider(                                            //divider between event templates
                    color: Colors.black,
                  ),
                  itemCount: eventTemplates.length)
              ),
            ],
          );
        }
        if(snapshot.hasError) {                                                                                    //if the future returns an error just display the form to create a new event
          return newEventWidget(context,userId, category);                                                 
        }
        return const CircularProgressIndicator();                                                               //if the future is not completed yet, display a circular progress indicator
      }
      );
  }


  //Widget containing a form to create a new event
  Widget newEventWidget(context,int userId, Category category){
    return  Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text("New event", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),    //title of the form
        ),
        Form(                                                                                        //form to create a new event
            key:_formKeyEvent,
            child: Row(
              children: [
                Expanded(
                  flex:4,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(                                                              //TextField for the name of the new event
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Event"),
                      validator: (value){
                        if(value == null || value.isEmpty){                                           //Only checks if the user entered a name
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
                    child: TextFormField(                                                             //TextField for the weight of the new event
                      controller: weightController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Weight"), 
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),                       //Only allows the user to enter a positive or negative number
                      ],
                      validator: (value) {                                                        //Checks if the user entered a weight
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
                  child: ElevatedButton(                                                        //button to add the new event
                    onPressed: () {
                      if (_formKeyEvent.currentState!.validate()) {
                        final newTemplate = EventTemplate(ideventTemplate: 0, name: titleController.text, iduser: userId, proposedWeight: int.parse(weightController.text), idcategory: category.idcategory); //create the new event template
                        eventTemplateService.addEventTemplate(newTemplate).then((value){  //Send the new template to the api
                          eventService.addEvent(newTemplate).then((value){              //Create an event for the new template
                            Navigator.popUntil(context, (route){                        //Go back to the home page
                            return route.settings.name.toString()=='/';
                          });
                          });

                          
                        });
                      }
                    },
                    child: const Center(child: Icon(Icons.add, semanticLabel: "add icon",)),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }


}