part of 'random_recipes_bloc.dart';

abstract class RandomRecipesEvent extends Equatable {
  const RandomRecipesEvent();

  @override
  List<Object> get props => [];
}

class FetchRandomRecipes extends RandomRecipesEvent {}
