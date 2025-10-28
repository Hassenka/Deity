part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailState extends Equatable {
  const RecipeDetailState();
  @override
  List<Object> get props => [];
}

class RecipeDetailInitial extends RecipeDetailState {}

class RecipeDetailLoadInProgress extends RecipeDetailState {}

class RecipeDetailLoadSuccess extends RecipeDetailState {
  final RecipeDetailModel recipe;
  const RecipeDetailLoadSuccess(this.recipe);
}

class RecipeDetailLoadFailure extends RecipeDetailState {
  final String error;
  const RecipeDetailLoadFailure(this.error);
}
