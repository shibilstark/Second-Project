import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConverSationModel {
  final String conversationId;
  final List<String> members;

  ConverSationModel({required this.conversationId, required this.members});

  ConverSationModel copyWith({
    String? conversationId,
    List<String>? members,
  }) {
    return ConverSationModel(
      conversationId: conversationId ?? this.conversationId,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'members': members,
    };
  }

  factory ConverSationModel.fromMap(Map<String, dynamic> map) {
    return ConverSationModel(
      conversationId: map['conversationId'] as String,
      members: List<String>.from((map['members']) as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConverSationModel.fromJson(String source) =>
      ConverSationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
