// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';

class PostCommentShowModel {
  UserModel userModel;
  String comment;
  DateTime time;
  String id;
  String postId;

  PostCommentShowModel(
      {required this.userModel,
      required this.comment,
      required this.time,
      required this.id,
      required this.postId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userModel': userModel.toMap(),
      'comment': comment,
      'time': time.millisecondsSinceEpoch,
      'id': id,
      'postId': postId,
    };
  }

  factory PostCommentShowModel.fromMap(Map<String, dynamic> map) {
    return PostCommentShowModel(
      userModel: UserModel.fromMap(map['userModel'] as Map<String, dynamic>),
      comment: map['comment'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      id: map['id'] as String,
      postId: map['postId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostCommentShowModel.fromJson(String source) =>
      PostCommentShowModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
