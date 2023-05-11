import 'dart:html';

import 'package:http/http.dart' as http;
import 'constanst.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpServiceWrapper {
  static const String baseUrl = Constants.API_URL;
  Map<String, String> defaultHeaders = {
    'Authorization':''
  };
  final storage = new FlutterSecureStorage();

  Future<http.Response> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    // final headers = _mergeHeaders(defaultHeaders, {});
    storage.read(key: 'token').then((value) => defaultHeaders['Authorization'] = value!);
    return await http.get(url, headers: defaultHeaders);
  }

  Future<http.Response> post(String path, Map<String,String> body) async{
    final url = Uri.parse('$baseUrl$path');
    storage.read(key: 'token').then((value) => defaultHeaders['Authorization'] = value!);
    return await http.post(url, headers: defaultHeaders, body: body);
  }


  // void test(){
  //   storage.read(key: 'token').then((value) => defaultHeaders['Authorization'] = value!);
  // }

  // static Map<String, String> _mergeHeaders(
  //   Map<String, String> defaultHeaders, Map<String, String> headers) {
  //   final mergedHeaders = Map<String, String>.from(defaultHeaders);
  //   mergedHeaders.addAll(headers);
  //   return mergedHeaders;
  // }
}
