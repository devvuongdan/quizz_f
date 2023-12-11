// ignore_for_file:  sort_constructors_first, avoid_print
// ignore_for_file: public_member_api_docs

import 'package:backend/core/exception/database_exceptions.dart';
import 'package:backend/core/models/res/failure_res/failure_res.dart';
import 'package:backend/core/models/res/failure_res/res_400.dart';
import 'package:backend/core/models/res/failure_res/res_404.dart';
import 'package:backend/core/models/res/failure_res/res_500.dart';
import 'package:backend/features/users/datasource.dart';
import 'package:backend/features/users/user_dto.dart';
import 'package:either_dart/either.dart';
import 'package:shared/models/users/user.dart';

abstract class UserRepository {
  Future<Either<FailureResponse, UserDB>> getUserProfile(String id);

  Future<Either<FailureResponse, UserDB>> createUserProfile(CreateUserDto dto);

  Future<Either<FailureResponse, UserDB>> updateUserProfile(
    UpdateUserDto dto,
    String id,
  );

  Future<Either<FailureResponse, UserDB>> deleteUserProfile(String id);

  Future<Either<FailureResponse, List<UserDB>>> getAllUser();
}

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;
  UserRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<FailureResponse, UserDB>> createUserProfile(
    CreateUserDto dto,
  ) async {
    try {
      //VALIDATE INPUT
      if (dto.password.length < 6 || dto.password.length > 20) {
        return Left(
          Response400(
            time: DateTime.now(),
            result: const FailureResult(errorCode: 'password-invalid'),
          ),
        );
      }
      if (dto.username.length < 6) {
        return Left(
          Response400(
            time: DateTime.now(),
            result: const FailureResult(errorCode: 'username-invalid'),
          ),
        );
      }

      //User Exist
      final userDB =
          await datasource.getUserByUsername(dto.username, init: true);
      if (userDB != null) {
        print(userDB);
        return Left(
          Response400(
            time: DateTime.now(),
            result: const FailureResult(errorCode: 'username-has-existed'),
          ),
        );
      }
      final result = await datasource.createUser(dto);
      return Right(result);
    } on DataBaseException {
      return Left(
        Response500(time: DateTime.now()),
      );
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, UserDB>> deleteUserProfile(String id) async {
    try {
      final result = await datasource.deleteUser(id);
      return Right(result);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, UserDB>> getUserProfile(String id) async {
    try {
      final result = await datasource.getUserByID(id);
      return Right(result);
    } on NotFoundException {
      return Left(Response404(time: DateTime.now()));
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, UserDB>> updateUserProfile(
    UpdateUserDto dto,
    String id,
  ) async {
    try {
      //VALIDATE INPUT
      if (dto.password.length < 6 || dto.password.length > 20) {
        return Left(
          Response400(
            time: DateTime.now(),
            result: const FailureResult(errorCode: 'password-invalid'),
          ),
        );
      }

      //User Exist
      await datasource.getUserByID(id);
      final result = await datasource.updateUser(dto, id);
      return Right(result);
    } on DataBaseException {
      return Left(
        Response500(time: DateTime.now()),
      );
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, List<UserDB>>> getAllUser() async {
    try {
      final users = await datasource.getUsers();
      return Right(users);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }
}
