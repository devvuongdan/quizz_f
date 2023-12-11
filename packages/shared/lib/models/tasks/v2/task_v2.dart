// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:shared/models/model_db.dart';

class TaskV2 extends ModelDb {
  const TaskV2({
    required this.status,
    required this.title,
    required this.content,

    // super
    required super.uid,
    required super.created_at,
    required super.updated_at,

    //v2
    required this.user_uid,
  });

  final int status;
  final String title;
  final String content;

  //v2 with auth
  final String user_uid;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'title': title,
      'content': content,
      'uid': uid,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'user_uid': user_uid,
    };
  }

  factory TaskV2.fromMap(Map<String, dynamic> map) {
    return TaskV2(
      status: map['status'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      uid: map['uid'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      updated_at: DateTime.parse(map['updated_at'] as String),
      user_uid: map['user_uid'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TaskV2.fromJson(String source) =>
      TaskV2.fromMap(json.decode(source) as Map<String, dynamic>);
}
