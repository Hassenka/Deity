part of 'categorie_bloc.dart';

abstract class CategorieState extends Equatable {
  const CategorieState();

  @override
  List<Object> get props => [];
}

class CategorieInitial extends CategorieState {}

class CategorieLoadInProgress extends CategorieState {}

class CategorieLoadSuccess extends CategorieState {
  final List<Recipes> recipes;
  final int currentPage;
  final int totalPages;

  const CategorieLoadSuccess({
    required this.recipes,
    required this.currentPage,
    required this.totalPages,
  });

  // A getter to determine if the last page has been reached.
  // This keeps the logic clean and centralized in the state.
  bool get hasReachedMax => currentPage >= totalPages;

  @override
  List<Object> get props => [recipes, currentPage, totalPages];
}

class CategorieLoadFailure extends CategorieState {
  final String error;
  const CategorieLoadFailure(this.error);
}
