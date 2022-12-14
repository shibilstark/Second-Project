import 'package:dartz/dartz.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<ProfileModel, MainFailures>> getProfile();
  Future<Either<ProfileModel, MainFailures>> getProfileById(
      {required String userId});
  Future<Either<bool, MainFailures>> followUnfollow(
      {required String userId, required bool shouldFollow});
  Future<Either<EditProfileModel, MainFailures>> editProfile(
      {required EditProfileModel model});
}
