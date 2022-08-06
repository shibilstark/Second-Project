part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLaoding extends ProfileState {}

class ProfileUpadating extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;
  final List<PostModel> posts;
  ProfileSuccess({required this.user, required this.posts});

  @override
  List<Object> get props => [user, posts];
}

class ProfileError extends ProfileState {
  MainFailures fail;

  ProfileError(this.fail);
}
