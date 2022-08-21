import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/functions/fb.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media/infrastructure/search/search_repo.dart';

class SearchServices implements SearchRepo {
  @override
  Future<Either<List<UserModel>, MainFailures>> searchPeople(
      {required String query}) async {
    try {
      List<UserModel> searchResults = [];
      final userCollection =
          await FirebaseFirestore.instance.collection(Collections.users).get();

      userCollection.docs.forEach((element) {
        final user = UserModel.fromMap(element.data());

        if (user.name
            .toLowerCase()
            .trim()
            .contains(query.toLowerCase().trim())) {
          searchResults.add(user);
        }
      });

      return Left(searchResults);
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
