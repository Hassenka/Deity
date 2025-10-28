import 'package:diety/data/models/recipe_model.dart';

class CategoryRecipesResponse {
  final List<Recipes> recipes;
  final Pagination pagination;

  CategoryRecipesResponse({required this.recipes, required this.pagination});

  factory CategoryRecipesResponse.fromJson(Map<String, dynamic> json) {
    var recipesList = json['recipes'] as List? ?? [];
    List<Recipes> recipes = recipesList
        .map((i) => Recipes.fromJson(i))
        .toList();

    return CategoryRecipesResponse(
      recipes: recipes,
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;
  final int limit;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }
}
