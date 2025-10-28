import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_model.dart'; 
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';
part 'random_recipes_event.dart';
part 'random_recipes_state.dart';

class RandomRecipesBloc extends Bloc<RandomRecipesEvent, RandomRecipesState> {
  final ApiService _apiService = ApiService();

  RandomRecipesBloc() : super(RandomRecipesInitial()) {
    on<FetchRandomRecipes>((event, emit) async {
      emit(RandomRecipesLoadInProgress());
      try {
        final recipes = await _apiService.getRandomRecipes();
        emit(RandomRecipesLoadSuccess(recipes));
      } catch (e) {
        emit(RandomRecipesLoadFailure(e.toString()));
      }
    });
  }
}
