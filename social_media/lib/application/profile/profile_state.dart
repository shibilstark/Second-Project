// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  UserModel user;
  List<PostModel> posts;

  ProfileSuccess({required this.user, required this.posts});
  @override
  List<Object> get props => [user, posts];

  ProfileSuccess copyWith({
    UserModel? user,
    List<PostModel>? posts,
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      posts: posts ?? this.posts,
    );
  }
}

class ProfileError extends ProfileState {
  MainFailures fail;
  ProfileError(this.fail);
  @override
  List<Object> get props => [fail];
}
