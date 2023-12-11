// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:backend/core/models/res/result.dart';

///
class FailureResult extends ResultF {
  ///
  const FailureResult({
    required super.errorCode,
  }) : super(ok: false);
  @override
  String toString() => 'FailureResult(errorCode: $errorCode)';
  factory FailureResult.fromMap(Map<String, dynamic> map) {
    return FailureResult(
      errorCode: map['errorCode'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory FailureResult.fromJson(String source) =>
      FailureResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  ResultF copyWith({
    String? errorCode,
    bool? ok,
  }) {
    return ResultF(
      errorCode: errorCode ?? this.errorCode,
      ok: ok ?? this.ok,
    );
  }
}

///
class FailureResponse {
  ///
  const FailureResponse({
    required this.result,
    required this.time,
    required this.code,
  });

  ///
  final FailureResult result;
  final DateTime time;
  final int code;

  FailureResponse copyWith({
    FailureResult? result,
    DateTime? time,
    int? code,
  }) {
    return FailureResponse(
      result: result ?? this.result,
      time: time ?? this.time,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result.toMap(),
      'time': time.toIso8601String(),
      'code': code,
    };
  }

  factory FailureResponse.fromMap(Map<String, dynamic> map) {
    return FailureResponse(
      result: FailureResult.fromMap(map['result'] as Map<String, dynamic>),
      time: DateTime.parse(map['time'] as String),
      code: map['code'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FailureResponse.fromJson(String source) =>
      FailureResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
