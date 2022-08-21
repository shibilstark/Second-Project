import 'package:dartz/dartz.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';

abstract class HomeRepo {
  Future<Either<HomeDataModel, MainFailures>> getHomeFeeds();
  Future<Either<bool, MainFailures>> likeOrDislikePost(
      {required String postId, required bool shouldLike});
  Future<Either<PostCommentShowModel, MainFailures>> commentThePost(
      {required PostComment comment});
  Future<Either<List<PostCommentShowModel>, MainFailures>> getAllPostComments(
      {required String postId});
  Future<Either<bool, MainFailures>> deletePostComments(
      {required String postId, required String commentId});
}
