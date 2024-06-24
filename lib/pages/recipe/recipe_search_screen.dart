import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';
import 'recipe_service.dart';
import 'recipe_model.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({Key? key}) : super(key: key);

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  void _searchRecipes(String query) async {
    setState(() {
      _isLoading = true;
    });

    RecipeService recipeService = RecipeService();
    try {
      List<Recipe> recipes = await recipeService.searchRecipes(query);
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching recipes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Search'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Search Recipes',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchRecipes(_controller.text);
                    },
                  ),
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = _recipes[index];
                      return ListTile(
                        title: Text(recipe.title),
                        subtitle: Text('Ready in ${recipe.readyInMinutes} minutes'),
                        leading: Image.network(recipe.imageUrl),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipe: recipe,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
