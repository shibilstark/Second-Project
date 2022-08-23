import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/functions/fb.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/home_feed/home_feed_model.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/post_report_model/reports_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:uuid/uuid.dart';

class HomeServices implements HomeRepo {
  @override
  Future<Either<HomeDataModel, MainFailures>> getHomeFeeds() async {
    try {
      final userCollection =
          await FirebaseFirestore.instance.collection(Collections.users).get();
      final thisUserData = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id)
          .get();
      List<HomeFeedModel> homefeed = [];
      List<UserModel> peoples = [];

      final thisUser = UserModel.fromMap(thisUserData.data()!);

      userCollection.docs.forEach((u) {
        final user = UserModel.fromMap(u.data());

        if (user.userId != Global.USER_DATA.id &&
            !thisUser.followers.contains(user.userId)) {
          peoples.add(user);
        }
      });

      final postCollection =
          await FirebaseFirestore.instance.collection(Collections.post).get();

      postCollection.docs.forEach((postData) {
        final post = PostModel.fromMap(postData.data());

        userCollection.docs.forEach((userData) {
          final user = UserModel.fromMap(userData.data());

          if (user.userId == post.userId) {
            homefeed.add(HomeFeedModel(post: post, user: user));
          }
        });
      });

      return Left(HomeDataModel(peoples: peoples, homeFeedModel: homefeed));
    } on FirebaseException catch (e) {
      return Right(MainFailures(
          error: firebaseCodeFix(e.code),
          failureType: MyAppFilures.clientFailure));
    } catch (e) {
      return Right(MainFailures(
          error: e.toString(), failureType: MyAppFilures.clientFailure));
    }
  }

  Future<Either<bool, MainFailures>> likeOrDislikePost(
      {required String postId, required bool shouldLike}) async {
    try {
      bool isLiked = false;
      final userId = Global.USER_DATA.id;

      final post =
          FirebaseFirestore.instance.collection(Collections.post).doc(postId);

      if (shouldLike) {
        await post.update({
          "lights": FieldValue.arrayUnion([userId])
        });
        isLiked = true;
      } else {
        await post.update({
          "lights": FieldValue.arrayRemove([userId])
        });
        isLiked = false;
      }

      return Left(isLiked);
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
  Future<Either<PostCommentShowModel, MainFailures>> commentThePost(
      {required PostComment comment}) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(Global.USER_DATA.id)
          .get();
      final commentsCollection = FirebaseFirestore.instance
          .collection(Collections.comments)
          .doc(comment.commentId);

      await commentsCollection.set(comment.toMap());

      final post = FirebaseFirestore.instance
          .collection(Collections.post)
          .doc(comment.postId);

      post.update({
        'comments': FieldValue.arrayUnion([comment.commentId])
      });

      final PostCommentShowModel postCommentShowModel = PostCommentShowModel(
          userModel: UserModel.fromMap(user.data()!),
          comment: comment.commentText,
          time: comment.time,
          id: comment.commentId,
          postId: comment.postId);

      return Left(postCommentShowModel);
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
  Future<Either<List<PostCommentShowModel>, MainFailures>> getAllPostComments(
      {required String postId}) async {
    try {
      List<PostCommentShowModel> showComments = [];

      final user =
          await FirebaseFirestore.instance.collection(Collections.users).get();

      final post = await FirebaseFirestore.instance
          .collection(Collections.post)
          .doc(postId)
          .get();
      final commentsCollection = await FirebaseFirestore.instance
          .collection(Collections.comments)
          .get();

      PostModel.fromMap(post.data()!).comments.forEach((com) {
        commentsCollection.docs.forEach((element) {
          final postComment = PostComment.fromMap(element.data());
          if (postComment.commentId == com) {
            final userData = user.docs.firstWhere(
                (element) => element['userId'] == postComment.reacterId);
            final userModel = UserModel.fromMap(userData.data());

            showComments.add(PostCommentShowModel(
                userModel: userModel,
                comment: postComment.commentText,
                time: postComment.time,
                id: postComment.commentId,
                postId: postComment.postId));
          }
        });
      });

      showComments.sort(
        (a, b) {
          return b.time.compareTo(a.time);
        },
      );

      log(showComments.length.toString());
      return Left(showComments);
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
  Future<Either<bool, MainFailures>> deletePostComments(
      {required String postId, required String commentId}) async {
    try {
      final comment = FirebaseFirestore.instance
          .collection(Collections.comments)
          .doc(commentId);
      final post =
          FirebaseFirestore.instance.collection(Collections.post).doc(postId);

      await post.update({
        'comments': FieldValue.arrayRemove([commentId])
      });

      await comment.delete();

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
  Future<Either<bool, MainFailures>> reportPost(
      {required String postId,
      required String reportType,
      required String reportDiscription}) async {
    try {
      final currentPost =
          FirebaseFirestore.instance.collection(Collections.post).doc(postId);

      final reportId = Uuid().v4();
      final date = DateTime.now();

      ReportsModel reportsModel = ReportsModel(
          id: reportId,
          reportedAt: date,
          reporter: Global.USER_DATA.id,
          postId: postId,
          discription: reportDiscription,
          reportType: reportType);
      await FirebaseFirestore.instance
          .collection(Collections.reports)
          .doc(reportId)
          .set(reportsModel.toMap());

      await currentPost.update({
        'reports': FieldValue.arrayUnion([reportId])
      });

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
