import 'package:flutter/material.dart';
import '../models/EventTemplateModel.dart';
import 'package:flutter/services.dart';
import '../services/eventTemplateService.dart';
import '../services/eventService.dart';


//event template widget
//contains the name of the template and a text field to modify the proposed weight as well as a button to add the event and to confirm the weight
class EventTemplateWidget extends StatelessWidget {
  final EventTemplate template;
  final TextEditingController _controller = TextEditingController();
  final EventTemplateService eventTemplateService = EventTemplateService();
  final EventService eventService = EventService();
  final _formKey = GlobalKey<FormState>();

  EventTemplateWidget({super.key, required this.template});

  //Text field to modify the proposed weight
  Widget _weightField(){
    return TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number, //only allow numbers
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')), //allow only text that satisfies the regex, positive or negative numbers
          ],
        validator: (value) {
          if(value == null || value.isEmpty) {
            return "Please enter a weight";
          }
          return null;
        },
        );
  }

  //Button to add the event
  Widget _addEventButton(context){
    return ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()) { //check if the weight is valid
          template.proposedWeight = int.parse(_controller.text);  //update the weight of the template
          eventService.addEvent(template);                      //sned the event to the api
          Navigator.popUntil(context, (route){                //go back to the home page
            return route.settings.name.toString()=='/';
          });
        }
      },
      child: const Center(child: Icon(Icons.add, semanticLabel: "Add icon",)),
    );
  }

  //Button to adjust the weight of the template
  Widget _adjustWeightButton(){
    return ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()) { //check if the weight is valid
          template.proposedWeight = int.parse(_controller.text);  //update the weight of the template
          eventTemplateService.updateEventTemplate(template);     //send the updated template to the api
        }
      },
      child: const Text("Adjust"),
    );
  }


  //build the EventTemplateWidget, contains all the positionning of the elements
  @override
  Widget build(BuildContext context) {
    _controller.text = template.proposedWeight.toString();
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex:4,child: Text(template.name, style:const TextStyle(fontSize: 20))),       //name of the template
          Expanded(
            flex:1,
            child: _weightField(),                                                            //text field to modify the weight
          ),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: _addEventButton(context),                                              //button to add the event
          ),
          Expanded(
          flex:2,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: _adjustWeightButton(),                                                  //button to adjust the weight
          )
          )
        ],
      ),
      );
  }
}