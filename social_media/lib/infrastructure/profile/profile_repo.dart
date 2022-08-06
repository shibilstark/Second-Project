import 'package:dartz/dartz.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<ProfileModel, MainFailures>> getProfile();
  Future<Either<EditNameAndDiscModel, MainFailures>> editNameAndDiscPic(
      {required String name, required String? disc});

  Future<Either<String?, MainFailures>> upadateCoverPic(
      {required String? newPic});
  Future<Either<String?, MainFailures>> upadateProfilePic(
      {required String? newPic});
}
