import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ProfileCubit profileCubit;
  final HomeCubit homeCubit;
  final HomeRepo homeRepo;
  final PostRepo postRepo;
  final ProfileRepo profileRepo;
  MainCubit(
      {required this.homeCubit,
      required this.profileCubit,
      required this.homeRepo,
      required this.postRepo,
      required this.profileRepo})
      : super(MainInitial());

  void getUserProfile() async {
    profileCubit.emitLoading();

    await profileRepo.getProfile().then((value) {
      value.fold(
        (success) {
          profileCubit.emitSuccess(
              posts: success.posts, userModel: success.user);
        },
        (fail) {
          profileCubit.emitError(fail);
        },
      );
    });
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
                posts: currentProfilestate.posts.toList(), userModel: newUser);
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
              data: HomeDataModel(
                  peoples: currentHomeState.peoples,
                  homeFeedModel: List.from(currentHomeState.homeFeed
                    ..removeWhere(
                        (element) => element.post.postId == postId))));
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
            data: HomeDataModel(
                peoples: currentHomeState.peoples,
                homeFeedModel: List.from(currentHomeState.homeFeed)
                  ..insert(
                      0,
                      HomeFeedModel(
                          post: newPostModel,
                          user: currentProfileState.user))));
      }
    }
  }

  void getHomeFeeds() async {
    homeCubit.emitLoading();
    await homeRepo.getHomeFeeds().then((result) {
      result.fold(
        (homeFeed) {
          homeCubit.emitSuccess(data: homeFeed);
        },
        (fail) {
          homeCubit.emitError(fail);
        },
      );
    });
  }

  void likePost() async {}
  // void getProfile(){}
  // void getProfile(){}
  // void getProfile(){}
}
