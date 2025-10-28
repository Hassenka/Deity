part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class FetchFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final int recipeId;
  final BuildContext context;

  const ToggleFavorite({required this.recipeId, required this.context});

  @override
  List<Object> get props => [recipeId, context];
}
