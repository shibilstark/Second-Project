import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  final PostRepo postRepo;

  HomeCubit({required this.homeRepo, required this.postRepo})
      : super(HomeInitial());

  void emitLoading() {
    emit(HomeLoading());
  }

  void emitSuccess({required List<HomeFeedModel> homefeed}) {
    emit(HomeSuccess(homeFeed: homefeed));
  }

  void emitError(MainFailures fail) {
    emit(HomeError(fail));
  }

  @override
  void onChange(Change<HomeState> change) {
    log("change");
    log(change.toString());
    super.onChange(change);
  }

  void likePost({required bool shouldLike, required String postId}) async {
    await homeRepo
        .likeOrDislikePost(postId: postId, shouldLike: shouldLike)
        .then((result) {
      final currentHomeState = state;

      result.fold(
        (isLike) {
          if (currentHomeState is HomeSuccess) {
            if (isLike) {
              final post = currentHomeState.homeFeed
                  .firstWhere((element) => element.post.postId == postId);
              final oldLikes = post.post.lights;
              oldLikes.add(Global.USER_DATA.id);

              final List<HomeFeedModel> newFeeds =
                  List.from(currentHomeState.homeFeed)
                    ..where((element) {
                      if (element.post.postId == postId) {
                        log("${postId}");
                        element.post.lights = oldLikes;
                      }
                      return true;
                    });

              // final newFeed = (currentHomeState.homeFeed).where((element) {
              //   if (element.post.postId == postId) {
              //     element.post.lights.add(Global.USER_DATA.id);
              //   }
              //   return true;
              // }).toList();

              // log(newFeed.toString());
              log("${postId}");

              emit(HomeSuccess(homeFeed: newFeeds));
            } else {
              final post = currentHomeState.homeFeed
                  .firstWhere((element) => element.post.postId == postId);
              final oldLikes = post.post.lights;
              oldLikes.remove(Global.USER_DATA.id);

              final List<HomeFeedModel> newFeeds =
                  List.from(currentHomeState.homeFeed)
                    ..where((element) {
                      if (element.post.postId == postId) {
                        log("${postId}");
                        element.post.lights = oldLikes;
                      }
                      return true;
                    });

              emit(HomeSuccess(homeFeed: newFeeds));

              // final newFeed = (currentHomeState.homeFeed).where((element) {
              //   if (element.post.postId == postId) {
              //     element.post.lights.remove(Global.USER_DATA.id);
              //   }
              //   return true;
              // }).toList();

              // log(newFeed.toString());

              // homeCubit.emitSuccess(homefeed: newFeed);
            }
          }
          // if (currentProfileState is ProfileSuccess) {
          //   if (isLike) {
          //     profileCubit.emitSuccess(
          //         userModel: currentProfileState.user,
          //         posts: List.from(currentProfileState.posts)
          //           ..where((element) {
          //             if (element.postId == postId) {
          //               element.lights.add(Global.USER_DATA.id);
          //             }

          //             return true;
          //           }));
          //   } else {
          //     profileCubit.emitSuccess(
          //         userModel: currentProfileState.user,
          //         posts: List.from(currentProfileState.posts)
          //           ..where((element) {
          //             if (element.postId == postId) {
          //               element.lights.remove(Global.USER_DATA.id);
          //             }

          //             return false;
          //           }));
          //   }
          // }
        },
        (fail) {
          if (currentHomeState is HomeSuccess) {
            emit(HomeSuccess(homeFeed: currentHomeState.homeFeed));
          }
        },
      );
    });
  }

  // void addLikeOrDisLike({required bool shouldLike, required String postId}) {
  //   final currentState = state;

  //   if (currentState is HomeSuccess) {
  //     emit(HomeSuccess(List.from(currentState.homeFeed)
  //       ..where((element) {
  //         if (element.post.post == postId) {
  //           element.post.lights.add(Global.USER_DATA.id);

  //           return true;
  //         }
  //         return false;
  //       }).toList()));
  //   }
  // }
}
