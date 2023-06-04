import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constanst.dart';
import '../httpServiceWrapper.dart';
import '../models/UserModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();
  final storage = new FlutterSecureStorage();


Future<User> tryLogin(String name, String password) async {

    print(name);
    print(password);
    final response = await httpServiceWrapper.post(
      '/login',
      {'Name': name, 'passWord': password},
    );

    if (response.statusCode == 200) {
      print(response.body);
      storage.read(key: 'token').then((value) => print(value??''));
      return storage.write(key: 'token', value: jsonDecode(response.body)['token']).then((value){
      return User.fromJson(jsonDecode(response.body));

      });
      // storage.read(key: 'token').then((value) => print(value??''));
    } else {
      print("Failed to login");
      throw Exception('Failed to login');
    }
  }



  Future<bool> checkUserName(String name) async {
    // final response = await http.get(Uri.parse('$baseUrl/user/name/$name'));
    final response = await httpServiceWrapper.get('/user/name/$name');

    return response.statusCode == 200;
  }

  Future<User> addUser(String name, String password) async {
    final response = await httpServiceWrapper.post(
      '/user',
      {'Name': name, 'passWord': password},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<int> getMood(int id) async {
    final response = await httpServiceWrapper.get('/user/$id/mood');

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get mood');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await httpServiceWrapper.get('/user/$id');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<List<String>> getAllUserNames(String search) async{
    final response = await httpServiceWrapper.post('/userNames', {'search': search});
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => userJson["Name"] as String).toList();
    } else {
      throw Exception('Failed to get user');
    }
  }
}
