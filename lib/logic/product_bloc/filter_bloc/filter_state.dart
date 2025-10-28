part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoadInProgress extends FilterState {}

class FilterLoadSuccess extends FilterState {
  final List<Recipes> recipes;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoadingMore;

  const FilterLoadSuccess({
    required this.recipes,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.isLoadingMore = false,
  });

  bool get hasReachedMax => currentPage >= totalPages;

  FilterLoadSuccess copyWith({
    List<Recipes>? recipes,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoadingMore,
  }) {
    return FilterLoadSuccess(
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

class FilterLoadFailure extends FilterState {
  final String error;
  const FilterLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
