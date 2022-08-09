import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/functions/fb.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';

@LazySingleton(as: PostRepo)
class PostServices extends PostRepo {
  @override
  Future<Either<bool, MainFailures>> publishPost(
      {required PostModel post}) async {
    try {
      final postCollection =
          FirebaseFirestore.instance.collection(Collections.post);

      await postCollection.doc(post.postId).set(post.toMap());

      return Left(true);
    } on FirebaseException catch (e) {
      log(e.toString());

      log("firebase error");

      return Right(MainFailures(
          failureType: MyAppFilures.firebaseFailure,
          error: firebaseCodeFix(e.code)));
    } catch (e) {
      log(e.toString());
      log("client error");

      return Right(MainFailures(
          failureType: MyAppFilures.clientFailure,
          error: firebaseCodeFix(e.toString())));
    }
  }

  @override
  UploadTask uploadFile({required String post, required String destination}) {
    UploadTask? task;

    final ref = FirebaseStorage.instance.ref(destination);
    task = ref.putFile(File(post));

    return task;
  }

  @override
  Future<Either<bool, MainFailures>> deletePost(
      {required String postId, required String postUrl}) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection(Collections.post)
          .doc(postId)
          .delete();

      await FirebaseStorage.instance.refFromURL(postUrl).delete();

      return Left(true);
    } on FirebaseException catch (e) {
      log(e.toString());

      log("firebase error");

      return Right(MainFailures(
          failureType: MyAppFilures.firebaseFailure,
          error: firebaseCodeFix(e.code)));
    } catch (e) {
      log(e.toString());
      log("client error");

      return Right(MainFailures(
          failureType: MyAppFilures.clientFailure,
          error: firebaseCodeFix(e.toString())));
    }
  }
}
