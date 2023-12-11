// ignore_for_file: no_default_cases

import 'dart:convert';

import 'package:backend/core/models/res/failure_res/res_405.dart';
import 'package:backend/core/models/res/failure_res/res_500.dart';
import 'package:backend/core/models/res/success_res/success_res.dart';
import 'package:backend/features/users/repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/users/user.dart';

//ADMIN ONLY
Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _onGet(context);

    default:
      final err = Response405(
        time: DateTime.now(),
      );
      return Response.json(
        statusCode: err.code,
        body: err.toMap(),
      );
  }
}

Future<Response> _onGet(RequestContext context) async {
  final body = await context.request.body();
  final map = jsonDecode(body) as Map<String, dynamic>;
  if (map['key'] != '0355240298') {
    final err = Response500(
      time: DateTime.now(),
    );
    return Response.json(statusCode: err.code, body: err.toMap());
  }
  final repo = context.read<UserRepositoryImpl>();
  final result = await repo.getAllUser();

  if (result is Right) {
    final response = SuccessResponseF<UserDB>(
      time: DateTime.now(),
      result: const SuccessResult(),
      dataList: result.right,
    );
    return Response.json(
      body: response.toMap(),
    );
  } else {
    final err = Response500(
      time: DateTime.now(),
    );
    return Response.json(statusCode: err.code, body: err.toMap());
  }
}
