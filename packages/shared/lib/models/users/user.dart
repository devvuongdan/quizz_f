// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:shared/models/model_db.dart';

class UserDB extends ModelDb {
  final String username;
  final String password;
  final DateTime updated_pw_at;
  final String name;
  final String phone;
  final int status;
  UserDB({
    required this.username,
    required this.password,
    required this.updated_pw_at,
    required this.name,
    required this.phone,
    required this.status,
    // super
    required super.uid,
    required super.created_at,
    required super.updated_at,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'username': username,
      'password': password,
      'updated_pw_at': updated_pw_at.toIso8601String(),
      'name': name,
      'phone': phone,
      'status': status,
    };
  }

  factory UserDB.fromMap(Map<String, dynamic> map) {
    return UserDB(
      uid: map['uid'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      updated_at: DateTime.parse(map['updated_at'] as String),
      username: map['username'] as String,
      password: map['password'] as String,
      updated_pw_at: DateTime.parse(map['updated_pw_at'] as String),
      name: map['name'] as String,
      phone: map['phone'] as String,
      status: map['status'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserDB.fromJson(String source) =>
      UserDB.fromMap(json.decode(source) as Map<String, dynamic>);

  UserDB copyWithX({
    String? password,
    DateTime? updated_pw_at,
    DateTime? updated_at,
    String? name,
    String? phone,
    int? status,
  }) {
    return UserDB(
      uid: uid,
      created_at: created_at,
      username: username,

      //
      password: password ?? this.password,
      updated_pw_at: updated_pw_at ?? this.updated_pw_at,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
