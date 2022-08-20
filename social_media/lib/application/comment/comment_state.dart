part of 'comment_cubit.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {
  List<PostCommentShowModel> comments;

  CommentSuccess(this.comments);
}

class CommentError extends CommentState {}
