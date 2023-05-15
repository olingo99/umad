import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umad/httpServiceWrapper.dart';
import '../models/EventTemplateModel.dart';
import '../constanst.dart';

class EventTemplateService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();

  Future<List<EventTemplate>> getEventTemplatesByUserId(int iduser) async {
    final response = await httpServiceWrapper.get('/user/$iduser/templates');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventTemplateJson) => EventTemplate.fromJson(eventTemplateJson)).toList();
    } else {
      throw Exception('Failed to get event templates');
    }
  }

  Future<EventTemplate> addEventTemplate(EventTemplate eventTemplate) async {
    final requestBody = {
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

  Future<EventTemplate> updateEventTemplate(EventTemplate eventTemplate) async {
    final requestBody = {
      'Name': eventTemplate.name,
      'iduser': eventTemplate.iduser,
      'idcategory': eventTemplate.idcategory,
      'ProposedWeight': eventTemplate.proposedWeight,
    };

    final response = await httpServiceWrapper.put('/user/${eventTemplate.iduser}/templates/${eventTemplate.ideventTemplate}', requestBody);

    if (response.statusCode == 200) {
      return EventTemplate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update event template');
    }
  }

  Future<List<EventTemplate>> getEventTemplatesByCategoryId(int iduser, int idcategory) async {
    final response = await httpServiceWrapper.get('/user/$iduser/templates/category/$idcategory');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventTemplateJson) => EventTemplate.fromJson(eventTemplateJson)).toList();
    } else {
      throw Exception('Failed to get event templates');
    }
  }
}
