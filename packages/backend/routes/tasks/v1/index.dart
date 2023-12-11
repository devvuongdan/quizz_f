// ignore_for_file: no_default_cases

import 'dart:math';

import 'package:backend/core/models/res/failure_res/failure_res.dart';
import 'package:backend/core/models/res/failure_res/res_405.dart';
import 'package:backend/core/models/res/failure_res/res_500.dart';
import 'package:backend/core/models/res/success_res/success_res.dart';
import 'package:backend/features/tasks/v1/datasource.dart';
import 'package:backend/features/tasks/v1/task_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/tasks/v1/task_v1.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _onGet(context);
    case HttpMethod.post:
      return _onPost(context);

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

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<TaskV1DataSourceImpl>();
  final body = await context.request.body();
  final dto = TaskDto.fromJson(body);
  final result = await repo.createTask(dto);
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

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<TaskV1DataSourceImpl>();
  late Either<FailureResponse, List<TaskV1>> result;
  final params = context.request.uri.queryParameters;

  int? limit;
  int? offset;
  String? query;
  int? status;

  if (params.isNotEmpty) {
    //Pagination
    limit = int.tryParse(params['limit'].toString());
    offset = int.tryParse(params['offset'].toString());

    //Filter theo status
    status = int.tryParse(params['status'].toString());

    //Tìm kiếm theo tên hoặc mô tả
    query = params['query'];
  }

  if (query != null) {
    result = await repo.getTasks(
      condition: (task) {
        return task.content.toUpperCase().contains(query ?? '') ||
            task.title.toUpperCase().contains(query ?? '');
      },
    );
  } else {
    result = await repo.getTasks(
      condition: (_) => true,
    );
  }

  if (result is Right) {
    final start = offset == null ? 0 : min(result.right.length - 1, offset);
    final end = limit == null
        ? result.right.length - 1
        : min(result.right.length - 1, start + limit);

    final equalDataList = result.right
      ..retainWhere((element) {
        if (status != null) {
          return element.status == status;
        } else {
          return true;
        }
      });
    final paginationDataList = equalDataList
        .getRange(
          start,
          end,
        )
        .toList();

    final response = SuccessResponseF<TaskV1>(
      time: DateTime.now(),
      result: const SuccessResult(),
      dataList: paginationDataList,
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
