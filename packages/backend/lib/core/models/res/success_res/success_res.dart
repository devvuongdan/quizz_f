// ignore_for_file: public_member_api_docs, sort_constructors_first,, lines_longer_than_80_chars
// ignore_for_file:avoid_unused_constructor_parameters
import 'dart:convert';

import 'package:backend/core/models/res/result.dart';

import 'package:shared/models/model_db.dart';

class SuccessResult extends ResultF {
  ///
  const SuccessResult() : super(ok: true, errorCode: 'null');
  @override
  String toString() => 'SuccessResult(errorCode: $errorCode)';
  factory SuccessResult.fromMap(Map<String, dynamic> map) {
    return const SuccessResult();
  }

  @override
  String toJson() => json.encode(toMap());

  factory SuccessResult.fromJson(String source) =>
      SuccessResult.fromMap(json.decode(source) as Map<String, dynamic>);

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

class SuccessResponseF<T extends ModelDb> {
  final DateTime time;
  final SuccessResult result;
  final T? data;
  final List<T>? dataList;
  const SuccessResponseF({
    required this.time,
    required this.result,
    this.data,
    this.dataList,
  }) : assert(
          !(data != null && dataList != null),
          'Please put data in data or data list!',
        );

  @override
  String toString() {
    return 'SuccessResponseF(time: $time, result: $result, data: $data, dataList: $dataList)';
  }

  SuccessResponseF<T> copyWith({
    DateTime? time,
    SuccessResult? result,
    T? data,
    List<T>? dataList,
  }) {
    return SuccessResponseF<T>(
      time: time ?? this.time,
      result: result ?? this.result,
      data: data ?? this.data,
      dataList: dataList ?? this.dataList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time.toIso8601String(),
      'result': result.toMap(),
      'data': data != null
          ? data?.toMap()
          : (dataList ?? []).map((x) => x.toMap()).toList(),
    };
  }
}
