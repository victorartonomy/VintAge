import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/search/domain/entities/search_result.dart';
import 'package:vintage/features/search/domain/search_repo.dart';
import 'package:vintage/features/search/presentation/cubits/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchLoaded(SearchResult()));
      return;
    }

    try {
      emit(SearchLoading());
      final results = await searchRepo.search(query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError("Error fetching search results: $e"));
    }
  }
}
