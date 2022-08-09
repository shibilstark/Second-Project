import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';

part 'inter_mediat_state.dart';

class InterMediatCubit extends Cubit<InterMediatState> {
  final ProfileCubit profileCubit;
  final HomeCubit homeCubit;
  final HomeRepo homeRepo;
  final PostRepo postRepo;
  final ProfileRepo profileRepo;
  InterMediatCubit(
      {required this.homeCubit,
      required this.profileCubit,
      required this.homeRepo,
      required this.postRepo,
      required this.profileRepo})
      : super(InterMediatInitial());

  void getHomeFeed() async {
    homeCubit.emitLoading();
    await homeRepo.getHomeFeeds().then((result) {
      result.fold(
        (homeFeed) {
          homeCubit.emitSuccess(homefeed: homeFeed);
        },
        (fail) {
          homeCubit.emitError(fail);
        },
      );
    });
  }

  void getUserProfile() async {
    profileCubit.emitLoading();

    await profileRepo.getProfile().then((value) {
      value.fold(
        (success) {
          profileCubit.emitSuccess(
              posts: success.posts, userModel: success.user);
          // emit(ProfileSuccess(user: success.user, posts: success.posts));
        },
        (fail) {
          profileCubit.emitError(fail);
        },
      );
    });
  }

  void likeOrDislikePost(
      {required bool shouldLike, required String postId}) async {
    homeCubit.likePost(shouldLike: shouldLike, postId: postId);
    // await homeRepo
    //     .likeOrDislikePost(postId: postId, shouldLike: shouldLike)
    //     .then((result) {
    //   final currentHomeState = homeCubit.state;
    //   final currentProfileState = profileCubit.state;
    //   result.fold(
    //     (isLike) {
    //       if (currentHomeState is HomeSuccess) {
    //         if (isLike) {
    //           final post = currentHomeState.homeFeed
    //               .firstWhere((element) => element.post.postId == postId);
    //           final oldLikes = post.post.lights;
    //           oldLikes.add(Global.USER_DATA.id);

    //           final List<HomeFeedModel> newFeeds =
    //               List.from(currentHomeState.homeFeed)
    //                 ..where((element) {
    //                   if (element.post.postId == postId) {
    //                     element.post.lights = oldLikes;
    //                   }
    //                   return true;
    //                 });

    //           // final newFeed = (currentHomeState.homeFeed).where((element) {
    //           //   if (element.post.postId == postId) {
    //           //     element.post.lights.add(Global.USER_DATA.id);
    //           //   }
    //           //   return true;
    //           // }).toList();

    //           // log(newFeed.toString());

    //           homeCubit.emitSuccess(homefeed: newFeeds);
    //         } else {
    //           final post = currentHomeState.homeFeed
    //               .firstWhere((element) => element.post.postId == postId);
    //           final oldLikes = post.post.lights;
    //           oldLikes.remove(Global.USER_DATA.id);

    //           final List<HomeFeedModel> newFeeds =
    //               List.from(currentHomeState.homeFeed)
    //                 ..where((element) {
    //                   if (element.post.postId == postId) {
    //                     element.post.lights = oldLikes;
    //                   }
    //                   return true;
    //                 });

    //           homeCubit.emitSuccess(homefeed: newFeeds);

    //           // final newFeed = (currentHomeState.homeFeed).where((element) {
    //           //   if (element.post.postId == postId) {
    //           //     element.post.lights.remove(Global.USER_DATA.id);
    //           //   }
    //           //   return true;
    //           // }).toList();

    //           // log(newFeed.toString());

    //           // homeCubit.emitSuccess(homefeed: newFeed);
    //         }
    //       }
    //       // if (currentProfileState is ProfileSuccess) {
    //       //   if (isLike) {
    //       //     profileCubit.emitSuccess(
    //       //         userModel: currentProfileState.user,
    //       //         posts: List.from(currentProfileState.posts)
    //       //           ..where((element) {
    //       //             if (element.postId == postId) {
    //       //               element.lights.add(Global.USER_DATA.id);
    //       //             }

    //       //             return true;
    //       //           }));
    //       //   } else {
    //       //     profileCubit.emitSuccess(
    //       //         userModel: currentProfileState.user,
    //       //         posts: List.from(currentProfileState.posts)
    //       //           ..where((element) {
    //       //             if (element.postId == postId) {
    //       //               element.lights.remove(Global.USER_DATA.id);
    //       //             }

    //       //             return false;
    //       //           }));
    //       //   }
    //       // }
    //     },
    //     (fail) {
    //       final currentHomeState = homeCubit.state;
    //       final currentProfileState = profileCubit.state;
    //       if (currentHomeState is HomeSuccess) {
    //         homeCubit.emitSuccess(homefeed: currentHomeState.homeFeed);
    //       }
    //       if (currentProfileState is ProfileSuccess) {
    //         profileCubit.emitSuccess(
    //             userModel: currentProfileState.user,
    //             posts: currentProfileState.posts);
    //       }
    //     },
    //   );
    // });
  }

  void upadateProfile({required EditProfileModel model}) async {
    await profileRepo.editProfile(model: model).then((value) {
      final currentProfilestate = profileCubit.state;
      value.fold(
        (success) {
          if (currentProfilestate is ProfileSuccess) {
            final newUser = UserModel(
              userId: currentProfilestate.user.userId,
              name: success.name,
              email: currentProfilestate.user.email,
              isAgreed: currentProfilestate.user.isAgreed,
              isPrivate: currentProfilestate.user.isPrivate,
              isBlocked: currentProfilestate.user.isBlocked,
              creationDate: currentProfilestate.user.creationDate,
              followers: currentProfilestate.user.followers,
              following: currentProfilestate.user.following,
              discription: success.discription,
              profileImage: success.profile,
              coverImage: success.cover,
              notifications: currentProfilestate.user.notifications,
            );
            profileCubit.emitSuccess(
                posts: currentProfilestate.posts, userModel: newUser);
          } else {
            profileCubit.emitError(MainFailures(
                failureType: MyAppFilures.clientFailure,
                error: "somthing went wrong"));
          }
        },
        (fail) {
          profileCubit.emitError(fail);
        },
      );
    });
  }

  void deletePost({required String postId, required String postUrl}) async {
    await postRepo.deletePost(postId: postId, postUrl: postUrl).then((value) {
      value.fold((success) {
        final currentHomeState = homeCubit.state;
        final currentProfileState = profileCubit.state;

        if (currentProfileState is ProfileSuccess) {
          profileCubit.emitSuccess(
              posts: List.from(currentProfileState.posts)
                ..removeWhere((element) => element.postId == postId),
              userModel: currentProfileState.user);
        }
        if (currentHomeState is HomeSuccess) {
          homeCubit.emitSuccess(
              homefeed: List.from(currentHomeState.homeFeed
                ..removeWhere((element) => element.post.postId == postId)));
        }
      }, (fail) {
        profileCubit.emitError(fail);
      });
    });
  }

  void addNewPost(PostModel newPostModel) {
    final currentHomeState = homeCubit.state;
    final currentProfileState = profileCubit.state;

    if (currentProfileState is ProfileSuccess) {
      profileCubit.emitSuccess(
          posts: List.from(currentProfileState.posts)..insert(0, newPostModel),
          userModel: currentProfileState.user);
      if (currentHomeState is HomeSuccess) {
        homeCubit.emitSuccess(
            homefeed: List.from(currentHomeState.homeFeed)
              ..insert(
                  0,
                  HomeFeedModel(
                      post: newPostModel, user: currentProfileState.user)));
      }
    }
  }
}
