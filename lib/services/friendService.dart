import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constanst.dart';
import '../models/UserModel.dart';
import '../models/FriendsModel.dart';

class FriendsService {
  final String baseUrl = Constants.API_URL;

  Future<List<User>> getFriends(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$id/friends'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friends');
    }
  }

  Future<FriendsMap> addFriend(int idUser, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/$idUser/friends'),
      body: {'username': name},
    );

    if (response.statusCode == 200) {
      return FriendsMap.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add friend');
    }
  }

  Future<User> acceptFriendRequest(int idUser, int idFriend) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/$idUser/acceptFriend'),
      body: {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<User> declineFriendRequest(int idUser, int idFriend) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/$idUser/declineFriend'),
      body: {'idfriend': idFriend.toString()},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to decline friend request');
    }
  }

  Future<List<User>> getFriendRequests(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$id/friendRequests'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to get friend requests');
    }
  }
}
