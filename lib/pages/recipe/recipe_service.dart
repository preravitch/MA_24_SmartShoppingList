import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class RecipeService {
  final String apiKey = '1b408c235450460a81bca9ee05e43aa7';

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$query&addRecipeInformation=true'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Recipe> recipes = [];

      if (data['results'] != null) {
        data['results'].forEach((recipe) {
          recipes.add(Recipe.fromJson(recipe));
        });
      }

      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
