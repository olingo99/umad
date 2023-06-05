import 'dart:convert';
import '../constanst.dart';
import '../models/CategoryModel.dart';
import '../httpServiceWrapper.dart';


/// Category service, contains all the methods to interact with the category part of the api
/// see https://github.com/olingo99/umadWeb/blob/main/umad.yml for the swagger documentation of the api
class CategoryService {
  final String baseUrl = Constants.API_URL;                                             //base url of the api                 
  final HttpServiceWrapper httpServiceWrapper = HttpServiceWrapper();                  //http service wrapper to make http requests, responsible for adding the token to the header
  
  
  
  Future<Category> getCategoryById(int userId, int catId) async {                       //method to get a category by its id
    final response = await httpServiceWrapper.get('/user/$userId/category/$catId');     //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {                                                  //if the response is ok
      return Category.fromJson(jsonDecode(response.body));                            //return the category
    } else {                                                                          //if the response is not ok
      throw Exception('Failed to get category');                                      //throw an exception                      
    }
  }

  Future<List<Category>> getCategoriesByUserId(int userId) async {                   //method to get all the categories of a user by its id
    final response = await httpServiceWrapper.get('/user/$userId/category');          //make a get request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    } else {
      throw Exception('Failed to get categories');
    }
  }

  Future<Category> addCategory(int iduser, String name) async {                     //method to add a category
    final requestBody = {                                                           //create the request body
      'iduser': iduser,
      'Name': name,
    };

    final response = await httpServiceWrapper.post('/user/$iduser/category', requestBody);  //make a post request to the api trough the http service wrapper

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add category');
    }
  }
}
