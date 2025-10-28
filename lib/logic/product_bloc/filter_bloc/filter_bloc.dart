import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final ApiService _apiService = ApiService();
  final int _limit = 9; // Number of items to fetch per page

  // To store the last used filters for pagination
  Map<String, dynamic> _lastFilters = {};

  FilterBloc() : super(FilterInitial()) {
    on<ApplyFilters>((event, emit) async {
      emit(FilterLoadInProgress());
      try {
        _lastFilters = {
          'meals': event.meals.toList(),
          'ingredients': event.ingredients.toList(),
          'methods': event.methods.toList(),
          'diets': event.diets.toList(),
          'kcalMin': event.kcalMin,
          'kcalMax': event.kcalMax,
        };

        final results = await _apiService.filterRecipes(
          meals: _lastFilters['meals'],
          ingredients: _lastFilters['ingredients'],
          methods: _lastFilters['methods'],
          diets: _lastFilters['diets'],
          kcalMin: _lastFilters['kcalMin'],
          kcalMax: _lastFilters['kcalMax'],
          page: 1, // Start from the beginning
          limit: _limit,
        );
        emit(
          FilterLoadSuccess(
            recipes: results.recipes,
            currentPage: results.pagination.currentPage,
            totalPages: results.pagination.totalPages,
            totalItems: results.pagination.totalItems,
          ),
        );
      } catch (e) {
        emit(FilterLoadFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<LoadMoreFilterResults>((event, emit) async {
      if (state is FilterLoadSuccess) {
        final currentState = state as FilterLoadSuccess;
        if (currentState.hasReachedMax || currentState.isLoadingMore) return;

        emit(currentState.copyWith(isLoadingMore: true));

        try {
          final results = await _apiService.filterRecipes(
            meals: _lastFilters['meals'],
            ingredients: _lastFilters['ingredients'],
            methods: _lastFilters['methods'],
            diets: _lastFilters['diets'],
            kcalMin: _lastFilters['kcalMin'],
            kcalMax: _lastFilters['kcalMax'],
            page: currentState.currentPage + 1, // Request the next page
            limit: _limit,
          );
          emit(
            currentState.copyWith(
              recipes: currentState.recipes + results.recipes,
              currentPage: results.pagination.currentPage,
              totalPages: results.pagination.totalPages,
              totalItems: results.pagination.totalItems,
              isLoadingMore: false,
            ),
          );
        } catch (e) {
          emit(FilterLoadFailure(e.toString().replaceFirst('Exception: ', '')));
        }
      }
    });

    on<ClearFilterResults>((event, emit) {
      emit(FilterInitial());
    });
  }
}
