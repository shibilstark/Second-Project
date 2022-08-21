import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/search/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  void searchUser({required String query}) async {
    emit(SearchLoading());
    await searchRepo.searchPeople(query: query).then((result) {
      result.fold((searchResult) {
        emit(SearchSuccess(searchResult));
      }, (fail) {
        emit(SearchError(fail));
      });
    });
  }
}
