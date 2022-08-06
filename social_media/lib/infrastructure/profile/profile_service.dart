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

  @override
  Future<Either<EditNameAndDiscModel, MainFailures>> editNameAndDiscPic(
      {required String name, required String? disc}) async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id);

      await userData.update({'name': name, 'discription': disc});

      return Left(EditNameAndDiscModel(discription: disc, name: name));
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
  Future<Either<String?, MainFailures>> upadateCoverPic(
      {required String? newPic}) async {
    try {
      final userData = FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id);

      if (newPic == null) {
        await userData.update({'coverImage': null});

        return const Left(null);
      } else {
        UploadTask? task;

        final imageDestination =
            "${Global.USER_DATA.id}/profile/${DateTime.now().toString()}";

        final ref = FirebaseStorage.instance.ref(imageDestination);
        task = ref.putFile(File(newPic));
        final snapShot = await task.whenComplete(() {});

        final imageUrl = await snapShot.ref.getDownloadURL();

        await userData.update({'coverImage': imageUrl});

        return Left(imageUrl);
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
  Future<Either<String?, MainFailures>> upadateProfilePic(
      {required String? newPic}) async {
    try {
      final userData = FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id);

      if (newPic == null) {
        await userData.update({'profileImage': null});

        return const Left(null);
      } else {
        UploadTask? task;
        UploadTask? thumbTask;
        final imageDestination =
            "${Global.USER_DATA.id}/profile/${DateTime.now().toString()}";

        final ref = FirebaseStorage.instance.ref(imageDestination);
        task = ref.putFile(File(newPic));
        final snapShot = await task.whenComplete(() {});

        final imageUrl = await snapShot.ref.getDownloadURL();

        await userData.update({'profileImage': imageUrl});

        return Left(imageUrl);
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
}
