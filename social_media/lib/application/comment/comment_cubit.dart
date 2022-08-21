import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/others_profile/others_profile_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/home/home_services.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final HomeRepo homeRepo;
  final HomeCubit homeCubit;
  final ProfileCubit profileCubit;
  final OthersProfileCubit othersProfileCubit;
  CommentCubit(
      {required this.homeRepo,
      required this.homeCubit,
      required this.othersProfileCubit,
      required this.profileCubit})
      : super(CommentInitial());

  void getAllComments({required String postId}) async {
    emit(CommentLoading());

    await homeRepo.getAllPostComments(postId: postId).then((value) {
      value.fold(
        (success) {
          emit(CommentSuccess(success));
        },
        (fail) {
          emit(CommentError());
        },
      );
    });
  }

  void commentThePost({required PostComment comment}) async {
    final currentHomeState = homeCubit.state;
    final currentProfileState = profileCubit.state;
    final currentOthersState = othersProfileCubit.state;

    await homeRepo.commentThePost(comment: comment).then((value) {
      value.fold((l) {
        final currentState = state;

        if (currentState is CommentSuccess) {
          emit(CommentSuccess(List.from(currentState.comments)..insert(0, l)));

          if (currentHomeState is HomeSuccess) {
            homeCubit.emitSuccess(
                data: HomeDataModel(
                    peoples: currentHomeState.peoples,
                    homeFeedModel: List.from(currentHomeState.homeFeed)
                      ..where((element) {
                        if (element.post.postId == comment.postId) {
                          element.post.comments.add(comment.commentId);
                        }
                        return true;
                      }).toList()));
          }

          if (currentOthersState is OthersProfileSuccess) {
            othersProfileCubit.emitSuccess(
                posts: List.from(currentOthersState.posts)
                  ..where((element) {
                    if (element.postId == comment.postId) {
                      element.comments.add(comment.commentId);
                    }

                    return true;
                  }).toList(),
                user: currentOthersState.user);
          }
          if (currentProfileState is ProfileSuccess) {
            profileCubit.emitSuccess(
                posts: List.from(currentProfileState.posts)
                  ..where((element) {
                    if (element.postId == comment.postId) {
                      element.comments.add(comment.commentId);
                    }

                    return true;
                  }).toList(),
                userModel: currentProfileState.user);
          }
        }
      }, (r) {});
    });
  }

  void deleteComment(
      {required String commentId, required String postId}) async {
    await homeRepo
        .deletePostComments(commentId: commentId, postId: postId)
        .then((value) {
      final currentHomeState = homeCubit.state;
      final currentProfileState = profileCubit.state;
      final currentOthersState = othersProfileCubit.state;
      value.fold((l) {
        final currentState = state;

        if (currentState is CommentSuccess) {
          emit(CommentSuccess(List.from(currentState.comments)
            ..removeWhere((element) => element.id == commentId)));

          if (currentHomeState is HomeSuccess) {
            homeCubit.emitSuccess(
                data: HomeDataModel(
                    peoples: currentHomeState.peoples,
                    homeFeedModel: List.from(currentHomeState.homeFeed)
                      ..where((element) {
                        if (element.post.postId == postId) {
                          element.post.comments.remove(commentId);
                        }
                        return true;
                      }).toList()));
          }
          if (currentOthersState is OthersProfileSuccess) {
            othersProfileCubit.emitSuccess(
                posts: List.from(currentOthersState.posts)
                  ..where((element) {
                    if (element.postId == postId) {
                      element.comments.remove(commentId);
                    }

                    return true;
                  }).toList(),
                user: currentOthersState.user);
          }

          if (currentProfileState is ProfileSuccess) {
            profileCubit.emitSuccess(
                posts: List.from(currentProfileState.posts)
                  ..where((element) {
                    if (element.postId == postId) {
                      element.comments.remove(commentId);
                    }

                    return true;
                  }).toList(),
                userModel: currentProfileState.user);
          }
        }
      }, (r) {});
    });
  }
}
