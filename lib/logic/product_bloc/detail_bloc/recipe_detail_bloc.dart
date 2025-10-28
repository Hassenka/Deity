import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_detail_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final ApiService _apiService = ApiService();

  RecipeDetailBloc() : super(RecipeDetailInitial()) {
    on<FetchRecipeById>((event, emit) async {
      emit(RecipeDetailLoadInProgress());
      try {
        final recipe = await _apiService.getRecipeById(event.recipeId);
        emit(RecipeDetailLoadSuccess(recipe));
      } catch (e) {
        emit(RecipeDetailLoadFailure(e.toString()));
      }
    });
  }
}
