import 'dart:convert';
import '../constanst.dart';
import '../models/CategoryModel.dart';
import '../httpServiceWrapper.dart';

class CategoryService {
  final String baseUrl = Constants.API_URL;
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();
  Future<Category> getCategoryById(int userId, int catId) async {
    final response = await httpServiceWrapper.get('/user/$userId/category/$catId');

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get category');
    }
  }

  Future<List<Category>> getCategoriesByUserId(int userId) async {
    final response = await httpServiceWrapper.get('/user/$userId/category');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    } else {
      throw Exception('Failed to get categories');
    }
  }

  Future<Category> addCategory(int iduser, String name) async {
    final requestBody = {
      'iduser': iduser,
      'Name': name,
    };

    final response = await httpServiceWrapper.post('/user/$iduser/category', requestBody);

    if (response.statusCode == 200) {
      print("category decpde");
      print(response.body);
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add category');
    }
  }
}
