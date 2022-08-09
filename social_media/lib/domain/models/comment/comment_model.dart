// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostComment {
  String reacterId;
  String commentText;
  DateTime time;
  String postId;
  String commentId;

  PostComment(
      {required this.reacterId,
      required this.commentText,
      required this.time,
      required this.postId,
      required this.commentId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reacterId': reacterId,
      'commentText': commentText,
      'time': time.millisecondsSinceEpoch,
      'postId': postId,
      'commentId': commentId
    };
  }

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      reacterId: map['reacterId'] as String,
      commentText: map['commentText'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      postId: map['postId'] as String,
      commentId: map['commentId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostComment.fromJson(String source) =>
      PostComment.fromMap(json.decode(source) as Map<String, dynamic>);

  PostComment copyWith({
    String? reacterId,
    String? commentText,
    DateTime? time,
    String? postId,
    String? commentId,
  }) {
    return PostComment(
      reacterId: reacterId ?? this.reacterId,
      commentText: commentText ?? this.commentText,
      time: time ?? this.time,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
    );
  }
}
