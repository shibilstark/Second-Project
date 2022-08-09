import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final HomeRepo homeRepo;
  final HomeCubit homeCubit;
  final ProfileCubit profileCubit;

  CommentCubit(
      {required this.homeRepo,
      required this.homeCubit,
      required this.profileCubit})
      : super(CommentInitial());

  void getAllComments({required String postId}) async {
    emit(CommentLoading());
    await homeRepo.getAllPostComments(postId: postId).then((value) {
      value.fold((success) {
        emit(CommentSuccess(comments: success));
      }, (fail) {
        emit(CommentError());
      });
    });
  }

  void commentThePost({required PostComment comment}) async {
    await homeRepo.commentThePost(comment: comment).then((value) {
      final currentHomeState = homeCubit.state;
      final currentProfileState = profileCubit.state;
      value.fold((success) {
        final currenstate = state;

        if (currenstate is CommentSuccess) {
          emit(CommentSuccess(
              comments: List.from(currenstate.comments)..add(success)));
        }

        if (currentHomeState is HomeSuccess) {
          log("homeSuccess");
          homeCubit.emitSuccess(
              homefeed: List.from(currentHomeState.homeFeed)
                ..where((element) {
                  if (element.post.postId == comment.postId) {
                    element.post.comments.where((com) {
                      if (com.commentId != comment.commentId) {
                        element.post.comments.add(comment);
                      }

                      return true;
                    });
                  }
                  return true;
                }).toList());
        }

        if (currentProfileState is ProfileSuccess) {
          log("profileSuccess");
          profileCubit.emitSuccess(
              posts: List.from(currentProfileState.posts)
                ..where((element) {
                  if (element.postId == comment.postId) {
                    element.comments.where((com) {
                      if (com.commentId != comment.commentId) {
                        element.comments.add(comment);
                      }

                      return true;
                    });
                    log(comment.toMap().toString());
                  }
                  return true;
                }).toList(),
              userModel: currentProfileState.user);
        }
      }, (fail) {});
    });
  }
}
