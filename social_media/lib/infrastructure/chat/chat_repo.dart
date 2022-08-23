import 'package:dartz/dartz.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/chat/conversation.dart';

abstract class ChatRepo {
  Future<Either<ConverSationModel, MainFailures>> startMessage(
      {required String userId});
}
