import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';
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

  // void getUserProfile() async {
  //   emit(ProfileLoading());

  //   await profileRepo.getProfile().then((value) {
  //     value.fold(
  //       (success) {
  //         emit(ProfileSuccess(user: success.user, posts: success.posts));

  //         ProfileSuccess(user: success.user, posts: success.posts);
  //       },
  //       (fail) {
  //         emit(ProfileError(fail));
  //       },
  //     );
  //   });
  // }

  // void upadateProfile({required EditProfileModel model}) async {
  //   await profileRepo.editProfile(model: model).then((value) {
  //     value.fold(
  //       (success) {
  //         if (state is ProfileSuccess) {
  //           final newUser = UserModel(
  //             userId: (state as ProfileSuccess).user.userId,
  //             name: success.name,
  //             email: (state as ProfileSuccess).user.email,
  //             isAgreed: (state as ProfileSuccess).user.isAgreed,
  //             isPrivate: (state as ProfileSuccess).user.isPrivate,
  //             isBlocked: (state as ProfileSuccess).user.isBlocked,
  //             creationDate: (state as ProfileSuccess).user.creationDate,
  //             followers: (state as ProfileSuccess).user.followers,
  //             following: (state as ProfileSuccess).user.following,
  //             discription: success.discription,
  //             profileImage: success.profile,
  //             coverImage: success.cover,
  //             notifications: (state as ProfileSuccess).user.notifications,
  //           );
  //           emit((state as ProfileSuccess).copyWith(user: newUser));
  //         } else {
  //           emit(ProfileError(MainFailures(
  //               failureType: MyAppFilures.clientFailure,
  //               error: "somthing went wrong")));
  //         }
  //       },
  //       (fail) {
  //         emit(ProfileError(fail));
  //       },
  //     );
  //   });
  // }

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

  // void addNewPost(PostModel newPostModel) {
  //   final currentState = state;

  //   if (currentState is ProfileSuccess) {
  //     emit(currentState.copyWith(
  //         posts: List.from(currentState.posts)..insert(0, newPostModel)));
  //   }
  // }

  // void deletePost({required String postId, required String postUrl}) async {
  //   await postRepo.deletePost(postId: postId, postUrl: postUrl).then((value) {
  //     value.fold((success) {
  //       final currentState = state;

  //       if (currentState is ProfileSuccess) {
  //         emit(currentState.copyWith(
  //             posts: List.from(currentState.posts)
  //               ..removeWhere((element) => element.postId == postId)));
  //       }
  //     }, (fail) {
  //       emit(ProfileError(fail));
  //     });
  //   });
  // }

  // void likeOrDislikePost(
  //     {required bool shouldLike, required String postId}) async {
  //   await homeRepo
  //       .likeOrDislikePost(postId: postId, shouldLike: shouldLike)
  //       .then((result) {
  //     result.fold(
  //       (isLike) {
  //         final currentState = state;

  //         if (currentState is ProfileSuccess) {
  //           emit(ProfileSuccess(
  //               user: currentState.user,
  //               posts: List.from(currentState.posts)
  //                 ..where((element) {
  //                   if (element.postId == postId) {
  //                     element.lights.add(Global.USER_DATA.id);
  //                     homeCubit.addLikeOrDisLike(
  //                         shouldLike: shouldLike, postId: postId);
  //                   }
  //                   return true;
  //                 }).toList()));
  //         }
  //       },
  //       (fail) {
  //         final currentState = state;

  //         if (currentState is ProfileSuccess) {
  //           emit(ProfileSuccess(
  //               posts: currentState.posts, user: currentState.user));
  //         }
  //       },
  //     );
  //   });
  // }

  // void addLikeOrDisLike({required bool shouldLike, required String postId}) {
  //   final currentState = state;

  //   if (currentState is ProfileSuccess) {
  //     emit(ProfileSuccess(
  //         user: currentState.user,
  //         posts: List.from(currentState.posts)
  //           ..where((element) {
  //             if (element.postId == postId) {
  //               element.lights.add(Global.USER_DATA.id);

  //               return true;
  //             }
  //             return false;
  //           }).toList()));
  //   }
  // }
}
