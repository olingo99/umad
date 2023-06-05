import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umad/httpServiceWrapper.dart';
import '../models/EventModel.dart';
import '../constanst.dart';
import '../models/EventTemplateModel.dart';

/// Event service, contains all the methods to interact with the event part of the api
///see https://github.com/olingo99/umadWeb/blob/main/umad.yml for the swagger documentation of the api
class EventService {
  final String baseUrl = Constants.API_URL;
  HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();

  @Deprecated('Use [getEventsByDate]')
  Future<List<Event>> getTodayEventsByUserId(int iduser) async {                  //method to get today's events of a user by its id
    final response = await httpServiceWrapper.get('/user/$iduser/events');        //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {                         
      final List<dynamic> jsonData = jsonDecode(response.body);                    //decode the response body            
      return jsonData.map((eventJson) => Event.fromJson(eventJson)).toList();       //convert the json to a list of events
    } else {
      throw Exception('Failed to get today\'s events');
    }
  }

  Future<List<Event>> getLastEventsByUserId(int iduser) async {                     //method to get the last events of a user by its id
    final response = await httpServiceWrapper.get('/user/$iduser/lastevent');        //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);                       //decode the response body
      return jsonData.map((eventJson) => Event.fromJson(eventJson)).toList();           //convert the json to a list of events
    } else {
      throw Exception('Failed to get last events');
    }
  }

  Future<Event> addEvent(EventTemplate event) async {                               //method to add an event
    final now = DateTime.now();                                                    //get the current date               
    final requestBody = {                                                         //create the request body
      'Name': event.name,
      'iduser': event.iduser,
      'idcategory': event.idcategory,
      'Weight': event.proposedWeight,
      'Date': now.toIso8601String(),
    };

    final response = await httpServiceWrapper.post('/user/${event.iduser}/events', requestBody);  //make a post request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add event');
    }
  }

  Future<List<Event>> getEventsByDate(int iduser, DateTime date) async {                  //method to get the events of a user for a specific date
    final formattedDate = date.toString().split(' ')[0].replaceAll('-', '');              //format the date to the format used in the api
    final response = await httpServiceWrapper.get('/user/$iduser/events/$formattedDate'); //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);                          //decode the response body
      return jsonData.map((eventJson){                                                  //convert the json to a list of events
        return Event.fromJson(eventJson);
        }).toList();
    } else {
      throw Exception('Failed to get events by date');
    }
  }

  Future<bool> deleteEvent(Event event) async {                                             //method to delete an event
    final response = await httpServiceWrapper.delete('/user/${event.iduser}/event/${event.idevent}');   //make a delete request to the api trough the http service wrapper

    return response.statusCode == 200;
  }
}
