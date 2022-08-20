import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/home/home_services.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final HomeRepo homeRepo;
  CommentCubit({required this.homeRepo}) : super(CommentInitial());

  void getAllComments({required String postId}) async {
    emit(CommentLoading());

    await homeRepo.getAllPostComments(postId: postId).then((value) {
      value.fold(
        (success) {
          emit(CommentSuccess(success));
        },
        (fail) {
          emit(CommentError());
        },
      );
    });
  }

  void commentThePost({required PostComment comment}) async {
    await homeRepo.commentThePost(comment: comment).then((value) {
      value.fold((l) {
        final currentState = state;

        if (currentState is CommentSuccess) {
          emit(CommentSuccess(List.from(currentState.comments)..add(l)));
        }
      }, (r) {});
    });
  }
}
