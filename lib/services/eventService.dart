import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/EventModel.dart';
import '../constanst.dart';
import '../models/EventTemplateModel.dart';

class EventService {
  final String baseUrl = Constants.API_URL;

  Future<List<Event>> getTodayEventsByUserId(int iduser) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$iduser/events'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      throw Exception('Failed to get today\'s events');
    }
  }

  Future<List<Event>> getLastEventsByUserId(int iduser) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$iduser/lastevent'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      throw Exception('Failed to get last events');
    }
  }

  Future<Event> addEvent(EventTemplate event) async {
    final now = DateTime.now();
    final requestBody = {
      'Name': event.name,
      'iduser': event.iduser,
      'idcategory': event.idcategory,
      'Weight': event.proposedWeight,
      'Date': now.toIso8601String(),
    };

    final response = await http.post(Uri.parse('$baseUrl/user/${event.iduser}/events'), body: requestBody);

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add event');
    }
  }

  Future<List<Event>> getEventsByDate(int iduser, DateTime date) async {
    final formattedDate = date.toString().replaceAll('-', '');
    final response = await http.get(Uri.parse('$baseUrl/user/$iduser/events/$formattedDate'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      throw Exception('Failed to get events by date');
    }
  }
}
