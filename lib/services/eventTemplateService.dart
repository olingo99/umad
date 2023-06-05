import 'dart:convert';
import 'package:umad/httpServiceWrapper.dart';
import '../models/EventTemplateModel.dart';
import '../constanst.dart';



/// Template service, contains all the methods to interact with the template part of the api
/// see https://github.com/olingo99/umadWeb/blob/main/umad.yml for the swagger documentation of the api
class EventTemplateService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();

  Future<List<EventTemplate>> getEventTemplatesByUserId(int iduser) async {                      //method to get all the templates of a user by its id
    final response = await httpServiceWrapper.get('/user/$iduser/templates');             //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body); 
      return jsonData.map((eventTemplateJson) => EventTemplate.fromJson(eventTemplateJson)).toList();
    } else {
      throw Exception('Failed to get event templates');
    }
  }

  Future<EventTemplate> addEventTemplate(EventTemplate eventTemplate) async {               //method to add a template
    final requestBody = {                                                                  //create the request body
      'Name': eventTemplate.name,
      'iduser': eventTemplate.iduser,
      'idcategory': eventTemplate.idcategory,
      'ProposedWeight': eventTemplate.proposedWeight,
    };

    final response = await httpServiceWrapper.post('/user/${eventTemplate.iduser}/templates', requestBody);

    if (response.statusCode == 200) {
      return EventTemplate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add event template');
    }
  }

  Future<EventTemplate> updateEventTemplate(EventTemplate eventTemplate) async {             //method to update a template
    final requestBody = {
      'Name': eventTemplate.name,
      'iduser': eventTemplate.iduser,
      'idcategory': eventTemplate.idcategory,
      'ProposedWeight': eventTemplate.proposedWeight,
    };

    final response = await httpServiceWrapper.put('/user/${eventTemplate.iduser}/templates/${eventTemplate.ideventTemplate}', requestBody);       //make a put request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      return EventTemplate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update event template');
    }
  }

  Future<List<EventTemplate>> getEventTemplatesByCategoryId(int iduser, int idcategory) async {                                                   //method to get all the templates of a category by its id
    final response = await httpServiceWrapper.get('/user/$iduser/templates/category/$idcategory');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventTemplateJson) => EventTemplate.fromJson(eventTemplateJson)).toList();
    } else {
      throw Exception('Failed to get event templates');
    }
  }
}
