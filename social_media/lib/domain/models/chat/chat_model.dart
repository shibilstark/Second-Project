import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  List<String> converSationId;
  String sender;
  String reciever;
  String messageType;
  String message;
  DateTime time;
  bool isSenderHided;
  bool isRecieverHided;
  MessageModel({
    required this.sender,
    required this.reciever,
    required this.message,
    required this.time,
    required this.isSenderHided,
    required this.isRecieverHided,
    required this.messageType,
    required this.converSationId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'converSationId': converSationId,
      'sender': sender,
      'reciever': reciever,
      'messageType': messageType,
      'message': message,
      'time': time.millisecondsSinceEpoch,
      'isSenderHided': isSenderHided,
      'isRecieverHided': isRecieverHided,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      converSationId:
          List<String>.from((map['converSationId'] as List<dynamic>)),
      sender: map['sender'] as String,
      reciever: map['reciever'] as String,
      messageType: map['messageType'] as String,
      message: map['message'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      isSenderHided: map['isSenderHided'] as bool,
      isRecieverHided: map['isRecieverHided'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MessageType {
  static String text = "text";
  static String video = "video";
  static String audio = "audio";
  static String image = "image";
}
