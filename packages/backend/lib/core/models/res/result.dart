// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResultF {
  final String errorCode;
  final bool ok;
  const ResultF({
    required this.errorCode,
    required this.ok,
  });

  @override
  String toString() => 'ResultF(errorCode: $errorCode, ok: $ok)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'errorCode': errorCode,
      'ok': ok,
    };
  }

  factory ResultF.fromMap(Map<String, dynamic> map) {
    return ResultF(
      errorCode: map['errorCode'] as String,
      ok: map['ok'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultF.fromJson(String source) =>
      ResultF.fromMap(json.decode(source) as Map<String, dynamic>);

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
