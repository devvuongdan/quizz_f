// ignore_for_file: no_default_cases

import 'package:backend/core/models/res/failure_res/res_405.dart';
import 'package:backend/core/models/res/success_res/success_res.dart';
import 'package:backend/features/users/repository.dart';
import 'package:backend/features/users/user_dto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/users/user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    // case HttpMethod.get:
    //   return _onGet(context);
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
  final repo = context.read<UserRepositoryImpl>();
  final body = await context.request.body();
  final dto = CreateUserDto.fromJson(body);
  final result = await repo.createUserProfile(dto);

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
    final err = result.left;
    return Response.json(statusCode: err.code, body: err.toMap());
  }
}

// Future<Response> _onGet(RequestContext context) async {
//   final body = await context.request.body();
//   print(body);
//   // final Map<String, dynamic> map = jsonDecode(body);
//   final repo = context.read<UserRepositoryImpl>();

//   final result = await repo.getAllUser();

//   if (result is Right) {
//     final response = SuccessResponseF<UserDB>(
//       time: DateTime.now(),
//       result: const SuccessResult(),
//       dataList: result.right,
//     );
//     return Response.json(
//       body: response.toMap(),
//     );
//   } else {
//     final err = Response500(
//       time: DateTime.now(),
//     );
//     return Response.json(statusCode: err.code, body: err.toMap());
//   }
// }
