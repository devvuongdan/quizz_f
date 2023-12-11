// ignore_for_file: public_member_api_docs

import 'package:backend/features/users/user_dto.dart';
import 'package:shared/models/users/user.dart';

abstract class UserDatasource {
  Future<UserDB> createUser(
    CreateUserDto dto,
  );

  Future<UserDB> updateUser(
    CreateUserDto dto,
  );

  Future<UserDB> getUserByID(
    String id,
  );

  Future<UserDB> deleteUser(
    String id,
  );

  //ADMIN OR SEARCHING ONLY
  Future<List<UserDB>> getUsers();
}

class UserDatasourceImpl implements UserDatasource {
  @override
  Future<UserDB> createUser(CreateUserDto dto) async {
    throw UnimplementedError();
  }

  @override
  Future<UserDB> deleteUser(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<UserDB> getUserByID(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<UserDB>> getUsers() async {
    throw UnimplementedError();
  }

  @override
  Future<UserDB> updateUser(CreateUserDto dto) async {
    throw UnimplementedError();
  }
}
