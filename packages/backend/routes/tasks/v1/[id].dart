// ignore_for_file: no_default_cases

import 'package:backend/core/models/res/failure_res/res_405.dart';
import 'package:backend/core/models/res/failure_res/res_500.dart';
import 'package:backend/core/models/res/success_res/success_res.dart';
import 'package:backend/features/tasks/v1/datasource.dart';
import 'package:backend/features/tasks/v1/task_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/tasks/v1/task_v1.dart';

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
  final repo = context.read<TaskV1DataSourceImpl>();
  final result = await repo.deleteTaskByID(id);

  if (result is Right) {
    final taskV1 = TaskV1(
      status: -10,
      title: '',
      content: '',
      uid: id,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );
    final response = SuccessResponseF<TaskV1>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: taskV1,
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

Future<Response> _onPatch(RequestContext context, String id) async {
  final repo = context.read<TaskV1DataSourceImpl>();
  final body = await context.request.body();
  final dto = TaskDto.fromJson(body);
  final result = await repo.updateTask(dto, id);
  if (result is Right) {
    final response = SuccessResponseF<TaskV1>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: result.right,
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

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<TaskV1DataSourceImpl>();
  final result = await repo.getTaskByID(id);
  if (result is Right) {
    final response = SuccessResponseF<TaskV1>(
      time: DateTime.now(),
      result: const SuccessResult(),
      data: result.right,
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
