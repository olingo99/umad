import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constanst.dart';
import '../models/CategoryModel.dart';

class CategoryService {
  final String baseUrl = Constants.API_URL;

  Future<Category> getCategoryById(int userId, int catId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/category/$catId'));

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get category');
    }
  }

  Future<List<Category>> getCategoriesByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/category'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    } else {
      throw Exception('Failed to get categories');
    }
  }

  Future<Category> addCategory(Category category) async {
    final requestBody = {
      'iduser': category.iduser,
      'Name': category.name,
    };

    final response = await http.post(Uri.parse('$baseUrl/user/${category.iduser}/category'), body: requestBody);

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add category');
    }
  }
}
