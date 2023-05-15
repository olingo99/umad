// import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constanst.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpServiceWrapper {
  static const String baseUrl = Constants.API_URL;
  static const Map<String, String> contentTypeHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final storage = new FlutterSecureStorage();
  // static const noAuthUrl =  [
  //   {'url': '/login', 'method': 'POST'},
  //   {'url': '/user/name/', 'method': 'GET'},
  //   {'url': '/user', 'method': 'POST'},
  // ];


  // Future<http.Response> get(String path) async {
  //   final url = Uri.parse('$baseUrl$path');
  //   Map<String, String>headers = {};
  //   print(headers);
  //   storage.read(key: 'token').then((value) => headers['Authorization'] = value??'');
  //   print(headers);
  //   return await http.get(url, headers: headers);
  // }


  Future<http.Response> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    Map<String, String>headers = {};
    print(headers);
    return storage.read(key: 'token').then((value)async {
      headers['Authorization'] = value??'';
      print("hhhhhhhhhhhhere");
      print(value??'');
      print(headers);
      return await http.get(url, headers: headers);
  });
  }

  Future<http.Response> post(String path, Map<String,dynamic> body) async{
    final url = Uri.parse('$baseUrl$path');
    Map<String, String>headers = {};
    print(headers);
    return storage.read(key: 'token').then((value)async {
      headers['Authorization'] = value??'';
      headers.addAll(contentTypeHeader);
      print("hhhhhhhhhhhhere");
      print(value??'');
      print(headers);
      return await http.post(url, headers: headers, body: jsonEncode(body));
  });
  }

  // Future<http.Response> post(String path, Map<String,dynamic> body) async{
  //   final url = Uri.parse('$baseUrl$path');
  //   Map<String, String>headers = {};
  //   storage.read(key: 'token').then((value) => headers['Authorization'] = value??'');
  //   headers.addAll(contentTypeHeader);
  //   return await http.post(url, headers:headers, body: jsonEncode(body));
  // }
}
