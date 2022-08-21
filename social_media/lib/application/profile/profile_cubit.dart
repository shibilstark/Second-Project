import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/application/home/home_cubit.dart';
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
    final currentState = state;

    log('profile emit running');

    if (currentState is ProfileSuccess) {
      if (currentState.type == ProfileSuccessType.changed) {
        emit(ProfileSuccess(
            posts: posts, user: userModel, type: ProfileSuccessType.done));
      } else {
        emit(ProfileSuccess(
            posts: posts, user: userModel, type: ProfileSuccessType.changed));
      }
    } else {
      emit(ProfileSuccess(
          posts: posts, user: userModel, type: ProfileSuccessType.done));
    }
  }

  void emitError(MainFailures fail) {
    emit(ProfileError(fail));
  }
}
