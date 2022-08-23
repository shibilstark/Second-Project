import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReportsModel {
  final String reporter;
  final String id;
  final String postId;
  final String discription;
  final String reportType;
  final DateTime reportedAt;

  ReportsModel({
    required this.id,
    required this.reportedAt,
    required this.reporter,
    required this.postId,
    required this.discription,
    required this.reportType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reporter': reporter,
      'id': id,
      'postId': postId,
      'discription': discription,
      'reportType': reportType,
      'reportedAt': reportedAt.millisecondsSinceEpoch,
    };
  }

  factory ReportsModel.fromMap(Map<String, dynamic> map) {
    return ReportsModel(
      reporter: map['reporter'] as String,
      id: map['id'] as String,
      postId: map['postId'] as String,
      discription: map['discription'] as String,
      reportType: map['reportType'] as String,
      reportedAt: DateTime.fromMillisecondsSinceEpoch(map['reportedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportsModel.fromJson(String source) =>
      ReportsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
