part of 'random_recipes_bloc.dart';

abstract class RandomRecipesState extends Equatable {
  const RandomRecipesState();

  @override
  List<Object> get props => [];
}

class RandomRecipesInitial extends RandomRecipesState {}

class RandomRecipesLoadInProgress extends RandomRecipesState {}

class RandomRecipesLoadSuccess extends RandomRecipesState {
  final List<Recipes> recipes;

  const RandomRecipesLoadSuccess(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RandomRecipesLoadFailure extends RandomRecipesState {
  final String error;

  const RandomRecipesLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
