part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoadInProgress extends SearchState {}

class SearchLoadSuccess extends SearchState {
  final List<Recipes> recipes;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoadingMore;

  const SearchLoadSuccess({
    required this.recipes,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.isLoadingMore = false,
  });

  bool get hasReachedMax => currentPage >= totalPages;

  SearchLoadSuccess copyWith({
    List<Recipes>? recipes,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoadingMore,
  }) {
    return SearchLoadSuccess(
      recipes: recipes ?? this.recipes,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
    recipes,
    currentPage,
    totalPages,
    totalItems,
    isLoadingMore,
  ];
}

class SearchLoadFailure extends SearchState {
  final String error;
  const SearchLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
