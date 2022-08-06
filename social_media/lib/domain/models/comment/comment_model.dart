// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostComment {
  String reacterId;
  String commentText;
  DateTime time;
  String id;

  PostComment(
      {required this.reacterId,
      required this.commentText,
      required this.time,
      required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reacterId': reacterId,
      'commentText': commentText,
      'time': time.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      reacterId: map['reacterId'] as String,
      commentText: map['commentText'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostComment.fromJson(String source) =>
      PostComment.fromMap(json.decode(source) as Map<String, dynamic>);

  PostComment copyWith({
    String? reacterId,
    String? commentText,
    DateTime? time,
    String? id,
  }) {
    return PostComment(
      reacterId: reacterId ?? this.reacterId,
      commentText: commentText ?? this.commentText,
      time: time ?? this.time,
      id: id ?? this.id,
    );
  }
}
