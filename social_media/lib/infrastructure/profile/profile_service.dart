import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';

import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/profile_model/profile_model.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/functions/fb.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';

@LazySingleton(as: ProfileRepo)
class ProfileServices implements ProfileRepo {
  @override
  Future<Either<ProfileModel, MainFailures>> getProfile() async {
    try {
      final user = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id)
          .get();
      final postsCollection =
          await FirebaseFirestore.instance.collection(Collections.post).get();

      List<PostModel> posts = [];

      postsCollection.docs.map((element) {
        if (PostModel.fromMap(element.data()).userId ==
            UserModel.fromMap(user.data()!).userId) {
          posts.add((PostModel.fromMap(element.data())));
        }
      }).toList();

      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Left(
          ProfileModel(posts: posts, user: UserModel.fromMap(user.data()!)));
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

  Future<Either<ProfileModel, MainFailures>> getProfileById(
      {required String userId}) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(userId)
          .get();
      final postsCollection =
          await FirebaseFirestore.instance.collection(Collections.post).get();

      List<PostModel> posts = [];

      postsCollection.docs.map((element) {
        if (PostModel.fromMap(element.data()).userId ==
            UserModel.fromMap(user.data()!).userId) {
          posts.add((PostModel.fromMap(element.data())));
        }
      }).toList();

      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Left(
          ProfileModel(posts: posts, user: UserModel.fromMap(user.data()!)));
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
  Future<Either<EditProfileModel, MainFailures>> editProfile(
      {required EditProfileModel model}) async {
    try {
      final coverDestination =
          "user/${Global.USER_DATA.id}/cover/${Global.USER_DATA.id + DateTime.now().toString()}";
      final profileDestination =
          "user/${Global.USER_DATA.id}/profile/${Global.USER_DATA.id + DateTime.now().toString()}";
      String? newProfile;
      String? newCover;
      final userCollection = FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id);
      final userData = await userCollection.get();

      final user = UserModel.fromMap(userData.data()!);

      // if (model.name == user.name &&
      //     model.cover == user.coverImage &&
      //     model.discription == user.discription &&
      //     model.profile == user.profileImage) {
      //   return Left(model);
      // }

      await userCollection
          .update({'name': model.name, 'discription': model.discription});

      log("name And Disc Updated");

      if (model.cover == null) {
        await userCollection.update({"coverImage": null});
        log("cover image to null");
        newCover = null;
      } else {
        if (model.cover != user.coverImage) {
          UploadTask? task;
          log("cover image uploading");
          final ref = FirebaseStorage.instance.ref(coverDestination);
          task = ref.putFile(File(model.cover!));
          final snapShot = await task.whenComplete(() {});

          newCover = await snapShot.ref.getDownloadURL();
          await userCollection.update({"coverImage": newCover});
          log("cover image to $newCover");
        } else {
          log("now change in cover");
          newCover = model.cover;
        }
      }

      log('cover part done');

      if (model.profile == null) {
        await userCollection.update({"profileImage": null});
        log("prfile image to null");
        newProfile = null;
      } else {
        if (model.profile != user.profileImage) {
          UploadTask? task;
          log("cover image uploading");
          final ref = FirebaseStorage.instance.ref(profileDestination);
          task = ref.putFile(File(model.profile!));
          final snapShot = await task.whenComplete(() {});

          newProfile = await snapShot.ref.getDownloadURL();
          await userCollection.update({"profileImage": newProfile});
          log("cover image to $newProfile");
        } else {
          log("now change in pofile");
          newProfile = model.profile;
        }
      }

      log('profile part done');

      return Left(EditProfileModel(
        cover: newCover,
        discription: model.discription,
        name: model.name,
        profile: newProfile,
      ));
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
