part of 'others_profile_cubit.dart';

@immutable
abstract class OthersProfileState {}

class OthersProfileInitial extends OthersProfileState {}

class OthersProfileLoading extends OthersProfileState {}

class OthersProfileSuccess extends OthersProfileState {
  UserModel user;
  List<PostModel> posts;

  OthersProfileSuccess({required this.posts, required this.user});
}

class OthersProfileError extends OthersProfileState {}
