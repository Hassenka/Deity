import 'package:bloc/bloc.dart';
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:logger/logger.dart';

part 'search_event.dart';
part 'search_state.dart';

const _duration = Duration(milliseconds: 300);
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService = ApiService();
  final _logger = Logger();
  String _currentQuery = '';
  final int _limit = 9; // Consistent with API's default limit

  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      final newQuery = event.query.trim();
      if (newQuery.isEmpty) {
        _currentQuery = '';
        // Emit an empty success state when the search query is cleared
        return emit(
          const SearchLoadSuccess(
            recipes: [],
            currentPage: 0,
            totalPages: 0,
            totalItems: 0,
          ),
        );
      }

      // Only perform search if query has changed or it's the first search
      if (newQuery == _currentQuery && state is SearchLoadSuccess) {
        return;
      }

      _currentQuery = newQuery;
      emit(SearchLoadInProgress());
      try {
        final categoryResponse = await _apiService.searchRecipes(
          searchQuery: _currentQuery,
          page: 1, // Always start from page 1 for a new search query
          limit: _limit,
        );
        emit(
          SearchLoadSuccess(
            recipes: categoryResponse.recipes,
            currentPage: categoryResponse.pagination.currentPage,
            totalPages: categoryResponse.pagination.totalPages,
            totalItems: categoryResponse.pagination.totalItems,
          ),
        );
      } catch (e) {
        _logger.e('SearchQueryChanged Error: $e');
        emit(SearchLoadFailure(e.toString()));
      }
    }, transformer: debounce(_duration));

    on<LoadMoreSearchResults>((event, emit) async {
      if (state is SearchLoadSuccess) {
        final currentState = state as SearchLoadSuccess;
        if (currentState.hasReachedMax) return; // No more pages to load

        emit(
          currentState.copyWith(isLoadingMore: true),
        ); // Show loading indicator without removing list

        try {
          final categoryResponse = await _apiService.searchRecipes(
            searchQuery: _currentQuery,
            page: currentState.currentPage + 1, // Request the next page
            limit: _limit,
          );
          emit(
            SearchLoadSuccess(
              recipes: currentState.recipes + categoryResponse.recipes,
              currentPage: categoryResponse.pagination.currentPage,
              totalPages: categoryResponse.pagination.totalPages,
              totalItems: categoryResponse.pagination.totalItems,
              isLoadingMore: false, // Reset loading flag
            ),
          );
        } catch (e) {
          _logger.e('LoadMoreSearchResults Error: $e');
          emit(SearchLoadFailure(e.toString()));
        }
      }
    });
  }
}
