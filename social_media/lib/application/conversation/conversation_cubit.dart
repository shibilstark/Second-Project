import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/application/comment/comment_cubit.dart';
import 'package:social_media/domain/models/chat/conversation.dart';
import 'package:social_media/infrastructure/chat/chat_repo.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit({required this.chatRepo}) : super(ConversationInitial());

  final ChatRepo chatRepo;

  void createConverSation({required String userId}) async {
    emit(ConversationLoading());
    await chatRepo.startMessage(userId: userId).then((value) {
      value.fold((success) {
        emit(ConversationSuccess(success));
      }, (r) {
        emit(ConversationError());
      });
    });
  }
}
