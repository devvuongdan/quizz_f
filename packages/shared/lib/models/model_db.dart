import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class ModelDb {
  final String uid;
  final DateTime created_at;
  final DateTime updated_at;
  const ModelDb({
    required this.uid,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
    };
  }

  factory ModelDb.fromMap(Map<String, dynamic> map) {
    return ModelDb(
      uid: map['uid'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      updated_at: DateTime.parse(map['updated_at'] as String),
    );
  }

  ModelDb fromMapDb(Map<String, dynamic> map) => ModelDb.fromMap(map);

  String toJson() => json.encode(toMap());

  factory ModelDb.fromJson(String source) =>
      ModelDb.fromMap(json.decode(source) as Map<String, dynamic>);

  copyWith({
    String? uid,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    throw UnimplementedError();
  }
}
