import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/core/collections/firebase_collections.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream = FirebaseFirestore
      .instance
      .collection(Collections.conversations)
      .snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream() => chatStream;
  Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
      FirebaseFirestore.instance.collection(Collections.users).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserStream() => userStream;
  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream() =>
      FirebaseFirestore.instance.collection(Collections.messages).snapshots();

  // Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream() =>
  //     messagesStream;
}
