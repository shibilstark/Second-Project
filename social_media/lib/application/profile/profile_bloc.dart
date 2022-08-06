import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _profileRepo;
  ProfileBloc(this._profileRepo) : super(ProfileInitial()) {
    on<GetProfileData>((event, emit) async {
      emit(ProfileLaoding());

      await _profileRepo.getProfile().then((value) {
        value.fold(
          (success) {
            emit(ProfileSuccess(user: success.user, posts: success.posts));
          },
          (fail) {
            emit(ProfileError(fail));
          },
        );
      });
    });
  }
}
