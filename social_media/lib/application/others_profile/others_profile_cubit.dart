import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';

part 'others_profile_state.dart';

class OthersProfileCubit extends Cubit<OthersProfileState> {
  final ProfileRepo profileRepo;
  final ProfileCubit profileCubit;

  final HomeRepo homeRepo;
  OthersProfileCubit({
    required this.homeRepo,
    required this.profileRepo,
    required this.profileCubit,
  }) : super(OthersProfileInitial());

  void getProfileById({required String userId}) async {
    emit(OthersProfileLoading());

    await profileRepo.getProfileById(userId: userId).then((value) {
      final currentState = state;

      value.fold((l) {
        if (currentState is OthersProfileSuccess) {
          if (currentState.type == ProfileSuccessType.changed) {
            emit(OthersProfileSuccess(
                posts: l.posts, user: l.user, type: ProfileSuccessType.done));
          } else {
            emit(OthersProfileSuccess(
                posts: l.posts,
                user: l.user,
                type: ProfileSuccessType.changed));
          }
        } else {
          emit(OthersProfileSuccess(
              posts: l.posts, user: l.user, type: ProfileSuccessType.changed));
        }
      }, (r) {
        emit(OthersProfileError());
      });
    });
  }

  void followUnfollow(
      {required String userId, required bool shouldFollow}) async {
    await profileRepo
        .followUnfollow(userId: userId, shouldFollow: shouldFollow)
        .then((value) {
      final currentProfileState = profileCubit.state;

      final currentState = state;
      value.fold((success) {
        if (success) {
          if (currentState is OthersProfileSuccess) {
            if (currentState.type == ProfileSuccessType.changed) {
              emit(OthersProfileSuccess(
                  posts: (currentState.posts),
                  user: currentState.user..followers.add(Global.USER_DATA.id),
                  type: ProfileSuccessType.done));
            } else {
              emit(OthersProfileSuccess(
                  posts: (currentState.posts),
                  user: currentState.user..followers.add(Global.USER_DATA.id),
                  type: ProfileSuccessType.changed));
            }
          }

          if (currentProfileState is ProfileSuccess) {
            profileCubit.emitSuccess(
                posts: currentProfileState.posts,
                userModel: currentProfileState.user
                  ..following.add(Global.USER_DATA.id));
          }
        } else {
          if (currentState is OthersProfileSuccess) {
            if (currentState.type == ProfileSuccessType.changed) {
              emit(OthersProfileSuccess(
                  posts: (currentState.posts),
                  user: currentState.user
                    ..followers.remove(Global.USER_DATA.id),
                  type: ProfileSuccessType.done));
            } else {
              emit(OthersProfileSuccess(
                  posts: (currentState.posts),
                  user: currentState.user
                    ..followers.remove(Global.USER_DATA.id),
                  type: ProfileSuccessType.changed));
            }
          }

          if (currentProfileState is ProfileSuccess) {
            profileCubit.emitSuccess(
                posts: currentProfileState.posts,
                userModel: currentProfileState.user
                  ..following.remove(Global.USER_DATA.id));
          }
        }
      }, (r) {});
    });
  }

  void emitSuccess({required List<PostModel> posts, required UserModel user}) {
    final currentState = state;

    if (currentState is OthersProfileSuccess) {
      if (currentState.type == ProfileSuccessType.changed) {
        emit(OthersProfileSuccess(
            posts: posts, user: user, type: ProfileSuccessType.done));
      } else {
        emit(OthersProfileSuccess(
            posts: posts, user: user, type: ProfileSuccessType.changed));
      }
    } else {
      emit(OthersProfileSuccess(
          posts: posts, user: user, type: ProfileSuccessType.changed));
    }
  }
}
