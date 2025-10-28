part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ApplyFilters extends FilterEvent {
  final Set<String> meals;
  final Set<String> ingredients;
  final Set<String> methods;
  final Set<String> diets;
  final int kcalMin;
  final int kcalMax;

  const ApplyFilters({
    required this.meals,
    required this.ingredients,
    required this.methods,
    required this.diets,
    required this.kcalMin,
    required this.kcalMax,
  });

  @override
  List<Object?> get props => [
    meals,
    ingredients,
    methods,
    diets,
    kcalMin,
    kcalMax,
  ];
}

class LoadMoreFilterResults extends FilterEvent {}

class ClearFilterResults extends FilterEvent {}
