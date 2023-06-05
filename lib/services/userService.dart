import 'dart:convert';
import '../constanst.dart';
import '../httpServiceWrapper.dart';
import '../models/UserModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


///User service, contains all the methods to interact with the user part of the api
/// see https://github.com/olingo99/umadWeb/blob/main/umad.yml for the swagger documentation of the api
class UserService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();
  final storage = new FlutterSecureStorage();


Future<User> tryLogin(String name, String password) async {                                               // method to login

    final response = await httpServiceWrapper.post(
      '/login',
      {'Name': name, 'passWord': password},
    );

    if (response.statusCode == 200) {
      return storage.write(key: 'token', value: jsonDecode(response.body)['token']).then((value){       // if the login is succesfull, the token is stored in the secure storage
        return User.fromJson(jsonDecode(response.body));                                              // and the user is returned           
      });
    } else {
      throw Exception('Failed to login');
    }
  }



  Future<bool> checkUserName(String name) async {                                 // method to check if a username is already taken
    final response = await httpServiceWrapper.get('/user/name/$name');

    return response.statusCode == 200;                                          // returns true if the username is taken, false if not               
  }

  Future<User> addUser(String name, String password) async {                      // method to add a user
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

  Future<int> getMood(int id) async {                                            // method to get the mood of a user by its id
    final response = await httpServiceWrapper.get('/user/$id/mood');        

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get mood');
    }
  }

  Future<User> getUserById(int id) async {                                      // method to get a user by its id
    final response = await httpServiceWrapper.get('/user/$id');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<List<String>> getAllUserNames(String search) async{                   // method to get all the usernames "like" the search string
    final response = await httpServiceWrapper.post('/userNames', {'search': search});
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => userJson["Name"] as String).toList();
    } else {
      throw Exception('Failed to get user');
    }
  }
}
