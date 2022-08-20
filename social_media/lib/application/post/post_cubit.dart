import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/main/main_cubit.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';

part 'post_state.dart';

final destination =
    "posts/${Global.USER_DATA.id}/${Global.USER_DATA.id + DateTime.now().toString()}";
final thumbDestination =
    "posts/thumbs/${Global.USER_DATA.id}/${Global.USER_DATA.id + DateTime.now().toString()}";

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  MainCubit mainCubit;
  PostCubit({required this.postRepo, required this.mainCubit})
      : super(PostInitial());

  void uplaodPost({required PostModel model}) async {
    if (model.type == PostType.image) {
      final uploadStream =
          postRepo.uploadFile(post: model.post!, destination: destination);

      emit(PostUploading(uploadStream.snapshotEvents));

      final snap = await uploadStream.whenComplete(() {});
      final imageUrl = await snap.ref.getDownloadURL();

      final newPostModel = model.copyWith(post: imageUrl);

      await postRepo.publishPost(post: newPostModel).then((result) {
        result.fold((success) {
          mainCubit.addNewPost(newPostModel);

          emit(PostSuccess());
        }, (err) {
          emit(PostError(err));
        });
      });
    } else {
      final uploadStream =
          postRepo.uploadFile(post: model.post!, destination: destination);
      final thumbStream = postRepo.uploadFile(
          post: model.videoThumbnail!, destination: thumbDestination);
      emit(PostUploading(uploadStream.snapshotEvents));

      final snap = await uploadStream.whenComplete(() {});
      final thumSnap = await thumbStream.whenComplete(() {});
      final videoUrl = await snap.ref.getDownloadURL();
      final thumbUrl = await thumSnap.ref.getDownloadURL();

      final newPostModel =
          model.copyWith(post: videoUrl, videoThumbnail: thumbUrl);

      await postRepo.publishPost(post: newPostModel).then((result) {
        result.fold((success) {
          mainCubit.addNewPost(newPostModel);

          emit(PostSuccess());
        }, (err) {
          emit(PostError(err));
        });
      });
    }
  }
}
