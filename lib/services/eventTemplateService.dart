import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/EventTemplateModel.dart';
import '../constanst.dart';

class EventTemplateService {
  final String baseUrl = Constants.API_URL;

  Future<List<EventTemplate>> getEventTemplatesByUserId(int iduser) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$iduser/templates'));

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

    final response = await http.post(Uri.parse('$baseUrl/user/${eventTemplate.iduser}/templates'), body: requestBody);

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

    final response = await http.put(Uri.parse('$baseUrl/user/${eventTemplate.iduser}/templates/${eventTemplate.ideventTemplate}'), body: requestBody);

    if (response.statusCode == 200) {
      return EventTemplate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update event template');
    }
  }
}
