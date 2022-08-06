import 'package:dartz/dartz.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';

abstract class AuthRepo {
  Future<Either<UserModel, MainFailures>> googleLogin();
  Future<Either<bool, MainFailures>> googleLogout();
}
