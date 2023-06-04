import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import '../models/EventTemplateModel.dart';
import 'package:flutter/services.dart';
import '../services/eventTemplateService.dart';
import '../services/eventService.dart';

class EventTemplateWidget extends StatelessWidget {
  final EventTemplate template;
  TextEditingController _controller = TextEditingController();
  final EventTemplateService eventTemplateService = EventTemplateService();
  final EventService eventService = EventService();
  final _formKey = GlobalKey<FormState>();

  EventTemplateWidget({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    _controller.text = template.proposedWeight.toString();
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex:4,child: Text(template.name, style: TextStyle(fontSize: 20))),
          Expanded(
            flex:1,
            child: TextFormField(
            controller: _controller,
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
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    // template.proposedWeight = int.parse(_controller.text);
                    template.proposedWeight = int.parse(_controller.text);
                    eventService.addEvent(template);
                    // Navigator.pop(context, template);
                    Navigator.popUntil(context, (route){
            
                      return route.settings.name.toString()=='/';
                    });
                  }
                },
                child: const Center(child: Icon(Icons.add)),
              ),
            ),
            Expanded(
            flex:2,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    template.proposedWeight = int.parse(_controller.text);
                    eventTemplateService.updateEventTemplate(template);
                  }
                },
                child: const Text("Adjust"),
              ),
            )
            )
        ],
      ),

      );
  }
}