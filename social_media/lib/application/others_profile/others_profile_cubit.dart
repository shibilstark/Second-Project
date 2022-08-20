import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';
import 'package:social_media/presentation/screens/home/home.dart';

part 'others_profile_state.dart';

class OthersProfileCubit extends Cubit<OthersProfileState> {
  final ProfileRepo profileRepo;
  OthersProfileCubit({required this.profileRepo})
      : super(OthersProfileInitial());

  void getProfileById({required String userId}) async {
    emit(OthersProfileLoading());

    await profileRepo.getProfileById(userId: userId).then((value) {
      value.fold((l) {
        emit(OthersProfileSuccess(posts: l.posts, user: l.user));
      }, (r) {
        emit(OthersProfileError());
      });
    });
  }
}
