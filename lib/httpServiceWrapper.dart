import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constanst.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// Wrapper for the http service, adds the token and the content-type to the header of the request
class HttpServiceWrapper {
  static const String baseUrl = Constants.API_URL;  //Get the url of the API from the constants file
  static const Map<String, String> contentTypeHeader = {  //Create the headers for the request, contains the content-type
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final storage = new FlutterSecureStorage();


  //wrapper for the http get request
  Future<http.Response> get(String path) async {
    final url = Uri.parse('$baseUrl$path');                       //create the url of the request
    Map<String, String>headers = {};                              //create the headers of the request
    return storage.read(key: 'token').then((value)async {         //get the token from the storage
      headers['Authorization'] = value??'';                       //add the token to the headers, uses an empty string if the token is null
      return await http.get(url, headers: headers);               //returns the future of the request
  });
  }

  //wrapper for the http post request
  Future<http.Response> post(String path, Map<String,dynamic> body) async{
    final url = Uri.parse('$baseUrl$path');                       //create the url of the request
    Map<String, String>headers = {};                              //create the headers of the request
    return storage.read(key: 'token').then((value)async {         //get the token from the storage
      headers['Authorization'] = value??'';                       //add the token to the headers, uses an empty string if the token is null
      headers.addAll(contentTypeHeader);                          //add the content-type to the headers             
      return await http.post(url, headers: headers, body: jsonEncode(body));  //returns the future of the request
  });
  }

  //wrapper for the http put request
  Future<http.Response> put(String path, Map<String, dynamic> body) async { 
    final url = Uri.parse('$baseUrl$path');                   //create the url of the request                  
    Map<String, String>headers = {};                          //create the headers of the request                
    return storage.read(key: 'token').then((value)async {     //get the token from the storage                  
      headers['Authorization'] = value??'';                   //add the token to the headers, uses an empty string if the token is null                  
      headers.addAll(contentTypeHeader);                      //add the content-type to the headers
      return await http.put(url, headers: headers, body: jsonEncode(body)); //returns the future of the request
  });
  }

  //wrapper for the http delete request
  Future<http.Response> delete(String path) async {           
    final url = Uri.parse('$baseUrl$path');                   //create the url of the request
    Map<String, String>headers = {};                        //create the headers of the request
    return storage.read(key: 'token').then((value)async {   //get the token from the storage
      headers['Authorization'] = value??'';                //add the token to the headers, uses an empty string if the token is null    
      headers.addAll(contentTypeHeader);                 //add the content-type to the headers
      return await http.delete(url, headers: headers);  //returns the future of the request
  });
  }

}
