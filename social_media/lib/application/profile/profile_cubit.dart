import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final PostRepo postRepo;
  final HomeRepo homeRepo;
  ProfileCubit({
    required this.profileRepo,
    required this.postRepo,
    required this.homeRepo,
  }) : super(ProfileInitial());

  void emitLoading() {
    emit(ProfileLoading());
  }

  void emitSuccess(
      {required List<PostModel> posts, required UserModel userModel}) {
    emit(ProfileSuccess(posts: posts, user: userModel));
  }

  void emitError(MainFailures fail) {
    emit(ProfileError(fail));
  }

  void likeOrDislikePost(
      {required bool shouldLike, required String postId}) async {
    await homeRepo
        .likeOrDislikePost(postId: postId, shouldLike: shouldLike)
        .then((result) {
      final currenState = state;

      result.fold(
        (isLike) {
          if (currenState is ProfileSuccess) {
            if (isLike) {
              final post = currenState.posts
                  .firstWhere((element) => element.postId == postId);
              final oldLikes = post.lights;
              oldLikes.add(Global.USER_DATA.id);

              final List<PostModel> newPosts = List.from(currenState.posts)
                ..where((element) {
                  if (element.postId == postId) {
                    element.lights = oldLikes;
                  }
                  return true;
                });

              emit(ProfileSuccess(user: currenState.user, posts: newPosts));
              ;
            } else {
              final post = currenState.posts
                  .firstWhere((element) => element.postId == postId);
              final oldLikes = post.lights;
              oldLikes.remove(Global.USER_DATA.id);

              final List<PostModel> newPosts = List.from(currenState.posts)
                ..where((element) {
                  if (element.postId == postId) {
                    element.lights = oldLikes;
                  }
                  return true;
                });

              emit(ProfileSuccess(posts: newPosts, user: currenState.user));
            }
          }
        },
        (fail) {
          if (currenState is ProfileSuccess) {
            emit(ProfileSuccess(
                posts: currenState.posts, user: currenState.user));
          }
        },
      );
    });
  }
}
