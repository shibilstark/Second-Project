part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUploading extends PostState {
  Stream<TaskSnapshot> uploadStream;
  PostUploading(this.uploadStream);
  @override
  List<Object> get props => [uploadStream];
}

class PostSuccess extends PostState {}

class PostError extends PostState {
  MainFailures fail;
  PostError(this.fail);
  @override
  List<Object> get props => [fail];
}
