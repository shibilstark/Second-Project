part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchIdle extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  List<UserModel> peoples;

  SearchSuccess(this.peoples);
  @override
  List<Object> get props => [peoples];
}

class SearchError extends SearchState {
  MainFailures fail;

  SearchError(this.fail);
  @override
  List<Object> get props => [fail];
}
