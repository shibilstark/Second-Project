part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {
  List<PostCommentShowModel> comments;
  CommentSuccess({required this.comments});
  @override
  List<Object> get props => [comments];
}

class CommentError extends CommentState {}
