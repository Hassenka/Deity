part of 'categorie_bloc.dart';

abstract class CategorieEvent extends Equatable {
  const CategorieEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipesByCategory extends CategorieEvent {
  final String categoryName;
  const FetchRecipesByCategory(this.categoryName);
}

class LoadMoreRecipesByCategory extends CategorieEvent {}
