import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Import logger
import 'package:diety/data/repositories/api_service.dart';

// Initialize a logger instance for this file
final _logger = Logger();

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  final ApiService _apiService = ApiService();
  final Set<int> _favoriteRecipeIds = HashSet<int>();

  // A listener to notify widgets when favorites change.
  final ValueNotifier<Set<int>> _favoritesNotifier = ValueNotifier<Set<int>>(
    HashSet<int>(),
  );

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
        _favoritesNotifier.value = HashSet<int>.from(_favoriteRecipeIds);
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
    _favoritesNotifier.value = HashSet<int>.from(_favoriteRecipeIds);

    // Show immediate feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowFavorite ? 'تم حفظ الوصفة' : 'تم حذف الوصفة',
            textAlign: TextAlign.center,
          ),
          backgroundColor: isNowFavorite ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
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
      _favoritesNotifier.value = HashSet<int>.from(_favoriteRecipeIds);
      _logger.e('Failed to toggle favorite on server: $e');
    }
  }

  // Allow widgets to listen for changes
  void addListener(VoidCallback listener) {
    _favoritesNotifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _favoritesNotifier.removeListener(listener);
  }
}
