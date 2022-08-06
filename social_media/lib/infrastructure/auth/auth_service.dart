import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/functions/fb.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: AuthRepo)
class AuthService implements AuthRepo {
  @override
  Future<Either<UserModel, MainFailures>> googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();

      GoogleSignInAccount? _user;

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null)
        return Right(MainFailures(
            error: "Select an Account",
            failureType: MyAppFilures.emailOrPasswordFailure));

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // log("${userCred.user!.displayName!}   ${userCred.additionalUserInfo!.username!} ${userCred.user!.email!}");

      final userCollection =
          FirebaseFirestore.instance.collection(Collections.users);
      ;

      if (userCred.additionalUserInfo!.isNewUser) {
        UserModel newUser = UserModel(
          userId: Uuid().v4(),
          name: userCred.user!.displayName!,
          email: userCred.user!.email!,
          isAgreed: true,
          isPrivate: false,
          isBlocked: false,
          creationDate: DateTime.now(),
          followers: [],
          following: [],
          discription: "Hey there I am using this app",
          profileImage: userCred.user!.photoURL!,
          coverImage: null,
          notifications: [],
        );
        await userCollection.doc(newUser.userId).set(newUser.toMap());

        await UserDataStore.saveUserData(
            email: newUser.email, id: newUser.userId, name: newUser.name);
        Global.USER_DATA = UserData(
            email: newUser.email, id: newUser.userId, name: newUser.name);

        return Left(newUser);
      } else {
        final users = await userCollection.get();

        UserModel? userData;

        users.docs.forEach((element) {
          UserModel user = UserModel.fromMap(element.data());
          if (user.email == userCred.user!.email!) {
            userData = user;
            return;
          }
        });
        if (UserData == null) {
          return Right(MainFailures(
              error: "something went wrong please try again later",
              failureType: MyAppFilures.firebaseFailure));
        } else {
          await UserDataStore.saveUserData(
              email: userData!.email,
              id: userData!.userId,
              name: userData!.name);

          Global.USER_DATA = UserData(
              email: userData!.email,
              id: userData!.userId,
              name: userData!.name);

          return Left(userData!);
        }
      }
    } on FirebaseException catch (e) {
      log(e.toString());
      return Right(MainFailures(
          error: firebaseCodeFix(e.code),
          failureType: MyAppFilures.firebaseFailure));
    } catch (e) {
      log(e.toString());
      return Right(MainFailures(
          error: e.toString(), failureType: MyAppFilures.clientFailure));
    }
  }

  @override
  Future<Either<bool, MainFailures>> googleLogout() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await UserDataStore.clearUserData();
      await FirebaseAuth.instance.signOut();

      return Left(true);
    } on FirebaseException catch (e) {
      log(e.toString());
      return Right(MainFailures(
          error: firebaseCodeFix(e.code),
          failureType: MyAppFilures.firebaseFailure));
    } catch (e) {
      log(e.toString());
      return Right(MainFailures(
          error: e.toString(), failureType: MyAppFilures.clientFailure));
    }
  }
}
