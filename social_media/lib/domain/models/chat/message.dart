import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  final String conversationId;
  final String senderId;
  final String id;
  final String type;
  final String message;
  final DateTime time;

  MessageModel(
      {required this.conversationId,
      required this.senderId,
      required this.id,
      required this.type,
      required this.message,
      required this.time});

  MessageModel copyWith({
    String? conversationId,
    String? senderId,
    String? id,
    String? type,
    String? message,
    DateTime? time,
  }) {
    return MessageModel(
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'senderId': senderId,
      'id': id,
      'type': type,
      'message': message,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      conversationId: map['conversationId'] as String,
      senderId: map['senderId'] as String,
      id: map['id'] as String,
      type: map['type'] as String,
      message: map['message'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MessageType {
  static final String text = 'text';
  static final String image = 'image';
  static final String video = 'video';
}
