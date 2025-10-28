part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailEvent extends Equatable {
  const RecipeDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchRecipeById extends RecipeDetailEvent {
  final int recipeId;
  const FetchRecipeById(this.recipeId);
}
