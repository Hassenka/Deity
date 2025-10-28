import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ApiService _apiService = ApiService();
  final _logger = Logger();

  FavoritesBloc() : super(FavoritesInitial()) {
    on<FetchFavorites>((event, emit) async {
      emit(FavoritesLoadInProgress());
      try {
        final recipes = await _apiService.getMySaves();
        final favoriteIds =
            recipes.recipes?.map((r) => r.id!).toSet() ?? <int>{};
        emit(FavoritesLoadSuccess([recipes], favoriteIds));
      } catch (e) {
        emit(
          FavoritesLoadFailure(e.toString().replaceFirst('Exception: ', '')),
        );
      }
    });

    on<ToggleFavorite>((event, emit) async {
      if (state is! FavoritesLoadSuccess) return;

      final currentState = state as FavoritesLoadSuccess;
      final currentIds = Set<int>.from(currentState.favoriteIds);
      final isCurrentlyFavorite = currentIds.contains(event.recipeId);

      // Optimistic UI update
      if (isCurrentlyFavorite) {
        currentIds.remove(event.recipeId);
      } else {
        currentIds.add(event.recipeId);
      }
      emit(FavoritesLoadSuccess(currentState.recipes, currentIds));

      // Show feedback
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(
              !isCurrentlyFavorite ? 'تم حفظ الوصفة' : 'تم حذف الوصفة',
              textAlign: TextAlign.center,
            ),
            backgroundColor: !isCurrentlyFavorite ? Colors.green : Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // API call
      try {
        await _apiService.saveRecipe(event.recipeId);
        // Optional: Re-fetch to ensure data consistency after the API call.
        // add(FetchFavorites());
      } catch (e) {
        _logger.e('Failed to toggle favorite on server: $e');
        // On failure, revert the state by re-fetching from the server.
        add(FetchFavorites());
      }
    });
  }
}
