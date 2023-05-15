import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umad/httpServiceWrapper.dart';
import '../constanst.dart';
import '../models/UserModel.dart';
import '../models/FriendsModel.dart';

class FriendsService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();
  Future<List<User>> getFriends(int id) async {
    final response = await httpServiceWrapper.get('/user/$id/friends');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friends');
    }
  }

  Future<FriendsMap> addFriend(int idUser, String name) async {
    final response = await httpServiceWrapper.post(
      '/user/$idUser/friends',
      {'username': name},
    );

    if (response.statusCode == 200) {
      return FriendsMap.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add friend');
    }
  }

  Future<User> acceptFriendRequest(int idUser, int idFriend) async {
    final response = await httpServiceWrapper.post(
      '/user/$idUser/acceptFriend',
      {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<User> declineFriendRequest(int idUser, int idFriend) async {
    final response = await httpServiceWrapper.post(
      '/user/$idUser/declineFriend',
      {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to decline friend request');
    }
  }

  Future<List<User>> getFriendRequests(int id) async {
    final response = await httpServiceWrapper.get('/user/$id/friendRequests');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friend requests');
    }
  }
}
