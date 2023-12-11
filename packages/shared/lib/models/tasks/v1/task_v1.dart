// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:shared/models/model_db.dart';

class TaskV1 extends ModelDb {
  const TaskV1({
    required this.status,
    required this.title,
    required this.content,

    // super
    required super.uid,
    required super.created_at,
    required super.updated_at,
  });

  final int status;
  final String title;
  final String content;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'status': status,
      'title': title,
      'content': content,
    };
  }

  factory TaskV1.fromMap(Map<String, dynamic> map) {
    return TaskV1(
      status: map['status'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      uid: map['uid'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      updated_at: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TaskV1.fromJson(String source) =>
      TaskV1.fromMap(json.decode(source) as Map<String, dynamic>);
}
