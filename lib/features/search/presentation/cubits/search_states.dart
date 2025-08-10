import '../../domain/entities/search_result.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final SearchResult results;

  SearchLoaded(this.results);
}

class SearchError extends SearchStates {
  final String message;

  SearchError(this.message);
}
