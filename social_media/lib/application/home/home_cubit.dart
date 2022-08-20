import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/application/profile/profile_cubit.dart';

import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
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

  void emitSuccess({required HomeDataModel data}) {
    final currentState = state;

    if (currentState is HomeSuccess) {
      if (currentState.type == HomeSuccessType.changeState) {
        emit(HomeSuccess(
            homeFeed: data.homeFeedModel,
            type: HomeSuccessType.stateChange,
            peoples: data.peoples));
      } else if (currentState.type == HomeSuccessType.stateChange) {
        emit(HomeSuccess(
            homeFeed: data.homeFeedModel,
            type: HomeSuccessType.changeState,
            peoples: data.peoples));
      } else {
        emit(HomeSuccess(
            homeFeed: data.homeFeedModel,
            type: HomeSuccessType.changeState,
            peoples: data.peoples));
      }
    } else {
      emit(HomeSuccess(
          homeFeed: data.homeFeedModel,
          type: HomeSuccessType.changeState,
          peoples: data.peoples));
    }
  }

  void emitError(MainFailures fail) {
    emit(HomeError(fail));
  }

  // void likeOrDislikePost(
  //     {required bool shouldLike, required String postId}) async {
  //   await homeRepo
  //       .likeOrDislikePost(postId: postId, shouldLike: shouldLike)
  //       .then((result) {
  //     final currentHomeState = state;

  //     result.fold(
  //       (isLike) {
  //         if (currentHomeState is HomeSuccess) {
  //           if (isLike) {
  //             final post = currentHomeState.homeFeed
  //                 .firstWhere((element) => element.post.postId == postId);
  //             final oldLikes = post.post.lights;
  //             oldLikes.add(Global.USER_DATA.id);

  //             final List<HomeFeedModel> newFeeds =
  //                 List.from(currentHomeState.homeFeed)
  //                   ..where((element) {
  //                     if (element.post.postId == postId) {
  //                       element.post.lights = oldLikes;
  //                     }
  //                     return true;
  //                   });

  //             if (currentHomeState.type == HomeSuccessType.changeState) {
  //               emit(HomeSuccess(
  //                   homeFeed: newFeeds, type: HomeSuccessType.stateChange));
  //             } else {
  //               emit(HomeSuccess(
  //                   homeFeed: newFeeds, type: HomeSuccessType.changeState));
  //             }
  //           } else {
  //             final post = currentHomeState.homeFeed
  //                 .firstWhere((element) => element.post.postId == postId);
  //             final oldLikes = post.post.lights;
  //             oldLikes.remove(Global.USER_DATA.id);

  //             final List<HomeFeedModel> newFeeds =
  //                 List.from(currentHomeState.homeFeed)
  //                   ..where((element) {
  //                     if (element.post.postId == postId) {
  //                       element.post.lights = oldLikes;
  //                     }
  //                     return true;
  //                   });

  //             if (currentHomeState.type == HomeSuccessType.changeState) {
  //               emit(HomeSuccess(
  //                   homeFeed: newFeeds, type: HomeSuccessType.stateChange));
  //             } else {
  //               emit(HomeSuccess(
  //                   homeFeed: newFeeds, type: HomeSuccessType.changeState));
  //             }
  //           }
  //         }
  //       },
  //       (fail) {
  //         if (currentHomeState is HomeSuccess) {
  //           if (currentHomeState.type == HomeSuccessType.changeState) {
  //             emit(HomeSuccess(
  //                 homeFeed: currentHomeState.homeFeed,
  //                 type: HomeSuccessType.stateChange));
  //           } else {
  //             emit(HomeSuccess(
  //                 homeFeed: currentHomeState.homeFeed,
  //                 type: HomeSuccessType.changeState));
  //           }
  //         }
  //       },
  //     );
  //   });
  // }

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
