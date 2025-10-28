part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoadInProgress extends FavoritesState {}

class FavoritesLoadSuccess extends FavoritesState {
  final List<Recipe> recipes;
  final Set<int> favoriteIds;

  const FavoritesLoadSuccess(this.recipes, this.favoriteIds);
  @override
  List<Object> get props => [recipes, favoriteIds];
}

class FavoritesLoadFailure extends FavoritesState {
  final String error;
  const FavoritesLoadFailure(this.error);
  @override
  List<Object> get props => [error];
}
