// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateUserDto {
  final String username;
  final String password;
  final String name;
  final String phone;
  final int status;
  CreateUserDto({
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'name': name,
      'phone': phone,
      'status': status,
    };
  }

  factory CreateUserDto.fromMap(Map<String, dynamic> map) {
    return CreateUserDto(
      username: map['username'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateUserDto.fromJson(String source) =>
      CreateUserDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UpdateUserDto {
  final String password;
  final String name;
  final String phone;
  final int status;
  UpdateUserDto({
    required this.password,
    required this.name,
    required this.phone,
    required this.status,
  });

  UpdateUserDto copyWith({
    String? password,
    String? name,
    String? phone,
    int? status,
  }) {
    return UpdateUserDto(
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'password': password,
      'name': name,
      'phone': phone,
      'status': status,
    };
  }

  factory UpdateUserDto.fromMap(Map<String, dynamic> map) {
    return UpdateUserDto(
      password: map['password'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserDto.fromJson(String source) =>
      UpdateUserDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdateUserDto(password: $password, name: $name, phone: $phone, status: $status)';
  }
}
