import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Import logger
import 'package:diety/presentation/widgets/gradient_snackbar.dart';
import 'package:diety/data/repositories/api_service.dart';

// Initialize a logger instance for this file
final _logger = Logger();

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  final ApiService _apiService = ApiService();
  final Set<int> _favoriteRecipeIds = HashSet<int>();

  bool isFavorite(int recipeId) {
    return _favoriteRecipeIds.contains(recipeId);
  }

  Future<void> fetchFavorites() async {
    try {
      final recipe = await _apiService.getMySaves();
      _favoriteRecipeIds.clear();
      if (recipe.recipes != null) {
        for (var r in recipe.recipes!) {
          if (r.id != null) {
            _favoriteRecipeIds.add(r.id!);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      _logger.e('Error fetching favorites: $e');
    }
  }

  Future<void> toggleFavorite(
    int recipeId, {
    required BuildContext context,
  }) async {
    final isNowFavorite = !isFavorite(recipeId);

    // Optimistic UI update
    if (isNowFavorite) {
      _favoriteRecipeIds.add(recipeId);
    } else {
      _favoriteRecipeIds.remove(recipeId);
    }
    notifyListeners();

    // Show immediate feedback
        if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          elevation: 0,
          content: GradientSnackBarContent(
            message: isNowFavorite ? 'تم حفظ الوصفة' : 'تم حذف الوصفة',
            icon: isNowFavorite
                ? Icons.check_circle_outline
                : Icons.remove_circle_outline,
            iconColor: isNowFavorite ? Colors.green : Colors.red,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // API call
    try {
      await _apiService.saveRecipe(recipeId);
    } catch (e) {
      // If API call fails, revert the change and notify listeners
      isNowFavorite
          ? _favoriteRecipeIds.remove(recipeId)
          : _favoriteRecipeIds.add(recipeId);
      notifyListeners();
      _logger.e('Failed to toggle favorite on server: $e');
    }
  }
}
