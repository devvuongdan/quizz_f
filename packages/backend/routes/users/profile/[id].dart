// ignore_for_file: no_default_cases

import 'package:backend/core/models/res/failure_res/res_405.dart';
import 'package:backend/core/models/res/success_res/success_res.dart';
import 'package:backend/features/users/repository.dart';
import 'package:backend/features/users/user_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/users/user.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _onGet(context, id);
    case HttpMethod.patch:
      return _onPatch(context, id);
    case HttpMethod.delete:
      return _onDelete(context, id);

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

Future<Response> _onDelete(RequestContext context, String id) async {
  final repo = context.read<UserRepositoryImpl>();
  final result = await repo.deleteUserProfile(id);

  if (result is Right) {
    final response = SuccessResponseF<UserDB>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: result.right,
    );
    return Response.json(
      body: response.toMap(),
    );
  } else {
    return Response.json(
      statusCode: result.left.code,
      body: result.left..toMap(),
    );
  }
}

Future<Response> _onPatch(RequestContext context, String id) async {
  final repo = context.read<UserRepositoryImpl>();
  final body = await context.request.body();
  final dto = UpdateUserDto.fromJson(body);

  final result = await repo.updateUserProfile(dto, id);

  if (result is Right) {
    final response = SuccessResponseF<UserDB>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: result.right,
    );
    return Response.json(
      body: response.toMap(),
    );
  } else {
    return Response.json(
      statusCode: result.left.code,
      body: result.left.toMap(),
    );
  }
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<UserRepositoryImpl>();
  final result = await repo.getUserProfile(id);
  if (result is Right) {
    final response = SuccessResponseF<UserDB>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: result.right,
    );
    return Response.json(
      body: response.toMap(),
    );
  } else {
    return Response.json(
      statusCode: result.left.code,
      body: result.left.toMap(),
    );
  }
}
