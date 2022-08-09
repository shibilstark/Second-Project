import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';

abstract class PostRepo {
  UploadTask uploadFile({required String post, required String destination});
  Future<Either<bool, MainFailures>> publishPost({required PostModel post});
  Future<Either<bool, MainFailures>> deletePost(
      {required String postId, required String postUrl});
}
