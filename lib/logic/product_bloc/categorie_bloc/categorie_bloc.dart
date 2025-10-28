import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  final ApiService _apiService = ApiService();
  final int _limit = 9; // Renamed to match the API parameter
  String _currentCategory = '';

  CategorieBloc() : super(CategorieInitial()) {
    on<FetchRecipesByCategory>((event, emit) async {
      emit(CategorieLoadInProgress());
      _currentCategory = event.categoryName;
      try {
        final categoryResponse = await _apiService.getRecipesByCategory(
          category: _currentCategory,
          page: 1, // Always fetch the first page initially
          limit: _limit,
        );
        emit(
          CategorieLoadSuccess(
            recipes: categoryResponse.recipes,
            currentPage: categoryResponse.pagination.currentPage,
            totalPages: categoryResponse.pagination.totalPages,
          ),
        );
      } catch (e) {
        emit(CategorieLoadFailure(e.toString()));
      }
    });

    on<LoadMoreRecipesByCategory>((event, emit) async {
      if (state is CategorieLoadSuccess) {
        final currentState = state as CategorieLoadSuccess;
        // Prevent fetching if we are already on the last page
        if (currentState.hasReachedMax) return;
        try {
          final categoryResponse = await _apiService.getRecipesByCategory(
            category: _currentCategory,
            page: currentState.currentPage + 1, // Request the next page
            limit: _limit,
          );
          emit(
            CategorieLoadSuccess(
              recipes: currentState.recipes + categoryResponse.recipes,
              currentPage: categoryResponse.pagination.currentPage,
              totalPages: categoryResponse.pagination.totalPages,
            ),
          );
        } catch (e) {
          emit(CategorieLoadFailure(e.toString()));
        }
      }
    });
  }
}
