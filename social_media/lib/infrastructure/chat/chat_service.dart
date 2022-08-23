import 'package:social_media/domain/failures/main_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media/domain/models/chat/conversation.dart';
import 'package:social_media/infrastructure/chat/chat_repo.dart';
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
import 'package:uuid/uuid.dart';

class ChatService implements ChatRepo {
  @override
  Future<Either<ConverSationModel, MainFailures>> startMessage(
      {required String userId}) async {
    try {
      bool isStartedBefore = false;
      ConverSationModel? oldModel;
      final conversationCollection =
          FirebaseFirestore.instance.collection(Collections.conversations);

      final conversations = await conversationCollection.get();

      for (var element in conversations.docs) {
        final conversation = ConverSationModel.fromMap(element.data());

        if (conversation.members.contains(Global.USER_DATA.id) &&
            conversation.members.contains(userId)) {
          isStartedBefore = true;
          oldModel = conversation;
          break;
        } else {
          isStartedBefore = false;
          continue;
        }
      }
      ;
      if (isStartedBefore) {
        return Left(oldModel!);
      } else {
        final id = Uuid().v4();

        final model = ConverSationModel(
            conversationId: id, members: [Global.USER_DATA.id, userId]);
        await conversationCollection.doc(id).set(model.toMap());
        return Left(model);
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
