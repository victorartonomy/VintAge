import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/search/domain/search_repo.dart';
import 'package:vintage/features/search/presentation/cubits/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}): super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchLoaded([]));
      return;
    }

    try {
      
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));

    } catch(e) {
      emit(SearchError("Error fetching search results: $e"));
    }
  }
}