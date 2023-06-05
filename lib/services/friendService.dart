import 'dart:convert';

import 'package:umad/httpServiceWrapper.dart';
import '../constanst.dart';
import '../models/UserModel.dart';
import '../models/FriendsModel.dart';


/// Friend service, contains all the methods to interact with the friend part of the api
/// see https://github.com/olingo99/umadWeb/blob/main/umad.yml for the swagger documentation of the api
class FriendsService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();



  Future<List<User>> getFriends(int id) async {                                     // method to get all the friends of a user by its id
    final response = await httpServiceWrapper.get('/user/$id/friends');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friends');
    }
  }

  Future<bool> addFriend(int idUser, String name) async {                           // method to add a friend by name         
    final response = await httpServiceWrapper.post(
      '/user/$idUser/friends',
      {'username': name},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add friend');
    }
  }

  Future<FriendsMap> acceptFriendRequest(int idUser, int idFriend) async {        // method to accept a friend request          
    final response = await httpServiceWrapper.post(
      '/user/$idUser/acceptFriend',
      {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      print('acceptFriendRequest');
      print(response.body);
      return FriendsMap.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<FriendsMap> declineFriendRequest(int idUser, int idFriend) async {      // method to decline a friend request
    final response = await httpServiceWrapper.post( 
      '/user/$idUser/declineFriend',
      {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      return FriendsMap.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to decline friend request');
    }
  }

  Future<List<User>> getFriendRequests(int id) async {                         // method to get all the friend requests of a user by its id
    final response = await httpServiceWrapper.get('/user/$id/friendRequests');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friend requests');
    }
  }
}
