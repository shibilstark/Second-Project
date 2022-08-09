// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeSuccess extends HomeState {
  List<HomeFeedModel> homeFeed;

  HomeSuccess({required this.homeFeed});
  @override
  List<Object> get props => [homeFeed];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  MainFailures fail;

  HomeError(this.fail);

  @override
  List<Object> get props => [fail];
}
